#! /bin/awk

# Remove the 1st column of the matrix (the description)

# Variables :
# OFS = ";"

function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

{
    for (i = 2; i <= NF; i++)
    {
	if (i != NF)
	    printf("%s%s", trim($i), OFS);
	else
	    printf("%s\n", trim($i));
    }
}
