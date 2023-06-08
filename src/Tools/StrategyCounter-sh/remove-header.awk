#! /bin/awk

# Remove the 1st line of the matrix (the header)

# Variables :
# OFS = ";"

function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

NR != 1 {
    print $0;
}
