#! /bin/awk

# Priorize fragments based on the number of termss and parts linked :
# Part - 1st priority
# Nb of Terms - 2nd priority
# - if a fragment has the part and a lot of terms attached, it is put first
# - if a fragment has the part and few termss attached, it is put next
# - if a fragment has a lot of terms attached without any part, it is put next
# - if a fragment has few terms attached without any part, it is put last
#
# Other ideas to dig ?
# deepness level ? number of files ?

# Variables :
# OFS=";"
# SUB_OFS=","
# MAX_PARTS=${MAX_PARTS}  # Number max of Parts used while cutting documents


# Input file 1 : (1 line Object, 1 line Attribute, 1 line Parts)
# Concept ID ; Level ; Type Obj/Attr/Part ; Nb O ; Nb A ; Nb P ; A/O/P1 ("Name bn:ID", bn:ID) [ ; A/O/P2 ; ... ]
# (If line is an Object, 2 subfields are presents)

# Input file 2 :
# Part ; Nb Fragments ; ID Fragment 1 [ ; ID Fragment 2 ; ... ]

# Output File :
# Part ; Nb Fragments ; ID Fragment 1 [ ; ID Fragment 2 ; ... ]


# Measure the length of an array
# Usage : array_length(array)
function array_length(array_measured, array_i, array_k)
{
    array_k = 0;
    for (array_i in array_measured)
	array_k++;
    return array_k;
}

# Search for an element in an array. If element is found : 1, else 0
# Usage : is_in_array(value, array);
function is_in_array(is_in_array_value, is_in_array_array, is_in_array_iter)
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




# Sort an array based on the number of terms linked to each Fragment
# REQUIREMENTS: NB_TERMS_IN_FRAG[fragment_ID]
# Usage : sort_by_nb_terms(array_of_fragments_ID)
function sort_by_nb_terms(sort_array, sort_x, sort_y, sort_z)
{
  for (sort_x in sort_array)
  {
      sort_y = sort_array[sort_x];
      nb_terms_y = NB_TERMS_IN_FRAG[sort_y];
      sort_z = sort_x - 1;
      nb_terms_z = NB_TERMS_IN_FRAG[sort_z];
      while ((sort_z) && (nb_terms_z > nb_terms_y))
      {
          sort_array[sort_z + 1] = sort_array[sort_z];
          sort_z--;
	  nb_terms_z = NB_TERMS_IN_FRAG[sort_z];
      }
      sort_array[sort_z + 1] = sort_y;
  }
}


# Reverse an array by putting it in another one
# Usage : reverse_array(input_array, output_array)
function reverse_array(array_to_reverse, array_reversed, reverse_array_len, reverse_array_decr, reverse_array_incr)
{
    reverse_array_len = array_length(array_to_reverse);
    reverse_array_incr = 1;
    for (reverse_array_decr = reverse_array_len;
	 reverse_array_decr > 0;
	 reverse_array_decr--)
    {
	array_reversed[reverse_array_incr] = array_to_reverse[reverse_array_decr];
	reverse_array_incr++;
    }
}


# Merge two arrays in a new one
# Usage : merge_arrays(array1, array2, out_array)
function merge_arrays(merge_arrays1, merge_arrays2, out_merge_arrays, merge_arrays_mid, merge_arrays_total, merge_arrays_iter)
{
    merge_arrays_iter = 1;
    merge_arrays_total = array_length(merge_arrays1);
    while (merge_arrays_iter <= merge_arrays_total)
    {
	out_merge_arrays[merge_arrays_iter] = merge_arrays1[merge_arrays_iter];
	merge_arrays_iter++;
    }

    merge_arrays_mid = merge_arrays_total;
    merge_arrays_total += array_length(merge_arrays2);
    while (merge_arrays_iter <= merge_arrays_total)
    {
	out_merge_arrays[merge_arrays_iter] = merge_arrays2[merge_arrays_iter - merge_arrays_mid];
	merge_arrays_iter++;
    }
}

