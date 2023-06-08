#! /bin/awk

# Clean the redundant number of similar parts

# Variables :
# OFS=";"
# SUB_OFS=","


# Input file (Clusters file) :
# Cluster ID ; Significance ; "TERMS"/"PARTS" ; Nb Parts ; Parts ; bn:ID 1 ; bn:ID 2 ; ...
# 0 ; 10 ; "TERMS" ; 2 ; 14 , 18 , 14, 13 ; bn:xxxxxxn ; bn:yyyyyyn
# 0 ; 10 ; "PARTS" ; 2 ; 14 , 18 , 14, 13 ; 14 , 18 ; 14 , 13

# Output File :
# Cluster ID ; Significance ; "TERMS"/"PARTS" ; Parts ; bn:ID 1 ; bn:ID 2 ; ...
# 0 ; 10 ; "TERMS" ; 2 ; 13, 14 , 18 ; bn:xxxxxxn ; bn:yyyyyyn
# 0 ; 10 ; "PARTS" ; 2 ; 13, 14 , 18 ; 14, 18 ; 14 , 13

function is_in_array(value, array,   iter)
{
    for (iter in array)
    {
        if (value == array[iter])
            return 1;
    }
    return 0;
}

# Add one element at the end of the array (index begin at 1)
function add_in_array_0_index(value, array,   iter)
{
    iter = 1; # Never begin at 0
    while (length(array[iter]) != 0)
        iter += 1;
    array[iter] = value;
    return (iter);
}


function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }


{
    CLUSTER_ID = trim($1);
    SIGNIFICANCE = trim($2);
    TYPE = trim($3);
    NB_PARTS = trim($4);
    PARTS = trim($5);

    delete READ_ARRAY;
    delete PARTS_ARRAY;
    OUT_NB_PARTS = 0;

    # Clear redundancy in parts
    LEN_ARRAY = split(PARTS, READ_ARRAY, SUB_OFS);
    for (i = 1; i <= LEN_ARRAY; i++)
    {
	CUR_PART = READ_ARRAY[i];
	# If current part is not already in the Parts Array, let's add it
	if (is_in_array(CUR_PART, PARTS_ARRAY) == 0)
	{
	    add_in_array_0_index(CUR_PART, PARTS_ARRAY);
	    OUT_NB_PARTS += 1;
	}
    }

    # Sort and clear for the output
    asort(PARTS_ARRAY, SORTED_ARRAY);
    NB_PARTS = OUT_NB_PARTS;


    # Now, let's write out everything


    printf("%s%s", CLUSTER_ID, OFS);
    printf("%s%s", SIGNIFICANCE, OFS);
    printf("%s%s", NB_PARTS, OFS);

    PARTS = "";
    for (i = 1; i <= NB_PARTS; i++)
    {
	if (i == 1)
	    PARTS = SORTED_ARRAY[i];
	else
	    PARTS = PARTS SUB_OFS SORTED_ARRAY[i];
    }
    printf("%s", PARTS);

    NB_BN = NF - 5;
    for (i = 6; i <= NF; i++)
    {
	BN_ID = trim($i);
	printf("%s%s", OFS, BN_ID);
    }
    printf("%s", "\n");
}
