#! /bin/awk

# Rewrite the 1st line (each column) to change the name of documents

# Variables :
# OFS=";"
# SUB_OFS=","


# Input file :
# [line1] X ; included_C1.csv ; included_C2.csv ; ...
# [line2+] Term bn:ID ; 0 ; 1 ; ...

# Output :
# [line1] X ; C1 ; C2 ; ...
# [line2+] Term bn:ID ; 0 ; 1 ; ...
# ...

function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }


NR == 1 {
    printf("%s%s", $1, OFS);
    for (i = 2; i <= NF; i++)
    {
	DOC_NAME = trim($i);
	DOC_NAME = gensub(/.*(C[0-9]+).*/, "\\1", "g", DOC_NAME);
	if (i != NF)
	    printf("%s%s", DOC_NAME, OFS);
	else
	    printf("%s\n", DOC_NAME);
    }
}

NR != 1 {
    for (i = 1; i <= NF; i++)
    {
	if (i != NF)
	    printf("%s%s", $i, OFS);
	else
	    printf("%s\n", $i);
    }
}