# 1st file : let's put in memory useful informations
## Number of words per fragment, number of parts per fragment, and which parts
NR == FNR {

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

    LIST_FRAGS[CONCEPT_ID] = CONCEPT_ID;
    LEVEL_OF_FRAG[CONCEPT_ID] = LEVEL;
    NB_TERMS_IN_FRAG[CONCEPT_ID] = NB_OBJECTS;
    # NB_FILES_IN_FRAG[CONCEPT_ID] = NB_ATTRIBUTES;
    NB_PARTS_IN_FRAG[CONCEPT_ID] = NB_PARTS;

    if (toupper(TYPE) == "OBJECTS")
    {
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
    }

    if (toupper(TYPE) == "ATTRIBUTES")
    {
#	MAX_ATT_COL = 7 + NB_ATTRIBUTES;
#	iter = 1;
#	for (i = 7; i < MAX_ATT_COL; i++)
#	{
#	    CUR_FILE = $i;
#	    ATTRIBUTES[CONCEPT_ID,iter] = CUR_FILE;
#	    iter++;
#	}
    }


    if (toupper(TYPE) == "PARTS")
    {
	if (NB_PARTS != 0)
	{
	    # If the fragment is linked to some parts, we add the fragment
	    #  in the list of each of those parts
	    MAX_PAR_COL = 7 + NB_PARTS;
	    iter = 1;
	    for (i = 7; i <= MAX_PAR_COL; i++)
	    {
		CUR_PART = $i;
		CUR_PART += 1; # Avoid part "0" for awk

		# Store in an array each fragment linked with each part
		# PARTS_IN_FRAG[CONCEPT_ID] = CUR_PART; # Require last pos...
		add_in_array_1_index(CUR_PART, PARTS_IN_FRAG, CONCEPT_ID);
		iter++;
	    }
	}
    }
}

# -- Filled : --
# LIST_FRAGS[CONCEPT_ID] = CONCEPT_ID;
# LEVEL_OF_FRAG[CONCEPT_ID] = LEVEL;
# NB_TERMS_IN_FRAG[CONCEPT_ID] = NB_OBJECTS;
## NB_FILES_IN_FRAG[CONCEPT_ID] = NB_ATTRIBUTES;
# NB_PARTS_IN_FRAG[CONCEPT_ID] = NB_PARTS;
#
# PARTS_IN_FRAG[CONCEPT_ID,iter] = CUR_PART

