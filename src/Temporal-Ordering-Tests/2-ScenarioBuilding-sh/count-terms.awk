#! /bin/awk

# Add a value saying how many unique terms there are

# Variables :
# OFS=";"


# Input file :
# Part ; Nb Clusters ; Term1 ; Term2 ; Term3 ; Term5 ; ...

# Output File :
# Part ; Nb Clusters ; Nb Terms ; Term1 ; Term2 ; Term3 ; Term5 ; ...

function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

# Input file :
# Part ; Nb Clusters ; Term1 ; Term2 ; Term3 ; Term5 ; ...
{
    PART = trim($1);
    NB_CLUSTERS = trim($2);
    NB_TERMS = NF - 2;
    printf("%s%s%s%s%s", PART, OFS, NB_CLUSTERS, OFS, NB_TERMS);

    for (i = 3; i <= NF; i++)
    {
	TERM = trim($i);
	printf("%s%s", OFS, TERM);
    }

    printf("\n");

    # Clear arrays
    split("", TERMS_ARRAY, ":");
    split("", TERMS_CHECK, ":");
}
