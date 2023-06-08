#! /bin/awk

# Remove duplicate terms (BN:ID)
# Beware : terms are NOT sorted !!!
# It is required to read each field and record it

# Variables :
# OFS=";"


# Input file :
# Part ; Nb Clusters ; Term1 ; Term2 ; Term3 ; Term1 ; Term5 ; ...

# Output File :
# Part ; Nb Clusters ; Term1 ; Term2 ; Term3 ; Term5 ; ...

function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

# Measure the length of an array
# Usage : array_length(array)
function array_length(array_measured, array_i, array_k)
{
    array_k = 0;
    for (array_i in array_measured)
        array_k++;
    return array_k;
}

# Find if a value is already stored in an array (only calls with 2 parameters)
# Return 1 if found, 0 if not found
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



# Input file :
# Part ; Nb Clusters ; Term1 ; Term2 ; Term3 ; Term1 ; Term5 ; ...
{
    PART = trim($1);
    NB_CLUSTERS = trim($2);
    printf("%s%s%s", PART, OFS, NB_CLUSTERS);

    NB_TERMS = 0;
    for (i = 3; i <= NF; i++)
    {
	TERM = trim($i);

	if (length(TERMS_CHECK[TERM]) == 0)
	{
	    # If term is not already known
	    add_in_array_0_index(TERM, TERMS_ARRAY);
	    TERMS_CHECK[TERM] = 1;
	    NB_TERMS += 1;
	}
    }

    for (i = 1; i <= NB_TERMS; i++)
    {
	TERM = TERMS_ARRAY[i];
	printf("%s%s", OFS, TERM);
    }

    printf("\n");

    # Clear arrays
    split("", TERMS_ARRAY, ":");
    split("", TERMS_CHECK, ":");
}
