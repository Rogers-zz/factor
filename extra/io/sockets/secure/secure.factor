! Copyright (C) 2008 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors kernel symbols namespaces continuations
destructors io.sockets sequences ;
IN: io.sockets.secure

SYMBOL: ssl-backend

SINGLETONS: SSLv2 SSLv23 SSLv3 TLSv1 ;

TUPLE: ssl-config method key-file ca-file ca-path password ;

: <ssl-config> ( -- config )
    ssl-config new
        SSLv23 >>method ;

TUPLE: ssl-context config handle ;

HOOK: <ssl-context> ssl-backend ( config -- context )

: with-ssl-context ( config quot -- )
    [
        [ <ssl-context> ] [ [ ssl-context set ] prepose ] bi*
        with-disposal
    ] with-scope ; inline

TUPLE: ssl addrspec ;

C: <ssl> ssl

<PRIVATE

PREDICATE: ssl-inet < ssl addrspec>> inet? ;

M: ssl-inet (client)
    addrspec>> resolve-client-addr [ <ssl> ] map (client) ;

PRIVATE>