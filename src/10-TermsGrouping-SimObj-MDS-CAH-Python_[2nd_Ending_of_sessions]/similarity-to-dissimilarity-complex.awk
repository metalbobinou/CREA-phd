#! /bin/awk

# Substract 1 to each cell, in order to change a similarity matrix to a dissimilarity matrix
# (and the contrary).
# Matrix of similarity : diagonal at 1 or 100% (object is 100% equal to itself)
# Matrix of dissimilarity : diagonal at 0 or 0% (object is 0% equal to itself)
# MDS : requires a dissimalrity matrix (with 0 at diagonal)
# Similarity to Dissimilarity : (sii + si'i' - 2 * sii')^1/2
#
# dissimilarity = (2 - 2 * similarity)^-1/2


# Variables :
# OFS = ";"

# Input file :
# X ; Word1 ; Word2 ; ...
# Word1 ; 1 ; 0.5 ; 0.2 ; ...
# Word2 ; 0.5 ; 1 ; 0.3 ; ...

# Output file :
# X ; Word1 ; Word2 ; ...
# Word1 ; 0 ; 1 ; 1.26 ; ...
# Word2 ; 1 ; 0 ; 1.18 ; ...


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
# WordN ; 1 ; 0.5 ; 0.2 ; ...
NR != 1 {
    # First column is the word
    col = $1;
    printf("%s", col);

    # For each column, process the number
    for (i = 2; i <= NF; i++)
    {
	# dissimilarity = (2 - 2 * similarity)^-1/2
	NUM = $i;
	VAL = sqrt(2 - 2 * NUM);
	printf("%s%s", OFS, VAL);
    }

    printf("\n");
}
