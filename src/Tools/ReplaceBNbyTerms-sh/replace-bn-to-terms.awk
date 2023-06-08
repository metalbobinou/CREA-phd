#! /bin/awk

# Change every occurrences of bn:ID from the reference file (1st file) into
# the term associated with it in the data file (2nd file).

# Variables :
# OFS = ";"

# Input file 1 (Reference File) :
# bn:ID ; Terms
# bn:xxn ; Term1
# bn:xxn ; Term2
# ... ; ...

# Input file 2 (data file) :
# ... ; bn:xxn ; ...

# Output file :
# ... ; Term1 ; ...


function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

# Reference file
# bn:ID ; Terms
NR == FNR {
    BN_ID = trim($1);
    WORD = trim($2);
    TERM[BN_ID] = WORD;

    next ;
}

# Data file
NR != FNR {
    for (i = 1; i <= NF; i++)
    {
	col = trim($i);

	BN_ID = col;
	if (length(TERM[BN_ID]) != 0)
	    WORD = TERM[BN_ID];
	else
	    WORD = BN_ID;

	if (i == 1)
	    printf("%s", WORD);
	else
	    printf("%s%s", OFS, WORD);
    }
    printf("\n");
}
