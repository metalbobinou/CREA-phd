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

NR == FNR {
    pattern = $1;
    expression = $2;

    BN_ID_POS = match(expression, / [^ ]*$/);
    BN_ID_BRUT = substr(expression, RSTART, RLENGTH);
    BN_ID = substr(BN_ID_BRUT, 2, (length(BN_ID_BRUT) - 2));
    WORD = substr(expression, 2, (RSTART - 2));

    REPLACEMENT_W[pattern] = WORD;
    REPLACEMENT_BN[pattern] = BN_ID;
    next
}

NR != FNR {
    COL = $1;
    REPLACEMENT = REPLACEMENT_W[COL];

    # for (i...) / sub(pattern[i], replacement[i])
    sub(COL, REPLACEMENT, $1);

    #print $0;
    for (i = 1; i <= NF; i++)
	if (i == NF)
	    printf("%s\n", $i);
	else
	    printf("%s%s", $i, OFS);
}
