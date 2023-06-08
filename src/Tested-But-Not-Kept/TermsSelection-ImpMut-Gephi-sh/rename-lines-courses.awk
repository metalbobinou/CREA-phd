#! /bin/awk

# Rewrite the 1st column of each line to change the names of documents

# Variables :
# OFS=";"
# SUB_OFS=","


# Input file :
# [line1] X ; Term bn:ID ; Term bn:ID ; ...
# [line2+] included_C1.csv ; 0 ; 1 ; ...

# Output :
# [line1] X ; Term bn:ID ; ...
# [line2+] C1 ; 0 ; ...
# ...

function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

NR == 1 {
    for (i = 1; i <= NF; i++)
    {
	if (i != NF)
	    printf("%s%s", $i, OFS);
	else
	    printf("%s\n", $i);
    }
}

NR != 1 {
    DOC_NAME = trim($1);
    DOC_NAME = gensub(/.*(C[0-9]+).*/, "\\1", "g", DOC_NAME);
    printf("%s%s", DOC_NAME, OFS);
    for (i = 2; i <= NF; i++)
    {
	if (i != NF)
	    printf("%s%s", $i, OFS);
	else
	    printf("%s\n", $i);
    }
}
