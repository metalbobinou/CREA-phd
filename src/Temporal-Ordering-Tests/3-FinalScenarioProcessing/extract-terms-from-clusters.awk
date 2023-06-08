#! /bin/awk

# Extract each term from each cluster, and print it on one line

# Variables :
# OFS=";"
# SUB_OFS=","


# Input file :
# Term1 , Term2 , Term3 , ...
# Term1 , Term5 , ...

# Output File :
# Term1
# Term2
# ...

function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

{
    for (i = 1; i <= NF; i++)
    {
	COL = trim($i);

        subfields = split(COL, subfields_array, SUB_OFS);
        for (j = 1; j <= subfields; j++)
        {
            sub_col = subfields_array[j];

            TERM = trim(sub_col);
	    printf("%s%s", TERM, "\n");
	}
    }
}
