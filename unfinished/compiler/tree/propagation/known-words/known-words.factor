! Copyright (C) 2008 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel effects accessors math math.private math.libm
math.partial-dispatch math.intervals layouts words sequences
sequences.private arrays assocs classes classes.algebra
combinators generic.math fry locals
compiler.tree.propagation.info
compiler.tree.propagation.nodes
compiler.tree.propagation.constraints ;
IN: compiler.tree.propagation.known-words

\ fixnum
most-negative-fixnum most-positive-fixnum [a,b]
+interval+ set-word-prop

\ array-capacity
0 max-array-capacity [a,b]
+interval+ set-word-prop

{ + - * / }
[ { number number } "input-classes" set-word-prop ] each

{ /f < > <= >= }
[ { real real } "input-classes" set-word-prop ] each

{ /i mod /mod }
[ { rational rational } "input-classes" set-word-prop ] each

{ bitand bitor bitxor bitnot shift }
[ { integer integer } "input-classes" set-word-prop ] each

\ bitnot { integer } "input-classes" set-word-prop

{
    fcosh
    flog
    fsinh
    fexp
    fasin
    facosh
    fasinh
    ftanh
    fatanh
    facos
    fpow
    fatan
    fatan2
    fcos
    ftan
    fsin
    fsqrt
} [
    dup stack-effect
    [ in>> length real <repetition> "input-classes" set-word-prop ]
    [ out>> length float <repetition> "default-output-classes" set-word-prop ]
    2bi
] each

: ?change-interval ( info quot -- quot' )
    over interval>> [ [ clone ] dip change-interval ] [ 2drop ] if ; inline

{ bitnot fixnum-bitnot bignum-bitnot } [
    [ [ interval-bitnot ] ?change-interval ] +outputs+ set-word-prop
] each

\ abs [ [ interval-abs ] ?change-interval ] +outputs+ set-word-prop

: math-closure ( class -- newclass )
    { null fixnum bignum integer rational float real number }
    [ class<= ] with find nip number or ;

: interval-subset?' ( i1 i2 -- ? )
    {
        { [ over not ] [ 2drop t ] }
        { [ dup not ] [ 2drop f ] }
        [ interval-subset? ]
    } cond ;

: fits? ( interval class -- ? )
    +interval+ word-prop interval-subset?' ;

: binary-op-class ( info1 info2 -- newclass )
    [ class>> math-closure ] bi@ math-class-max ;

: binary-op-interval ( info1 info2 quot -- newinterval )
    [ [ interval>> ] bi@ 2dup and ] dip [ 2drop f ] if ; inline

: <class/interval-info> ( class interval -- info )
    [ f f <value-info> ] [ <class-info> ] if* ;

: won't-overflow? ( class interval -- ? )
    [ fixnum class<= ] [ fixnum fits? ] bi* and ;

: may-overflow ( class interval -- class' interval' )
    2dup won't-overflow?
    [ [ integer math-class-max ] dip ] unless ;

: may-be-rational ( class interval -- class' interval' )
    over null class<= [
        [ rational math-class-max ] dip
    ] unless ;

: integer-valued ( class interval -- class' interval' )
    [ integer math-class-min ] dip ;

: real-valued ( class interval -- class' interval' )
    [ real math-class-min ] dip ;

: float-valued ( class interval -- class' interval' )
    over null class<= [
        [ drop float ] dip
    ] unless ;

: binary-op ( word interval-quot post-proc-quot -- )
    '[
        [ binary-op-class ] [ , binary-op-interval ] 2bi
        @
        <class/interval-info>
    ] +outputs+ set-word-prop ;

\ + [ [ interval+ ] [ may-overflow ] binary-op ] each-derived-op
\ + [ [ interval+ ] [ ] binary-op ] each-fast-derived-op

\ - [ [ interval+ ] [ may-overflow ] binary-op ] each-derived-op
\ - [ [ interval+ ] [ ] binary-op ] each-fast-derived-op

\ * [ [ interval* ] [ may-overflow ] binary-op ] each-derived-op
\ * [ [ interval* ] [ ] binary-op ] each-fast-derived-op

\ shift [ [ interval-shift-safe ] [ may-overflow ] binary-op ] each-derived-op
\ shift [ [ interval-shift-safe ] [ ] binary-op ] each-fast-derived-op

