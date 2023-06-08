#! /bin/awk

# Rewrite the 1st column of each line to change the names of terms (bn:ID)

# Variables :
# OFS=";"
# SUB_OFS=","


# Input file :
# [line1] X ; C1 ; C2 ; ...
# [line2+] Term bn:ID ; 0 ; 1 ; ...

# Output :
# [line1] X ; C1 ; C2 ; ...
# [line2+] Term ; 0 ; ...
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
    LINE = trim($1);
    BN_ID_POS = match(LINE, / [^ ]*$/);
    BN_ID_BRUT = substr(LINE, RSTART, RLENGTH);
    BN_ID = substr(BN_ID_BRUT, 1, (length(BN_ID_BRUT) - 1));
    WORD = substr(LINE, 1, (RSTART - 1));
    printf("%s%s", WORD, OFS);
    for (i = 2; i <= NF; i++)
    {
	if (i != NF)
	    printf("%s%s", $i, OFS);
	else
	    printf("%s\n", $i);
    }
}
