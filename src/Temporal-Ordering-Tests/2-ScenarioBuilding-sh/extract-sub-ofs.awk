#! /bin/awk

# Extract each subfield into a field

# Variables :
# OFS=";"
# SUB_OFS=","


# Input file :
# Part ; Nb Clusters ; Term1 , Term2 , Term3 ; Term1 , Term5 ; ...

# Output File :
# Part ; Nb Clusters ; Term1 ; Term2 ; Term3 ; Term1 ; Term5 ; ...

function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

{
    PART = trim($1);
    NB_CLUSTERS = trim($2);
    printf("%s%s%s", PART, OFS, NB_CLUSTERS);

    for (i = 3; i <= NF; i++)
    {
	col = trim($i);

        subfields = split(col, subfields_array, SUB_OFS);
        for (j = 1; j <= subfields; j++)
        {
            sub_col = subfields_array[j];

            TERM = trim(sub_col);
	    printf("%s%s", OFS, TERM);
	}
    }

    printf("\n");
}
