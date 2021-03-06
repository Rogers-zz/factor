! Copyright (C) 2004, 2008 Slava Pestov, Daniel Ehrenberg.
! See http://factorcode.org/license.txt for BSD license.
USING: io.backend io.files.private io hashtables kernel
kernel.private math memory namespaces sequences strings assocs
arrays definitions system combinators splitting sbufs
continuations destructors io.encodings io.encodings.binary init
accessors math.order ;
IN: io.files

HOOK: (file-reader) io-backend ( path -- stream )

HOOK: (file-writer) io-backend ( path -- stream )

HOOK: (file-appender) io-backend ( path -- stream )

: <file-reader> ( path encoding -- stream )
    swap normalize-path (file-reader) swap <decoder> ;

: <file-writer> ( path encoding -- stream )
    swap normalize-path (file-writer) swap <encoder> ;

: <file-appender> ( path encoding -- stream )
    swap normalize-path (file-appender) swap <encoder> ;

: file-lines ( path encoding -- seq )
    <file-reader> lines ;

: with-file-reader ( path encoding quot -- )
    [ <file-reader> ] dip with-input-stream ; inline

: file-contents ( path encoding -- str )
    <file-reader> contents ;

: with-file-writer ( path encoding quot -- )
    [ <file-writer> ] dip with-output-stream ; inline

: set-file-lines ( seq path encoding -- )
    [ [ print ] each ] with-file-writer ;

: set-file-contents ( str path encoding -- )
    [ write ] with-file-writer ;

: with-file-appender ( path encoding quot -- )
    [ <file-appender> ] dip with-output-stream ; inline

! Pathnames
: path-separator? ( ch -- ? ) os windows? "/\\" "/" ? member? ;

: path-separator ( -- string ) os windows? "\\" "/" ? ;

: trim-right-separators ( str -- newstr )
    [ path-separator? ] trim-right ;

: trim-left-separators ( str -- newstr )
    [ path-separator? ] trim-left ;

: last-path-separator ( path -- n ? )
    [ length 1- ] keep [ path-separator? ] find-last-from ;

HOOK: root-directory? io-backend ( path -- ? )

M: object root-directory? ( path -- ? )
    [ f ] [ [ path-separator? ] all? ] if-empty ;

ERROR: no-parent-directory path ;

: parent-directory ( path -- parent )
    dup root-directory? [
        trim-right-separators
        dup last-path-separator [
            1+ cut
        ] [
            drop "." swap
        ] if
        { "" "." ".." } member? [
            no-parent-directory
        ] when
    ] unless ;

<PRIVATE

