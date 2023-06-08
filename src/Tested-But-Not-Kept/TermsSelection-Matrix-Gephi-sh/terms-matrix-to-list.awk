#! /bin/awk

# Transforms a matrix (processed by strategy) into a list of terms and the documents they
# appear in

# Variables :
# OFS=";"
# SUB_OFS=","


# Input file :
# [line1] X ; Document 1 ; Document 2 ; ...
# [line2+] Term ; 0 ; 1 ; ...

# Output :
# Term ; 2 ; C1 ; C2


function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

# Add one element at the end of the array (index begin at 1)
# Usage : add_in_array_0_index(value, array)
function add_in_array_0_index(value, array,   iter)
{
    iter = 1; # Never begin at 0
    while (length(array[iter]) != 0)
        iter += 1;
    array[iter] = value;
    return (iter);
}


# Header + memorize the column name (therefore, the document name)
NR == 1 {
    for (i = 1; i <= NF; i++)
    {
	DOCS[i] = $i;
    }
    if (trim($NF) == "")
    {
	# Last column is empty
	MAX_DOCS = NF - 2;
    }
    else
    {
	MAX_DOCS = NF - 1;
    }
}

# Process each line
NR != 1 {
    CUR_DOCS = 0;
    for (iter in LIST_DOCS)
	delete LIST_DOCS[iter];

    TERM = $1;
    for (i = 2; i <= NF; i++)
    {
	if (trim($i) != "")
	{
	    if ($i != 0)
	    {
		CUR_DOCS++;
		add_in_array_0_index(DOCS[i], LIST_DOCS);
	    }
	}
    }

    # Output :
    # Term ; 2 ; C1 ; C2

    printf("%s%s%s", TERM, OFS, CUR_DOCS);
    # Print out
    for (iter in LIST_DOCS)
	printf("%s%s", OFS, LIST_DOCS[iter]);
    printf("\n");
}
