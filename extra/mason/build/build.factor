! Copyright (C) 2008 Eduardo Cavazos, Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: io.files io.launcher io.encodings.utf8 prettyprint arrays
calendar namespaces mason.common mason.child
mason.release mason.report mason.email mason.cleanup
mason.help ;
IN: mason.build

: create-build-dir ( -- )
    now datestamp stamp set
    build-dir make-directory ;

: enter-build-dir  ( -- ) build-dir set-current-directory ;

: clone-builds-factor ( -- )
    "git" "clone" builds/factor 3array try-process ;

: record-id ( -- )
    "factor" [ git-id ] with-directory "git-id" to-file ;

: build ( -- )
    create-build-dir
    enter-build-dir
    clone-builds-factor
    record-id
    build-child
    upload-help
    release
    email-report
    cleanup ;

MAIN: build