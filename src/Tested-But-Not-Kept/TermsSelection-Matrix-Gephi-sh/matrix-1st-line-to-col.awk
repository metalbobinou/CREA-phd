#! /bin/awk

# Extracts the first line : each column is rewritten on one line
# (it's for GDF nodes format)

# Variables :
# OFS=";"
# SUB_OFS=","


# Input file :
# [line1] X ; Document 1 ; Document 2 ; ...
# [line2+] Term ; 0 ; 1 ; ...

# Output :
# Document 1, Description
# Document 2, Description
# ...

function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }


NR == 1 {
    for (i = 2; i <= NF; i++)
    {
	if (! ((i == NF) && (trim($NF) == "")))
	{
	    # We skip last column if it is empty
	    DOC = trim($i);
	    printf("%s%s%s\n", DOC, SUB_OFS, DOC);
	}
    }
}
