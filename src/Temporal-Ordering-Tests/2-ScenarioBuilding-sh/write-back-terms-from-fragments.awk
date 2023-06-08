#! /bin/awk

# Print output array with terms visibles

# Variables :
# OFS=";"
# SUB_OFS=","
# MAX_PARTS=${MAX_PARTS}  # Number max of Parts used while cutting documents


# Input file 1 : (1 line Object, 1 line Attribute, 1 line Parts)
# Concept ID ; Level ; Type Obj/Attr/Part ; Nb O ; Nb A ; Nb P ; A/O/P1 ("Name bn:ID", bn:ID) [ ; A/O/P2 ; ... ]
# (If line is an Object, 2 subfields are presents)

# Input file 2 :
# Part 0 ; Part 1 ; ...
# Nb Fragments ; Nb Fragments ; ...
# ID Fragment 1 ; ID Fragment 1 ; ...
# ID Fragment 2 ; ID Fragment 2 ; ...

# Output File :
#    Part 0   ;   Part 1   ;   Part 2   ;   Part 3
#   Nb Frags  ;  Nb Frags  ;  Nb Frags  ;  Nb Frags
#  Fragment 1 ; Fragment 1 ; Fragment 4 ; [Unordered Fragment]
# [Unordered] ; Fragment 2 ; Fragment 2 ;
#             ; Fragment 3 ; [Unordered];
#             ; [Unordered];            ;


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

BEGIN {
    MAX_FRAGMENTS_IN_PARTS = 0;
}

# 1st file : let's put in memory useful informations
## Number of words per fragment, number of parts per fragment, and which parts
NR == FNR {

    if (FNR == 1) # Avoid header
	next;

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
    # LEVEL_OF_FRAG[CONCEPT_ID] = LEVEL;
    NB_TERMS_IN_FRAG[CONCEPT_ID] = NB_OBJECTS;
    # NB_FILES_IN_FRAG[CONCEPT_ID] = NB_ATTRIBUTES;
    NB_PARTS_IN_FRAG[CONCEPT_ID] = NB_PARTS;

    if (toupper(TYPE) == "OBJECTS")
    {
	MAX_OBJ_COL = 7 + NB_OBJECTS;
	iter = 1;
	for (i = 7; i < MAX_OBJ_COL; i++)
	{
	    CUR_WORD = $i;
	    BN_ID_POS = match(CUR_WORD, / [^ ]*$/);
	    BN_ID_BRUT = substr(CUR_WORD, RSTART, RLENGTH);
	    BN_ID_TMP = substr(BN_ID_BRUT, 2, (length(BN_ID_BRUT) - 1))
	    #TERMS[CONCEPT_ID,iter] = BN_ID_TMP;
	    #TERMS_NAME[CONCEPT_ID,iter] = CUR_WORD;
	    add_in_array_1_index(BN_ID_TMP, TERMS_ID, CONCEPT_ID);
	    add_in_array_1_index(CUR_WORD, TERMS, CONCEPT_ID);
	    iter++;
	}
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
#	if (NB_PARTS != 0)
#	{
#	    # If the fragment is linked to some parts, we add the fragment
#	    #  in the list of each of those parts
#	    MAX_PAR_COL = 7 + NB_PARTS;
#	    iter = 1;
#	    for (i = 7; i <= MAX_PAR_COL; i++)
#	    {
#		CUR_PART = $i;
#		CUR_PART += 1; # Avoid part "0" for awk
#
#		# Store in an array each fragment linked with each part
#		# PARTS_IN_FRAG[CONCEPT_ID] = CUR_PART; # Require last pos...
#		add_in_array_1_index(CUR_PART, PARTS_IN_FRAG, CONCEPT_ID);
#		iter++;
#	    }
#	}
    }
}

# -- Filled : --
# LIST_FRAGS[CONCEPT_ID] = CONCEPT_ID;
## LEVEL_OF_FRAG[CONCEPT_ID] = LEVEL;
# NB_TERMS_IN_FRAG[CONCEPT_ID] = NB_OBJECTS;
## NB_FILES_IN_FRAG[CONCEPT_ID] = NB_ATTRIBUTES;
# NB_PARTS_IN_FRAG[CONCEPT_ID] = NB_PARTS;
#
# TERMS_ID[CONCEPT_ID,iter] = BN_ID
# TERMS[CONCEPT_ID,iter] = CUR_WORD
## PARTS_IN_FRAG[CONCEPT_ID,iter] = CUR_PART

# Other files (non 1st)
NR != FNR {

    # Input file 2 :
    # Part 0 ; Part 1 ; ...
    # Nb Fragments ; Nb Fragments ; ...
    # ID Fragment 1 ; ID Fragment 1 ; ...
    # ID Fragment 2 ; ID Fragment 2 ; ...

    # Output File :
    #    Part 0   ;   Part 1   ;   Part 2   ;   Part 3
    #   Nb Frags  ;  Nb Frags  ;  Nb Frags  ;  Nb Frags
    #  Fragment 1 ; Fragment 1 ; Fragment 4 ; [Unordered Fragment]
    # [Unordered] ; Fragment 2 ; Fragment 2 ;
    #             ; Fragment 3 ; [Unordered];
    #             ; [Unordered];            ;


    #    Part 0   ;   Part 1   ;   Part 2   ;   Part 3
    if (FNR == 1)
    {
	for (i = 1; i <= NF; i++)
	    printf("%s%s", $i, OFS); # Avoid 0
	printf("\n");
    }

    #   Nb Frags  ;  Nb Frags  ;  Nb Frags  ;  Nb Frags
    if (FNR == 2)
    {
	for (i = 1; i <= NF; i++)
	{
	    CUR_PART = i; # Avoid 0
	    NB_FRAGS_PER_PARTS[CUR_PART] = $i;

	    printf("%s%s", $i, OFS); # Avoid 0
	}
	printf("\n");
    }

    #  Fragment 1 ; Fragment 1 ; Fragment 4 ; [Unordered Fragment]
    #     (Write each line MAX_FRAGMENTS_IN_PARTS times)
    if (FNR > 2)
    {
	for (i_part = 1; i_part <= NF; i_part++) # Read each column
	{
	    CUR_PART = i_part;

	    if (length($i_part) == 0) # If column is empty
	    {
		printf("%s", OFS);
		continue;
	    }
	    CUR_FRAG = $i_part;
	    CUR_FRAG += 1; # Avoid 0
	    #printf("%s   ", CUR_FRAG - 1); # DEBUG

	    # NB_TERMS_IN_FRAG[CONCEPT_ID] = NB_OBJECTS;
	    # TERMS_ID[CONCEPT_ID,iter] = BN_ID
            # TERMS[CONCEPT_ID,iter] = CUR_WORD

	    NB_TERMS = NB_TERMS_IN_FRAG[CUR_FRAG];
	    for (i_term = 1; i_term <= NB_TERMS; i_term++)
	    {
		BN_ID = TERMS_ID[CUR_FRAG,i_term];
		CUR_WORD = TERMS[CUR_FRAG,i_term];

		#printf("%s", BN_ID);
		printf("%s", CUR_WORD);
		if (i_term != NB_TERMS)
		    printf("%s", SUB_OFS);
	    }
	    printf("%s", OFS);
	}
	printf("\n");
    }
}
