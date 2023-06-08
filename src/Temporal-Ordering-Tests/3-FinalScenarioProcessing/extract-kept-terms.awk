#! /bin/awk

# Extract only the term to keep (those who are NOT in the input list)

# Variables :
# OFS=","
# SUB_OFS=","

# Input file 1 (reference list of terms) :
# term2
# term5

# Input file 2+ (clusters list) :
# term1 , term2 , term 3 , ...

# Output File :
# term1 , term 3 , ...

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


# Reference file : (1 term per line)
NR == FNR {
    TERM = trim($1);
    TERMS[TERM] = 1;
    add_in_array_0_index(TERM, TERMS_LIST);
}

# Input file :
# term1 ; term2 ; term3 ; ...
NR != FNR {
    WRITTEN = 0;
    NB_TERMS = 0;
    for (i = 1; i <= NF; i++)
    {
	TERM = trim($i);

	if (length(TERMS[TERM]) == 0)
	{
	    # If term is not already known
	    if (WRITTEN == 0)
		printf("%s", TERM);
	    else
		printf("%s%s", OFS, TERM);
	    WRITTEN += 1;
	}
    }

    # Write a new line, only if something was written
    if (WRITTEN != 0)
	printf("\n");
}