\ / [ [ interval/-safe ] [ may-be-rational ] binary-op ] each-derived-op
\ /i [ [ interval/i ] [ may-overflow integer-valued ] binary-op ] each-derived-op
\ /f [ [ interval/f ] [ float-valued ] binary-op ] each-derived-op

\ mod [ [ interval-mod ] [ real-valued ] binary-op ] each-derived-op
\ rem [ [ interval-rem ] [ may-overflow real-valued ] binary-op ] each-derived-op

\ bitand [ [ interval-bitand ] [ integer-valued ] binary-op ] each-derived-op
\ bitor [ [ interval-bitor ] [ integer-valued ] binary-op ] each-derived-op
\ bitxor [ [ interval-bitxor ] [ integer-valued ] binary-op ] each-derived-op

: assume-interval ( i1 i2 op -- i3 )
    {
        { \ < [ assume< ] }
        { \ > [ assume> ] }
        { \ <= [ assume<= ] }
        { \ >= [ assume>= ] }
    } case ;

: swap-comparison ( op -- op' )
    {
        { < > }
        { > < }
        { <= >= }
        { >= <= }
    } at ;

: negate-comparison ( op -- op' )
    {
        { < >= }
        { > <= }
        { <= > }
        { >= < }
    } at ;

:: (comparison-constraints) ( in1 in2 op -- constraint )
    [let | i1 [ in1 value-info interval>> ]
           i2 [ in2 value-info interval>> ] |
       i1 i2 and [
           in1 i1 i2 op assume-interval <interval-constraint>
           in2 i2 i1 op swap-comparison assume-interval <interval-constraint>
           <conjunction>
       ] [
           f
       ] if
    ] ;

: comparison-constraints ( in1 in2 out op -- constraint )
    swap [
        [ (comparison-constraints) ]
        [ negate-comparison (comparison-constraints) ]
        3bi
    ] dip <conditional> ;

: comparison-op ( word op -- )
    '[
        [ in-d>> first2 ] [ out-d>> first ] bi
        , comparison-constraints
    ] +constraints+ set-word-prop ;

{ < > <= >= } [ dup [ comparison-op ] curry each-derived-op ] each

{
    { >fixnum fixnum }
    { >bignum bignum }
    { >float float }
} [
    '[
        ,
        [ nip ] [
            [ interval>> ] [ class-interval ] bi*
            interval-intersect'
        ] 2bi
        <class/interval-info>
    ] +outputs+ set-word-prop
] assoc-each

! 
! {
!     alien-signed-1
!     alien-unsigned-1
!     alien-signed-2
!     alien-unsigned-2
!     alien-signed-4
!     alien-unsigned-4
!     alien-signed-8
!     alien-unsigned-8
! } [
!     dup name>> {
!         {
!             [ "alien-signed-" ?head ]
!             [ string>number 8 * 1- 2^ dup neg swap 1- [a,b] ]
!         }
!         {
!             [ "alien-unsigned-" ?head ]
!             [ string>number 8 * 2^ 1- 0 swap [a,b] ]
!         }
!     } cond 1array
!     [ nip f swap ] curry "output-classes" set-word-prop
! ] each
! 
! 
! { <tuple> <tuple-boa> (tuple) } [
!     [
!         dup node-in-d peek node-literal
!         dup tuple-layout? [ class>> ] [ drop tuple ] if
!         1array f
!     ] "output-classes" set-word-prop
! ] each
! 
! \ new [
!     dup node-in-d peek node-literal
!     dup class? [ drop tuple ] unless 1array f
! ] "output-classes" set-word-prop
! 
! ! the output of clone has the same type as the input
! { clone (clone) } [
!     [
!         node-in-d [ value-class* ] map f
!     ] "output-classes" set-word-prop
! ] each
! 
! ! if the result of eq? is t and the second input is a literal,
! ! the first input is equal to the second
! \ eq? [
!     dup node-in-d second dup value? [
!         swap [
!             value-literal 0 `input literal,
!             \ f class-not 0 `output class,
!         ] set-constraints
!     ] [
!         2drop
!     ] if
! ] "constraints" set-word-prop

: and-constraints ( in1 in2 out -- constraint )
    [ [ <true-constraint> ] bi@ ] dip <conditional> ;

! XXX...