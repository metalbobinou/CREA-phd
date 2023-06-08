#! /bin/awk

# Rewrite the 1st line (each column) to change the name of terms (bn:ID)

# Variables :
# OFS=";"
# SUB_OFS=","


# Input file :
# [line1] X ; Term 1 bn:ID ; Term 2 bn:ID ; ...
# [line2+] C1 ; 0 ; 1 ; ...

# Output :
# [line1] X ; Term 1 ; Term 2 ; ...
# [line2+] C1 ; 0 ; 1 ; ...
# ...

function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }


NR == 1 {
    printf("%s%s", $1, OFS);
    for (i = 2; i <= NF; i++)
    {
	LINE = trim($i);
	BN_ID_POS = match(LINE, / [^ ]*$/);
        BN_ID_BRUT = substr(LINE, RSTART, RLENGTH);
        BN_ID = substr(BN_ID_BRUT, 1, (length(BN_ID_BRUT) - 1));
        WORD = substr(LINE, 1, (RSTART - 1));
	if (i != NF)
	    printf("%s%s", WORD, OFS);
	else
	    printf("%s\n", WORD);
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
