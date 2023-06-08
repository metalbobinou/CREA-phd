#! /bin/awk

# Merge two files containing fragments linked to parts
# DUPLICATES ARE ELIMINATED (can work with only 1 file ;) )

# Variables :
# OFS=";"
# MAX_PARTS=${MAX_PARTS}  # Number max of Parts used while cutting documents


# Input file 1 :
# Part ; Nb Fragments ; ID Fragment 1 [ ; ID Fragment 2 ; ... ]

# Input file 2 :
# Part ; Nb Fragments ; ID Fragment 1 [ ; ID Fragment 2 ; ... ]

# Output File :
# Part ; Nb Fragments ; ID Fragment 1 [ ; ID Fragment 2 ; ... ]


function is_in_array(is_in_array_value, is_in_array_array)
{
    for (is_in_array_iter in is_in_array_array)
    {
        if (is_in_array_value == is_in_array_array[is_in_array_iter])
            return 1;
    }
    return 0;
}

# Add one element at the end of the array (index begin at 1)
# Return the position of the new element
# Usage : add_in_array_0_index(calue, array)
function add_in_array_0_index(value_add_in_array_0_index, array_add_in_array_0_index)
{
    iter_add_in_array_0_index = 1; # Never begin at 0
    while (length(array_add_in_array_0_index[iter_add_in_array_0_index]) != 0)
        iter_add_in_array_0_index += 1;
    array_add_in_array_0_index[iter_add_in_array_0_index] = value_add_in_array_0_index;
    return (iter_add_in_array_0_index);
}

# Add one element at the end of the array (index begin at 1) without duplicate
# Return the position of the new element, or "0" if element already exists
# Usage : add_in_array_0_index(calue, array)
function add_in_array_0_index_nodup(value_add_in_array_0_index_nodup, array_add_in_array_0_index_nodup)
{
    iter_add_in_array_0_index_nodup = 1; # Never begin at 0
    while ((length(array_add_in_array_0_index_nodup[iter_add_in_array_0_index_nodup]) != 0) &&
	   (array_add_in_array_0_index_nodup[iter_add_in_array_0_index_nodup] != value_add_in_array_0_index_nodup))
        iter_add_in_array_0_index_nodup += 1;
    if (length(array_add_in_array_0_index_nodup[iter_add_in_array_0_index_nodup]) == 0)
    {
	array_add_in_array_0_index_nodup[iter_add_in_array_0_index_nodup] = value_add_in_array_0_index_nodup;
	return (iter_add_in_array_0_index);
    }
    return (0);
}


# Add one element at the end of the array, with index given in parameter (begin at 1)
# Return the position of the new element
# Usage : add_in_array_1_index(value, array, index)
function add_in_array_1_index(value_add_in_array_1_index, array_add_in_array_1_index, index_add_in_array_1_index)
{
    iter_add_in_array_1_index = 1; # Never begin at 0
    while (length(array_add_in_array_1_index[index_add_in_array_1_index,iter_add_in_array_1_index]) != 0)
        iter_add_in_array_1_index += 1;
    array_add_in_array_1_index[index_add_in_array_1_index,iter_add_in_array_1_index] = value_add_in_array_1_index;
    return (iter_add_in_array_1_index);
}

# Add one element at the end of the array, with index given in parameter (begin at 1) without duplicate
# Return the position of the new element, or "0" if element already exists
# Usage : add_in_array_1_index_nodup(value, array, index)
function add_in_array_1_index_nodup(value_add_in_array_1_index_nodup, array_add_in_array_1_index_nodup, index_add_in_array_1_index_nodup)
{
    iter_add_in_array_1_index_nodup = 1; # Never begin at 0
    while ((length(array_add_in_array_1_index_nodup[index_add_in_array_1_index_nodup,iter_add_in_array_1_index_nodup]) != 0) &&
	   (array_add_in_array_1_index_nodup[index_add_in_array_1_index_nodup,iter_add_in_array_1_index_nodup] != value_add_in_array_1_index_nodup))
	   iter_add_in_array_1_index_nodup += 1;
    if (length(array_add_in_array_1_index_nodup[index_add_in_array_1_index_nodup,iter_add_in_array_1_index_nodup]) == 0)
    {
	array_add_in_array_1_index_nodup[index_add_in_array_1_index_nodup,iter_add_in_array_1_index_nodup] = value_add_in_array_1_index_nodup;
	return (iter_add_in_array_1_index_nodup);
    }
    return (0);
}




BEGIN {
    for (CUR_PART = 1; CUR_PART <= MAX_PARTS; CUR_PART++)
	NB_FRAG_IN_PARTS[CUR_PART] = 0;
}

{
    CUR_PART = $1;
    MAX_FRAGS = $2;

    CUR_PART += 1; # AVOID 0;

    for (i = 3; i <= NF; i++)
    {
	CUR_FRAG = $i;
	pos = add_in_array_1_index_nodup(CUR_FRAG, FRAGS, CUR_PART);
	if (pos != 0)
	    NB_FRAG_IN_PARTS[CUR_PART] += 1;
    }
}


# Output File :
# Part ; Nb Fragments ; ID Fragment 1 [ ; ID Fragment 2 ; ... ]

END {
    for (CUR_PART = 1; CUR_PART <= MAX_PARTS; CUR_PART++)
    {
	OUT_PART = CUR_PART - 1; # Minus 1 for Part number (avoid 0)
	NB_FRAGS = NB_FRAG_IN_PARTS[CUR_PART];

	printf("%s%s%s", OUT_PART, OFS, NB_FRAGS);

	for (iter = 1; iter <= NB_FRAGS; iter++)
	{
	    CUR_FRAG = FRAGS[CUR_PART,iter];
	    printf("%s%s", OFS, CUR_FRAG);
	}
	printf("\n");
    }
}