# Other files (non 1st)
NR != FNR {

    # Input file 2 :
    # Part ; Nb Fragments ; ID Fragment 1 [ ; ID Fragment 2 ; ... ]

    CUR_PART = $1;
    NB_FRAGS = $2;

    CUR_PART += 1; # Avoid 0

    # Build 2 arrays :
    # - 1 with fragments linked to the part
    NB_ARRAY_PARTS = 0;
    for (iter in ARRAY_PARTS)
	delete ARRAY_PARTS[iter];
    # - 1 with fragments linked to abslutely NO parts
    NB_ARRAY_NO_PARTS = 0;
    for (iter in ARRAY_NO_PARTS)
	delete ARRAY_NO_PARTS[iter];

    for (iter = 3; iter <= NF; iter++)
    {
	CUR_FRAG = $iter;

	CUR_FRAG += 1; # Avoid 0

	NB_PARTS_FRAG = NB_PARTS_IN_FRAG[CUR_FRAG];
	if (NB_PARTS_FRAG == 0)
	{
	    # Add fragments with no parts in its array
	    add_in_array_0_index(CUR_FRAG, ARRAY_NO_PARTS);
	    NB_ARRAY_NO_PARTS += 1;
	}
	else
	{
	    # Fragments with at least 1 part
	    i = 1;
	    while ((i <= NB_PARTS_FRAG) &&
		   (PARTS_IN_FRAG[CUR_FRAG,i] != CUR_PART))
		i++;
	    if (PARTS_IN_FRAG[CUR_FRAG,i] == CUR_PART)
	    {
		add_in_array_0_index(CUR_FRAG, ARRAY_PARTS);
		NB_ARRAY_PARTS += 1;
	    }
	}
    }

#    print "CUR_PART : " CUR_PART > "/dev/stderr";
#    print "ARRAY PARTS : (" NB_ARRAY_PARTS ")" > "/dev/stderr";
#    for (iter = 1; iter <= NB_ARRAY_PARTS; iter++)
#	print ARRAY_PARTS[iter] > "/dev/stderr";
#    print "ARRAY NO PARTS : (" NB_ARRAY_NO_PARTS ")" > "/dev/stderr";
#    for (iter = 1; iter <= NB_ARRAY_NO_PARTS; iter++)
#	print ARRAY_NO_PARTS[iter] > "/dev/stderr";

    for (iter in TMP_ARRAY)
	delete TMP_ARRAY[iter];
    for (iter in ARRAY_PARTS_PRIORIZED)
	delete ARRAY_PARTS_PRIORIZED[iter];
    # Copy array for manipulation
    for (iter = 1; iter <= NB_ARRAY_PARTS; iter++)
	TMP_ARRAY[iter] = ARRAY_PARTS[iter];

    # Priorize fragments in the output list :
    # Part Linked = 1st criteria, Big Nb of Terms = 2nd criteria
    sort_by_nb_terms(TMP_ARRAY);
    reverse_array(TMP_ARRAY, ARRAY_PARTS_PRIORIZED);

#    print "TMP_ARRAY (" array_length(TMP_ARRAY) ")"  > "/dev/stderr";
#    for (iter in TMP_ARRAY)
#	print (TMP_ARRAY[iter] - 1) > "/dev/stderr";
#    print "PARTS ARRAY PRIORIZED (" array_length(ARRAY_PARTS_PRIORIZED) ")"  > "/dev/stderr";
#    for (iter in ARRAY_PARTS_PRIORIZED)
#	print (ARRAY_PARTS_PRIORIZED[iter] - 1) > "/dev/stderr";
#
#    print "----!!!!!!!------" > "/dev/stderr";


    for (iter in TMP_ARRAY)
	delete TMP_ARRAY[iter];
    for (iter in ARRAY_NO_PARTS_PRIORIZED)
	delete ARRAY_NO_PARTS_PRIORIZED[iter];
    # Copy array for manipulation
    for (iter = 1; iter <= NB_ARRAY_NO_PARTS; iter++)
	TMP_ARRAY[iter] = ARRAY_NO_PARTS[iter];

    # Priorize fragments in the output list :
    # Part Linked = 1st criteria, Big Nb of Terms = 2nd criteria
    sort_by_nb_terms(TMP_ARRAY);
    reverse_array(TMP_ARRAY, ARRAY_NO_PARTS_PRIORIZED);

#    print "TMP_ARRAY (" array_length(TMP_ARRAY) ")"  > "/dev/stderr";
#    for (iter in TMP_ARRAY)
#	print (TMP_ARRAY[iter] - 1) > "/dev/stderr";
#    print "NO PARTS ARRAY PRIORIZED (" array_length(ARRAY_NO_PARTS_PRIORIZED) ")"  > "/dev/stderr";
#    for (iter in ARRAY_NO_PARTS_PRIORIZED)
#	print (ARRAY_NO_PARTS_PRIORIZED[iter] - 1) > "/dev/stderr";
#    print "----!!!!!!!------" > "/dev/stderr";


    # Merge the array with parts and the array without parts linked
    for (iter in SORTED_ARRAY)
	delete SORTED_ARRAY[iter];

    merge_arrays(ARRAY_PARTS_PRIORIZED, ARRAY_NO_PARTS_PRIORIZED, SORTED_ARRAY);

#    print "PRIORIZED OUTPUT (" array_length(ARRAY_NO_PARTS_PRIORIZED) ")"  > "/dev/stderr";
#    for (iter in SORTED_ARRAY)
#	print (SORTED_ARRAY[iter] - 1) > "/dev/stderr";



    # Output File :
    # Part ; Nb Fragments ; ID Fragment 1 [ ; ID Fragment 2 ; ... ]

    # Print output
    OUT_PART = CUR_PART - 1; # Minus 1 for Part number (avoid 0)
    NB_FRAGS = array_length(SORTED_ARRAY);
    printf("%s%s%s", OUT_PART, OFS, NB_FRAGS);
    for (iter = 1; iter <= NB_FRAGS; iter++)
    {
	CUR_FRAG = SORTED_ARRAY[iter];
	CUR_FRAG -= 1; # Avoid 0
	printf("%s%s", OFS, CUR_FRAG);
    }
    printf("\n");
}
