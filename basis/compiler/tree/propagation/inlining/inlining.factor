! Copyright (C) 2008 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors kernel arrays sequences math math.order
math.partial-dispatch generic generic.standard generic.math
classes.algebra classes.union sets quotations assocs combinators
words namespaces continuations
compiler.tree
compiler.tree.builder
compiler.tree.recursive
compiler.tree.combinators
compiler.tree.normalization
compiler.tree.propagation.info
compiler.tree.propagation.nodes ;
IN: compiler.tree.propagation.inlining

! We count nodes up-front; if there are relatively few nodes,
! we are more eager to inline
SYMBOL: node-count

: count-nodes ( nodes -- )
    0 swap [ drop 1+ ] each-node node-count set ;

! Splicing nodes
GENERIC: splicing-nodes ( #call word/quot/f -- nodes )

M: word splicing-nodes
    [ [ in-d>> ] [ out-d>> ] bi ] dip #call 1array ;

M: quotation splicing-nodes
    build-sub-tree analyze-recursive normalize ;

: propagate-body ( #call -- )
    body>> (propagate) ;

! Dispatch elimination
: eliminate-dispatch ( #call class/f word/quot/f -- ? )
    dup [
        [ >>class ] dip
        over method>> over = [ drop ] [
            2dup splicing-nodes
            [ >>method ] [ >>body ] bi*
        ] if
        propagate-body t
    ] [ 2drop f >>method f >>body f >>class drop f ] if ;

: inlining-standard-method ( #call word -- class/f method/f )
    [ in-d>> <reversed> ] [ [ dispatch# ] keep ] bi*
    [ swap nth value-info class>> dup ] dip
    specific-method ;

: inline-standard-method ( #call word -- ? )
    dupd inlining-standard-method eliminate-dispatch ;

: normalize-math-class ( class -- class' )
    {
        null
        fixnum bignum integer
        ratio rational
        float real
        complex number
        object
    } [ class<= ] with find nip ;

: inlining-math-method ( #call word -- class/f quot/f )
    swap in-d>>
    first2 [ value-info class>> normalize-math-class ] bi@
    3dup math-both-known?
    [ math-method* ] [ 3drop f ] if
    number swap ;

: inline-math-method ( #call word -- ? )
    dupd inlining-math-method eliminate-dispatch ;

: inlining-math-partial ( #call word -- class/f quot/f )
    [ "derived-from" word-prop first inlining-math-method ]
    [ nip 1quotation ] 2bi
    [ = not ] [ drop ] 2bi and ;

: inline-math-partial ( #call word -- ? )
    dupd inlining-math-partial eliminate-dispatch ;

! Method body inlining
SYMBOL: recursive-calls
DEFER: (flat-length)

: word-flat-length ( word -- n )
    {
        ! special-case
        { [ dup { dip 2dip 3dip } memq? ] [ drop 1 ] }
        ! not inline
        { [ dup inline? not ] [ drop 1 ] }
        ! recursive and inline
        { [ dup recursive-calls get key? ] [ drop 10 ] }
        ! inline
        [ [ recursive-calls get conjoin ] [ def>> (flat-length) ] bi ]
    } cond ;

: (flat-length) ( seq -- n )
    [
        {
            { [ dup quotation? ] [ (flat-length) 2 + ] }
            { [ dup array? ] [ (flat-length) ] }
            { [ dup word? ] [ word-flat-length ] }
            [ drop 0 ]
        } cond
    ] sigma ;

: flat-length ( word -- n )
    H{ } clone recursive-calls [
        [ recursive-calls get conjoin ]
        [ def>> (flat-length) 5 /i ]
        bi
    ] with-variable ;

: classes-known? ( #call -- ? )
    in-d>> [
        value-info class>>
        [ class-types length 1 = ]
        [ union-class? not ]
        bi and
    ] contains? ;

: inlining-rank ( #call word -- n )
    [ classes-known? 2 0 ? ]
    [
        {
            [ drop node-count get 45 swap [-] 8 /i ]
            [ flat-length 24 swap [-] 4 /i ]
            [ "default" word-prop -4 0 ? ]
            [ "specializer" word-prop 1 0 ? ]
            [ method-body? 1 0 ? ]
        } cleave
    ] bi* + + + + + ;

: should-inline? ( #call word -- ? )
    dup "inline" word-prop [ 2drop t ] [ inlining-rank 5 >= ] if ;

SYMBOL: history

: remember-inlining ( word -- )
    history [ swap suffix ] change ;

: inline-word ( #call word -- ? )
    dup history get memq? [
        2drop f
    ] [
        [
            dup remember-inlining
            dupd def>> splicing-nodes >>body
            propagate-body
        ] with-scope
        t
    ] if ;

: inline-method-body ( #call word -- ? )
    2dup should-inline? [ inline-word ] [ 2drop f ] if ;

: always-inline-word? ( word -- ? )
    { curry compose } memq? ;

: custom-inlining? ( word -- ? )
    "custom-inlining" word-prop ;

: inline-custom ( #call word -- ? )
    [ dup 1array ] [ "custom-inlining" word-prop ] bi* with-datastack
    first object swap eliminate-dispatch ;

: do-inlining ( #call word -- ? )
    #! If the generic was defined in an outer compilation unit,
    #! then it doesn't have a definition yet; the definition
    #! is built at the end of the compilation unit. We do not
    #! attempt inlining at this stage since the stack discipline
    #! is not finalized yet, so dispatch# might return an out
    #! of bounds value. This case comes up if a parsing word
    #! calls the compiler at parse time (doing so is
    #! discouraged, but it should still work.)
    {
        { [ dup deferred? ] [ 2drop f ] }
        { [ dup custom-inlining? ] [ inline-custom ] }
        { [ dup always-inline-word? ] [ inline-word ] }
        { [ dup standard-generic? ] [ inline-standard-method ] }
        { [ dup math-generic? ] [ inline-math-method ] }
        { [ dup method-body? ] [ inline-method-body ] }
        [ 2drop f ]
    } cond ;
