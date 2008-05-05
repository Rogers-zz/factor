! Copyright (C) 2008 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: system alien.c-types kernel unix math sequences
qualified io.unix.backend io.nonblocking ;
IN: io.unix.pipes
QUALIFIED: io.pipes

M: unix io.pipes:(pipe) ( -- pair )
    2 "int" <c-array>
    dup pipe io-error
    2 c-int-array> first2
    [ [ init-handle ] bi@ ] [ io.pipes:pipe boa ] 2bi ;