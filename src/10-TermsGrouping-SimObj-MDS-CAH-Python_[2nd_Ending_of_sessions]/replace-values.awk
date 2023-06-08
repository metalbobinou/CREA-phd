#! /bin/awk

# Put a value on the diagonale

# Variables :
# OFS = ";"
# VAL_SEARCHED="1";
# VAL_REPLACED="0";

# Input file :
# X ; Word1 ; Word2 ; ...
# Word1 ; 1 ; 0,5 ; ...
# Word2 ; 0,5 ; 1 ; ...

# Output file :
# X ; Word1 ; Word2 ; ...
# Word1 ; -DIAGONAL- ; 0,5 ; ...
# Word2 ; 0,5 ; -DIAGONAL- ; ...

# Put default value if missing
BEGIN {
    if (length(DIAGONAL) == 0)
	DIAGONAL = 0;
}

# Exception : first line/header has (N - 1) words
# X ; Word1 ; Word2 ; ...
NR == 1 {
    # First column is just "X" (or space)
    printf("%s", " ");

    # For each column, print the word
    for (i = 2; i <= NF; i++)
    {
	col = $i;
	printf("%s%s", OFS, col);
    }

    # End of line
    printf("\n");
}

# Other lines are processed
# WordN ; 1 ; 0,5 ; ...
NR != 1 {
    # First column is the word
    col = $1;
    printf("%s", col);

    # For each column, process the number
    for (i = 2; i <= NF; i++)
    {
	NUM = $i;
	if (NUM == VAL_SEARCHED)
	    NUM = VAL_REPLACED;
	printf("%s%s", OFS, NUM);
    }

    printf("\n");
}
