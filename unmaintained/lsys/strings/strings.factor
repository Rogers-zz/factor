
USING: kernel sequences math combinators.lib combinators.short-circuit ;

IN: lsys.strings

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

: has-param? ( slice -- ? ) { [ length 1 > ] [ second CHAR: ( = ] } 1&& ;

: next+rest ( slice -- next rest ) [ 1 head ] [ 1 tail-slice ] bi ;

: index-rest ( slice -- i ) CHAR: ) swap index 1+ ;

: next+rest* ( slice -- next rest ) dup index-rest [ head ] [ tail-slice ] 2bi ;
