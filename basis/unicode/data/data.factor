! Copyright (C) 2008 Daniel Ehrenberg.
! See http://factorcode.org/license.txt for BSD license.
USING: combinators.short-circuit assocs math kernel sequences
io.files hashtables quotations splitting grouping arrays
math.parser hash2 math.order byte-arrays words namespaces words
compiler.units parser io.encodings.ascii values interval-maps
ascii sets combinators locals math.ranges sorting ;
IN: unicode.data

VALUE: simple-lower
VALUE: simple-upper
VALUE: simple-title
VALUE: canonical-map
VALUE: combine-map
VALUE: class-map
VALUE: compatibility-map
VALUE: category-map
VALUE: name-map
VALUE: special-casing
VALUE: properties

: canonical-entry ( char -- seq ) canonical-map at ;
: combine-chars ( a b -- char/f ) combine-map hash2 ;
: compatibility-entry ( char -- seq ) compatibility-map at  ;
: combining-class ( char -- n ) class-map at ;
: non-starter? ( char -- ? ) class-map key? ;
: name>char ( string -- char ) name-map at ;
: char>name ( char -- string ) name-map value-at ;
: property? ( char property -- ? ) properties at interval-key? ;

! Convenience functions
: ?between? ( n/f from to -- ? )
    pick [ between? ] [ 3drop f ] if ;

! Loading data from UnicodeData.txt

: split-; ( line -- array )
    ";" split [ [ blank? ] trim ] map ;

: data ( filename -- data )
    ascii file-lines [ split-; ] map ;

: load-data ( -- data )
    "resource:basis/unicode/data/UnicodeData.txt" data ;

: filter-comments ( lines -- lines )
    [ "#@" split first ] map harvest ;

: (process-data) ( index data -- newdata )
    filter-comments
    [ [ nth ] keep first swap ] with { } map>assoc
    [ >r hex> r> ] assoc-map ;

: process-data ( index data -- hash )
    (process-data) [ hex> ] assoc-map [ nip ] assoc-filter >hashtable ;

: (chain-decomposed) ( hash value -- newvalue )
    [
        2dup swap at
        [ (chain-decomposed) ] [ 1array nip ] ?if
    ] with map concat ;

: chain-decomposed ( hash -- newhash )
    dup [ swap (chain-decomposed) ] curry assoc-map ;

: first* ( seq -- ? )
    second { [ empty? ] [ first ] } 1|| ;

: (process-decomposed) ( data -- alist )
    5 swap (process-data)
    [ " " split [ hex> ] map ] assoc-map ;

: process-canonical ( data -- hash2 hash )
    (process-decomposed) [ first* ] filter
    [
        [ second length 2 = ] filter
        ! using 1009 as the size, the maximum load is 4
        [ first2 first2 rot 3array ] map 1009 alist>hash2
    ] [ >hashtable chain-decomposed ] bi ;

: process-compatibility ( data -- hash )
    (process-decomposed)
    [ dup first* [ first2 rest 2array ] unless ] map
    [ second empty? not ] filter
    >hashtable chain-decomposed ;

: process-combining ( data -- hash )
    3 swap (process-data)
    [ string>number ] assoc-map
    [ nip zero? not ] assoc-filter
    >hashtable ;

: categories ( -- names )
    ! For non-existent characters, use Cn
    { "Cn"
      "Lu" "Ll" "Lt" "Lm" "Lo"
      "Mn" "Mc" "Me"
      "Nd" "Nl" "No"
      "Pc" "Pd" "Ps" "Pe" "Pi" "Pf" "Po"
      "Sm" "Sc" "Sk" "So"
      "Zs" "Zl" "Zp"
      "Cc" "Cf" "Cs" "Co" } ;

: num-chars HEX: 2FA1E ;
! the maximum unicode char in the first 3 planes

: ?set-nth ( val index seq -- )
    2dup bounds-check? [ set-nth ] [ 3drop ] if ;

:: fill-ranges ( table -- table )
    name-map >alist sort-values keys
    [ { [ "first>" tail? ] [ "last>" tail? ] } 1|| ] filter
    2 group [
        [ name>char ] bi@ [ [a,b] ] [ table ?nth ] bi
        [ swap table ?set-nth ] curry each
    ] assoc-each table ;

:: process-category ( data -- category-listing )
    [let | table [ num-chars <byte-array> ] |
        2 data (process-data) [| char cat |
            cat categories index char table ?set-nth
        ] assoc-each table fill-ranges ] ;

: ascii-lower ( string -- lower )
    [ dup CHAR: A CHAR: Z between? [ HEX: 20 + ] when ] map ;

: process-names ( data -- names-hash )
    1 swap (process-data) [
        ascii-lower { { CHAR: \s CHAR: - } } substitute swap
    ] H{ } assoc-map-as ;

: multihex ( hexstring -- string )
    " " split [ hex> ] map sift ;

TUPLE: code-point lower title upper ;

C: <code-point> code-point

: set-code-point ( seq -- )
    4 head [ multihex ] map first4
    <code-point> swap first set ;

! Extra properties
: properties-lines ( -- lines )
    "resource:basis/unicode/data/PropList.txt"
    ascii file-lines ;

: parse-properties ( -- {{[a,b],prop}} )
    properties-lines filter-comments [
        split-; first2
        [ ".." split1 [ dup ] unless* [ hex> ] bi@ 2array ] dip
    ] { } map>assoc ;

: properties>intervals ( properties -- assoc[str,interval] )
    dup values prune [ f ] H{ } map>assoc
    [ [ push-at ] curry assoc-each ] keep
    [ <interval-set> ] assoc-map ;

: load-properties ( -- assoc )
    parse-properties properties>intervals ;

! Special casing data
: load-special-casing ( -- special-casing )
    "resource:basis/unicode/data/SpecialCasing.txt" data
    [ length 5 = ] filter
    [ [ set-code-point ] each ] H{ } make-assoc ;

load-data {
    [ process-names to: name-map ]
    [ 13 swap process-data to: simple-lower ]
    [ 12 swap process-data to: simple-upper ]
    [ 14 swap process-data simple-upper assoc-union to: simple-title ]
    [ process-combining to: class-map ]
    [ process-canonical to: canonical-map to: combine-map ]
    [ process-compatibility to: compatibility-map ]
    [ process-category to: category-map ]
} cleave

load-special-casing to: special-casing

load-properties to: properties
