! Copyright (C) 2008 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: assocs fry kernel accessors sequences sequences.deep arrays
stack-checker.inlining namespaces compiler.tree ;
IN: compiler.tree.combinators

: each-node ( nodes quot: ( node -- ) -- )
    dup dup '[
        _ [
            dup #branch? [
                children>> [ _ each-node ] each
            ] [
                dup #recursive? [
                    child>> _ each-node
                ] [ drop ] if
            ] if
        ] bi
    ] each ; inline recursive

: map-nodes ( nodes quot: ( node -- node' ) -- nodes )
    dup dup '[
        @
        dup #branch? [
            [ [ _ map-nodes ] map ] change-children
        ] [
            dup #recursive? [
                [ _ map-nodes ] change-child
            ] when
        ] if
    ] map flatten ; inline recursive

: contains-node? ( nodes quot: ( node -- ? ) -- ? )
    dup dup '[
        _ keep swap [ drop t ] [
            dup #branch? [
                children>> [ _ contains-node? ] contains?
            ] [
                dup #recursive? [
                    child>> _ contains-node?
                ] [ drop f ] if
            ] if
        ] if
    ] contains? ; inline recursive

: select-children ( seq flags -- seq' )
    [ [ drop f ] unless ] 2map ;

: sift-children ( seq flags -- seq' )
    zip [ nip ] assoc-filter keys ;

: (3each) [ 3array flip ] dip '[ first3 @ ] ; inline

: 3each ( seq1 seq2 seq3 quot -- seq ) (3each) each ; inline

: 3map ( seq1 seq2 seq3 quot -- seq ) (3each) map ; inline

: until-fixed-point ( #recursive quot: ( node -- ) -- )
    over label>> t >>fixed-point drop
    [ with-scope ] 2keep
    over label>> fixed-point>> [ 2drop ] [ until-fixed-point ] if ;
    inline recursive
