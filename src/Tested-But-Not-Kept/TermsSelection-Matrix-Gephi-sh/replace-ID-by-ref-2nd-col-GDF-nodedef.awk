#! /bin/awk

# Replace the reference (N1, N2, ...) by its real word

# Variables :
# OFS=";"
# SUB_OFS=","

# Input file 1 : reference file
# ref ; expression
# N1 ; word bn:00000000n

# Input file 2 : data file
# ref ; ...
# N1 ; ...

# gsub(/"/, "", $2);    => deletes the double quotes around column 2

BEGIN {
    cur_context = "INIT";
}

# Put in memory 1st file
NR == FNR {
    if (length($1) > 0)
    {
	pattern = $1;
	expression = $2;

	BN_ID_POS = match(expression, / [^ ]*$/);
	BN_ID_BRUT = substr(expression, RSTART, RLENGTH);
	BN_ID = substr(BN_ID_BRUT, 2, (length(BN_ID_BRUT) - 2));
	WORD = substr(expression, 2, (RSTART - 2));

	REPLACEMENT_W[pattern] = WORD;
	REPLACEMENT_BN[pattern] = BN_ID;
	PATTERNS[pattern] = pattern;
    }
    next
}

# Rewrite next files
NR != FNR {
    if (match($0, "nodedef>") != 0)
	cur_context = "NODEDEF";
    else if (match($0, "edgedef>") != 0)
	cur_context = "EDGEDEF";

    if (cur_context == "NODEDEF")
    {
	STUDIED_COL = 2;
	COL = $STUDIED_COL;
	PATTERN = PATTERNS[COL];
	REPLACEMENT = REPLACEMENT_W[COL];

	# If we find a pattern to replace, we replace it
	if (match(PATTERN, COL) != 0)
	{
	    # for (i...) / sub(pattern[i], replacement[i])
	    sub(COL, REPLACEMENT, $STUDIED_COL);
	}
    }

    # PRINT OUT
    #print $0;
    for (i = 1; i <= NF; i++)
	if (i == NF)
	    printf("%s\n", $i);
	else
	    printf("%s%s", $i, OFS);
}
