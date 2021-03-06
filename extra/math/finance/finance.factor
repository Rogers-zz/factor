! Copyright (C) 2008 John Benediktsson.
! See http://factorcode.org/license.txt for BSD license.
USING: arrays assocs kernel grouping sequences shuffle
math math.functions math.statistics math.vectors ;
IN: math.finance

<PRIVATE

: weighted ( x y a -- z )
    tuck [ * ] [ 1- neg * ] 2bi* + ;

: a ( n -- a )
    1+ 2 swap / ;

PRIVATE>

: ema ( seq n -- newseq )
    a swap unclip [ [ dup ] 2dip spin weighted ] accumulate 2nip ;

: sma ( seq n -- newseq )
    clump [ mean ] map ;

: macd ( seq n1 n2 -- newseq )
    rot dup ema [ swap ema ] dip v- ;

: momentum ( seq n -- newseq )
    [ tail-slice ] 2keep [ dup length ] dip - head-slice v- ;

