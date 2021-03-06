! Copyright (C) 2008 Daniel Ehrenberg.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors values kernel sequences assocs io.files
io.encodings ascii math.ranges io splitting math.parser 
namespaces make byte-arrays locals math sets io.encodings.ascii
words compiler.units arrays interval-maps unicode.data ;
IN: unicode.script

<PRIVATE
VALUE: script-table
SYMBOL: interned

: parse-script ( stream -- assoc )
    ! assoc is code point/range => name
    lines filter-comments [ split-; ] map ;

: range, ( value key -- )
    swap interned get
    [ name>> = ] with find nip 2array , ;

: expand-ranges ( assoc -- interval-map )
    [
        [
            CHAR: . pick member? [
                swap ".." split1 [ hex> ] bi@ 2array
            ] [ swap hex> ] if range,
        ] assoc-each
    ] { } make <interval-map> ;

: >symbols ( strings -- symbols )
    [
        [ "unicode.script" create dup define-symbol ] map
    ] with-compilation-unit ;

: process-script ( ranges -- )
    dup values prune >symbols interned [
        expand-ranges to: script-table
    ] with-variable ;

: load-script ( -- )
    "resource:basis/unicode/script/Scripts.txt"
    ascii <file-reader> parse-script process-script ;

load-script
PRIVATE>

SYMBOL: Unknown

: script-of ( char -- script )
    script-table interval-at [ Unknown ] unless* ;
