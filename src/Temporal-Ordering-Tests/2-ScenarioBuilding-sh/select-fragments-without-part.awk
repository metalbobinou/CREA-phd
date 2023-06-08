#! /bin/awk

# Select candidates fragments for each part :
# - If a fragment has no part at all, it is also kept in all parts
# (another script calculate the priority)

# Variables :
# OFS=";"
# SUB_OFS=","
# MAX_PARTS=${MAX_PARTS}  # Number max of Parts used while cutting documents


# Input file : (1 line Object, 1 line Attribute, 1 line Parts)
# Concept ID ; Level ; Type Obj/Attr/Part ; Nb O ; Nb A ; Nb P ; A/O/P1 ("Name bn:ID", bn:ID) [ ; A/O/P2 ; ... ]
# (If line is an Object, 2 subfields are presents)

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
# Usage : add_in_array_0_index(calue, array)
function add_in_array_0_index(value_add_in_array_0_index, array_add_in_array_0_index)
{
    iter_add_in_array_0_index = 1; # Never begin at 0
    while (length(array_add_in_array_0_index[iter_add_in_array_0_index]) != 0)
        iter_add_in_array_0_index += 1;
    array_add_in_array_0_index[iter_add_in_array_0_index] = value_add_in_array_0_index;
    return (iter_add_in_array_0_index);
}

# Add one element at the end of the array, with index given in parameter (begin at 1)
# Usage : add_in_array_1_index(value, array, index)
function add_in_array_1_index(value_add_in_array_1_index, array_add_in_array_1_index, index_add_in_array_1_index)
{
    iter_add_in_array_1_index = 1; # Never begin at 0
    while (length(array_add_in_array_1_index[index_add_in_array_1_index,iter_add_in_array_1_index]) != 0)
        iter_add_in_array_1_index += 1;
    array_add_in_array_1_index[index_add_in_array_1_index,iter_add_in_array_1_index] = value_add_in_array_1_index;
    return (iter_add_in_array_1_index);
}


BEGIN {
    for (CUR_PART = 1; CUR_PART <= MAX_PARTS; CUR_PART++)
	NB_FRAG_IN_PARTS[CUR_PART] = 0;
}

{
    # Input file : (1 line Object, 1 line Attribute, 1 line Parts)
    # Concept ID ; Level ; Type Obj/Attr/Part ; Nb O ; Nb A ; Nb P ; A/O/P1 ("Name bn:ID", bn:ID) [ ; A/O/P2 ; ... ]
    # (If line is an Object, 2 subfields are presents)

    CONCEPT_ID = $1;
    LEVEL = $2;
    TYPE = $3;
    NB_OBJECTS = $4;
    NB_ATTRIBUTES = $5;
    NB_PARTS = $6;

    CONCEPT_ID += 1; # Avoid 0

#    if (toupper(TYPE) == "OBJECTS")
#    {
#	MAX_OBJ_COL = 7 + NB_OBJECTS;
#	iter = 1;
#	for (i = 7; i < MAX_OBJ_COL; i++)
#	{
#	    CUR_WORD = $i;
#	    BN_ID_POS = match(CUR_WORD, / [^ ]*$/);
#	    BN_ID_BRUT = substr(CUR_WORD, RSTART, RLENGTH);
#	    BN_ID_TMP = substr(BN_ID_BRUT, 2, (length(BN_ID_BRUT) - 1))
#	    OBJECTS[CONCEPT_ID,iter] = BN_ID_TMP;
#	    OBJECTS_NAME[CONCEPT_ID,iter] = CUR_WORD;
#	    iter++;
#	}
#    }

#    if (toupper(TYPE) == "ATTRIBUTES")
#    {
#	MAX_ATT_COL = 7 + NB_ATTRIBUTES;
#	iter = 1;
#	for (i = 7; i < MAX_ATT_COL; i++)
#	{
#	    CUR_FILE = $i;
#	    ATTRIBUTES[CONCEPT_ID,iter] = CUR_FILE;
#	    iter++;
#	}
#    }

    if (toupper(TYPE) == "PARTS")
    {
	if (NB_PARTS == 0)
	{
	    # If this fragment has no specific part, we add it for all parts
	    for (i = 1; i <= MAX_PARTS; i++)
	    {
		add_in_array_1_index(CONCEPT_ID, PARTS, i);
		NB_FRAG_IN_PARTS[i] += 1;
	    }
	}
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
	    CUR_FRAG = PARTS[CUR_PART,iter];
	    CUR_FRAG -= 1; # Avoid 0
	    printf("%s%s", OFS, CUR_FRAG);
	}
	printf("\n");
    }
}
