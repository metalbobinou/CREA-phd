#! /bin/awk

# Extracts the firsts cols : each column from each line is rewritten on one line
# (it's for GDF nodes format)

# Variables :
# OFS=";"
# SUB_OFS=","


# Input file :
# [line1] X ; Document 1 ; Document 2 ; ...
# [line2+] Term ; 0 ; 1 ; ...

# Output :
# Output :
# Term 1, Description
# Term 2, Description
# ...

function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

# Process each line, except header
NR != 1 {
    TERM = trim($1);
    printf("%s%s%s\n", TERM, SUB_OFS, TERM);
}
