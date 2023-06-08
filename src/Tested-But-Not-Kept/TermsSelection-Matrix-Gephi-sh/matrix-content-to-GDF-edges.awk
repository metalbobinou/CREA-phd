#! /bin/awk

# Extract the content of the matrix and transforms it into GDF edges format.
# (it's for GDF edges format)
#
# Take each 1 (or non 0 value) and create a link between its column and line in the output.

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
    for (i = 1; i <= NF; i++)
    {
	DOC = trim($i);
	DOCS[i] = DOC;
    }
}

NR != 1 {
    TERM = trim($1);
    for (i = 2; i <= NF; i++)
    {
	if (! ((i == NF) && (trim($NF) == "")))
        {
            # We skip last column if it is empty
	    weight = $i;
	    if (weight != 0)
	    {
		for (iter = 0; iter < weight; iter++)
		{
		    DOC = DOCS[i];
		    printf("%s%s%s\n", TERM, SUB_OFS, DOC);
		}
	    }
        }
    }
}
