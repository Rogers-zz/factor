
USING: help.syntax help.markup kernel prettyprint sequences strings ;

IN: printf

HELP: printf
{ $values { "format-string" string } }
{ $description "Writes the arguments (specified on the stack) formatted according to the format string." } 
{ $examples 
    { $example
        "USING: printf ;"
        "123 \"%05d\" printf"
        "00123" }
    { $example
        "USING: printf ;"
        "HEX: ff \"%04X\" printf"
        "00FF" }
    { $example
        "USING: printf ;"
        "1.23456789 \"%.3f\" printf"
        "1.235" }
    { $example 
        "USING: printf ;"
        "1234567890 \"%.5e\" printf"
        "1.23457e+09" }
    { $example
        "USING: printf ;"
        "12 \"%'#4d\" printf"
        "##12" }
    { $example
        "USING: printf ;"
        "1234 \"%+d\" printf"
        "+1234" }
} ;

HELP: sprintf
{ $values { "format-string" string } { "result" string } }
{ $description "Returns the arguments (specified on the stack) formatted according to the format string as a result string." } 
{ $see-also printf } ;

ARTICLE: "printf" "Formatted printing"
"The " { $vocab-link "printf" } " vocabulary is used for formatted printing.\n"
{ $subsection printf }
{ $subsection sprintf }
"\n"
"Several format specifications exist for handling arguments of different types, and specifying attributes for the result string, including such things as maximum width, padding, and decimals.\n"
{ $table
    { "%%"    "Single %" "" }
    { "%P.Ds" "String format" "string" }
    { "%P.DS" "String format uppercase" "string" }
    { "%c"    "Character format" "char" } 
    { "%C"    "Character format uppercase" "char" } 
    { "%+Pd"   "Integer format"  "fixnum" }
    { "%+P.De" "Scientific notation" "fixnum, float" }
    { "%+P.DE" "Scientific notation" "fixnum, float" }
    { "%+P.Df" "Fixed format" "fixnum, float" }
    { "%+Px"   "Hexadecimal" "hex" }
    { "%+PX"   "Hexadecimal uppercase" "hex" }
}
"\n"
"A plus sign ('+') is used to optionally specify that the number should be formatted with a '+' preceeding it if positive.\n"
"\n"
"Padding ('P') is used to optionally specify the minimum width of the result string, the padding character, and the alignment.  By default, the padding character defaults to a space and the alignment defaults to right-aligned. For example:\n"
{ $list
    "\"%5s\" formats a string padding with spaces up to 5 characters wide."
    "\"%08d\" formats an integer padding with zeros up to 3 characters wide."
    "\"%'#5f\" formats a float padding with '#' up to 3 characters wide."
    "\"%-10d\" formats an integer to 10 characters wide and left-aligns." 
}
"\n"
"Digits ('D') is used to optionally specify the maximum digits in the result string. For example:\n"
{ $list 
    "\"%.3s\" formats a string to truncate at 3 characters (from the left)."
    "\"%.10f\" formats a float to pad-right with zeros up to 10 digits beyond the decimal point."
    "\"%.5E\" formats a float into scientific notation with zeros up to 5 digits beyond the decimal point, but before the exponent."
} ;

ABOUT: "printf"