: head-path-separator? ( path1 ? -- ?' )
    [
        [ t ] [ first path-separator? ] if-empty
    ] [
        drop f
    ] if ;

: head.? ( path -- ? ) "." ?head head-path-separator? ;

: head..? ( path -- ? ) ".." ?head head-path-separator? ;

: append-path-empty ( path1 path2 -- path' )
    {
        { [ dup head.? ] [
            rest trim-left-separators append-path-empty
        ] }
        { [ dup head..? ] [ drop no-parent-directory ] }
        [ nip ]
    } cond ;

PRIVATE>

: windows-absolute-path? ( path -- path ? )
    {
        { [ dup "\\\\?\\" head? ] [ t ] }
        { [ dup length 2 < ] [ f ] }
        { [ dup second CHAR: : = ] [ t ] }
        [ f ]
    } cond ;

: absolute-path? ( path -- ? )
    {
        { [ dup empty? ] [ f ] }
        { [ dup "resource:" head? ] [ t ] }
        { [ os windows? ] [ windows-absolute-path? ] }
        { [ dup first path-separator? ] [ t ] }
        [ f ]
    } cond nip ;

: append-path ( str1 str2 -- str )
    {
        { [ over empty? ] [ append-path-empty ] }
        { [ dup empty? ] [ drop ] }
        { [ over trim-right-separators "." = ] [ nip ] }
        { [ dup absolute-path? ] [ nip ] }
        { [ dup head.? ] [ rest trim-left-separators append-path ] }
        { [ dup head..? ] [
            2 tail trim-left-separators
            [ parent-directory ] dip append-path
        ] }
        { [ over absolute-path? over first path-separator? and ] [
            [ 2 head ] dip append
        ] }
        [
            [ trim-right-separators "/" ] dip
            trim-left-separators 3append
        ]
    } cond ;

: prepend-path ( str1 str2 -- str )
    swap append-path ; inline

: file-name ( path -- string )
    dup root-directory? [
        trim-right-separators
        dup last-path-separator [ 1+ tail ] [
            drop "resource:" ?head [ file-name ] when
        ] if
    ] unless ;

: file-extension ( filename -- extension )
    "." split1-last nip ;

! File info
TUPLE: file-info type size permissions created modified
accessed ;

HOOK: file-info io-backend ( path -- info )

! Symlinks
HOOK: link-info io-backend ( path -- info )

HOOK: make-link io-backend ( target symlink -- )

HOOK: read-link io-backend ( symlink -- path )

: copy-link ( target symlink -- )
    [ read-link ] dip make-link ;

SYMBOL: +regular-file+
SYMBOL: +directory+
SYMBOL: +symbolic-link+
SYMBOL: +character-device+
SYMBOL: +block-device+
SYMBOL: +fifo+
SYMBOL: +socket+
SYMBOL: +whiteout+
SYMBOL: +unknown+

! File metadata
: exists? ( path -- ? ) normalize-path (exists?) ;

: directory? ( file-info -- ? ) type>> +directory+ = ;

! File-system

HOOK: file-systems os ( -- array )

TUPLE: file-system-info device-name mount-point type free-space ;

HOOK: file-system-info os ( path -- file-system-info )

<PRIVATE

HOOK: cd io-backend ( path -- )

HOOK: cwd io-backend ( -- path )

M: object cwd ( -- path ) "." ;

PRIVATE>

SYMBOL: current-directory

[
    cwd current-directory set-global
    13 getenv cwd prepend-path \ image set-global
    14 getenv cwd prepend-path \ vm set-global
    image parent-directory "resource-path" set-global
] "io.files" add-init-hook

: resource-path ( path -- newpath )
    "resource-path" get prepend-path ;

: (normalize-path) ( path -- path' )
    "resource:" ?head [
        trim-left-separators resource-path
        (normalize-path)
    ] [
        current-directory get prepend-path
    ] if ;

M: object normalize-path ( path -- path' )
    (normalize-path) ;

: set-current-directory ( path -- )
    (normalize-path) current-directory set ;

: with-directory ( path quot -- )
    [ (normalize-path) current-directory ] dip with-variable ; inline

! Creating directories
HOOK: make-directory io-backend ( path -- )

: make-directories ( path -- )
    normalize-path trim-right-separators {
        { [ dup "." = ] [ ] }
        { [ dup root-directory? ] [ ] }
        { [ dup empty? ] [ ] }
        { [ dup exists? ] [ ] }
        [
            dup parent-directory make-directories
            dup make-directory
        ]
    } cond drop ;

TUPLE: directory-entry name type ;

HOOK: >directory-entry os ( byte-array -- directory-entry )

HOOK: (directory-entries) os ( path -- seq )

: directory-entries ( path -- seq )
    normalize-path
    (directory-entries)
    [ name>> { "." ".." } member? not ] filter ;
    
: directory-files ( path -- seq )
    directory-entries [ name>> ] map ;

: with-directory-files ( path quot -- )
    [ "" directory-files ] prepose with-directory ; inline

! Touching files
HOOK: touch-file io-backend ( path -- )

! Deleting files
HOOK: delete-file io-backend ( path -- )

HOOK: delete-directory io-backend ( path -- )

: delete-tree ( path -- )
    dup link-info type>> +directory+ = [
        [ [ [ delete-tree ] each ] with-directory-files ]
        [ delete-directory ]
        bi
    ] [ delete-file ] if ;

: to-directory ( from to -- from to' )
    over file-name append-path ;

! Moving and renaming files
HOOK: move-file io-backend ( from to -- )

: move-file-into ( from to -- )
    to-directory move-file ;

: move-files-into ( files to -- )
    [ move-file-into ] curry each ;

! Copying files
HOOK: copy-file io-backend ( from to -- )

M: object copy-file
    dup parent-directory make-directories
    binary <file-writer> [
        swap binary <file-reader> [
            swap stream-copy
        ] with-disposal
    ] with-disposal ;

: copy-file-into ( from to -- )
    to-directory copy-file ;

: copy-files-into ( files to -- )
    [ copy-file-into ] curry each ;

DEFER: copy-tree-into

: copy-tree ( from to -- )
    normalize-path
    over link-info type>>
    {
        { +symbolic-link+ [ copy-link ] }
        { +directory+ [
            swap [
                [ swap copy-tree-into ] with each
            ] with-directory-files
        ] }
        [ drop copy-file ]
    } case ;

: copy-tree-into ( from to -- )
    to-directory copy-tree ;

: copy-trees-into ( files to -- )
    [ copy-tree-into ] curry each ;

! Special paths

: temp-directory ( -- path )
    "temp" resource-path dup make-directories ;

: temp-file ( name -- path )
    temp-directory prepend-path ;

! Pathname presentations
TUPLE: pathname string ;

C: <pathname> pathname

M: pathname <=> [ string>> ] compare ;

! Home directory
HOOK: home io-backend ( -- dir )

M: object home "" resource-path ;
