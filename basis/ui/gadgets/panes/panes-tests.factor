USING: alien ui.gadgets.panes ui.gadgets namespaces
kernel sequences io io.styles io.streams.string tools.test
prettyprint definitions help help.syntax help.markup
help.stylesheet splitting tools.test.ui models math summary
inspector accessors ;
IN: ui.gadgets.panes.tests

: #children "pane" get children>> length ;

[ ] [ <pane> "pane" set ] unit-test

[ ] [ #children "num-children" set ] unit-test

[ ] [
    "pane" get <pane-stream> [ 100 [ . ] each ] with-output-stream*
] unit-test

[ t ] [ #children "num-children" get = ] unit-test

: test-gadget-text
    dup make-pane gadget-text dup print "======" print
    swap with-string-writer dup print "\n" ?tail drop "\n" ?tail drop = ;

[ t ] [ [ "hello" write ] test-gadget-text ] unit-test
[ t ] [ [ "hello" pprint ] test-gadget-text ] unit-test
[ t ] [
    [
        H{ { wrap-margin 100 } } [ "hello" pprint ] with-nesting
    ] test-gadget-text
] unit-test
[ t ] [
    [
        H{ { wrap-margin 100 } } [
            H{ } [
                "hello" pprint
            ] with-style
        ] with-nesting
    ] test-gadget-text
] unit-test
[ t ] [ [ [ 1 2 3 ] pprint ] test-gadget-text ] unit-test
[ t ] [ [ \ + describe ] test-gadget-text ] unit-test
[ t ] [ [ \ = see ] test-gadget-text ] unit-test
[ t ] [ [ \ = print-topic ] test-gadget-text ] unit-test

[ t ] [
    [
        title-style get [
                "Hello world" write
        ] with-style
    ] test-gadget-text
] unit-test


[ t ] [
    [
        title-style get [
                "Hello world" write
        ] with-nesting
    ] test-gadget-text
] unit-test

[ t ] [
    [
        title-style get [
            title-style get [
                "Hello world" write
            ] with-nesting
        ] with-style
    ] test-gadget-text
] unit-test

[ t ] [
    [
        title-style get [
            title-style get [
                [ "Hello world" write ] ($block)
            ] with-nesting
        ] with-style
    ] test-gadget-text
] unit-test

ARTICLE: "test-article-1" "This is a test article"
"Hello world, how are you today." ;

[ t ] [ [ "test-article-1" $title ] test-gadget-text ] unit-test

[ t ] [ [ "test-article-1" print-topic ] test-gadget-text ] unit-test

ARTICLE: "test-article-2" "This is a test article"
"Hello world, how are you today."
{ $table { "a" "b" } { "c" "d" } } ;

[ t ] [ [ "test-article-2" print-topic ] test-gadget-text ] unit-test

<pane> [ \ = see ] with-pane
<pane> [ \ = print-topic ] with-pane

[ ] [
    \ = <model> [ see ] <pane-control> [ ] with-grafted-gadget
] unit-test
