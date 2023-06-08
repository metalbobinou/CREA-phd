#! /bin/awk

# Calculate the order of the fragments :
# - Find all the possible parts of each word within each file
# - Gather multiple useful values (word = parts, word + file = parts, word + part = files)
# - For each concept/fragment :
#  - find all the parts of each word
#  - find all the parts of each word within each file
# - Print all the parts of each word within each file
# When reading the parts, this script creates the INTERSECTION of the parts per word :
#  only the common parts are shown (common parts of each word in the concept)

# Variables :
# OFS=";"
# SUB_OFS=","
# MAX_PARTS=${MAX_PARTS}  # Number max of Parts used while cutting documents
# MAX_ORDERING_FILES=${MAX_ORDERING_FILES}  # Number max of files in Order file

# Input file 1 (Ordering file) :
# "\"Name bn:ID\" ; bn:ID ; Part ; File1 [; File2 ; ... ]

# Input file 2 (Fragments file) : (1 line Object, 1 line Attribute)
# Concept ID ; Level ; Type Obj/Attr ; Nb O ; Nb A ; A/O1 ("Name bn:ID", bn:ID) [ ; A/O2 ; ... ]
# (If line is an Object, 2 subfields are presents)

# Output File : (1 line Object, 1 line Attribute)
# Concept ID ; Nb Parts ; Part 1 [; Part 2 ; ... ]



# Search for a value in an array (thanks StackOverflow)
# USAGE : split("444 555 666", z); smartmatch(555, z);
# WARNING : CANNOT SEARCH FOR 0 !
function smartmatch(diamond, rough, x, y)
{
    for (x in rough) y[rough[x]]
    return diamond in y
}

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
function add_in_array_0_index(value_add_in_array_0_index, array_add_in_array_0_index)
{
    iter_add_in_array_0_index = 1; # Never begin at 0
    while (length(array_add_in_array_0_index[iter_add_in_array_0_index]) != 0)
	iter_add_in_array_0_index += 1;
    array_add_in_array_0_index[iter_add_in_array_0_index] = value_add_in_array_0_index;
    return (iter_add_in_array_0_index);
}

# Add one element at the end of the array, with index given in parameter (begin at 1)
function add_in_array_1_index(value_add_in_array_1_index, array_add_in_array_1_index, index_add_in_array_1_index)
{
    iter_add_in_array_1_index = 1; # Never begin at 0
    while (length(array_add_in_array_1_index[index_add_in_array_1_index,iter_add_in_array_1_index]) != 0)
	iter_add_in_array_1_index += 1;
    array_add_in_array_1_index[index_add_in_array_1_index,iter_add_in_array_1_index] = value_add_in_array_1_index;
    return (iter_add_in_array_1_index);
}

# Add one element at the end of the array, with 2 indexes given in parameter (begin at 1)
function add_in_array_2_index(value_add_in_array_2_index, array_add_in_array_2_index, index1_add_in_array_2_index, index2_add_in_array_2_index)
{
    iter_add_in_array_2_index = 1; # Never begin at 0
    while (length(array_add_in_array_2_index[index1_add_in_array_2_index,index2_add_in_array_2_index,iter_add_in_array_2_index]) != 0)
	iter_add_in_array_2_index += 1;
    array_add_in_array_2_index[index1_add_in_array_2_index,index2_add_in_array_2_index,iter_add_in_array_2_index] = value_add_in_array_2_index;
    return (iter_add_in_array_2_index);
}

function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }



BEGIN {
    LAST_BN_ID = "";
    PART_ITER = 1;
    FILE_ITER = 1;
}

# Let's memorize the ordering file
FNR == NR {
    BN_ID = trim($2);
    CUR_PART = $3;

    ##########################
    # NEED FOR : Keep the parts where a word appears in
    # NB_PARTS_W[word] = total parts for this word
    # PARTS_W[word + index] = part
    if (BN_ID != LAST_BN_ID)
    {
	NB_PARTS_W[LAST_BN_ID] = PART_ITER - 1;
	NB_FILES_W[LAST_BN_ID] = FILE_ITER - 1;

	BN_LIST[LAST_BN_ID] = LAST_BN_ID;

        PART_ITER = 1;
	FILE_ITER = 1;
	LAST_BN_ID = BN_ID;

	for (iter in PARTS)
            delete PARTS[iter];
        for (iter in FILES)
            delete FILES[iter];
    }

    ##########################
    # NEED FOR : Keep the files where a word (and part) appears in
    # NB_FILES_WP[word + part] = total files for this word and part
    # FILES_WP[word + part + index] = files
    # NB_FILES_W[word] = total files for this word
    # FILES_W[word + index] = files
    iter = 1;
    for (i = 4; i <= NF; i++)
    {
	CUR_FILE = $i;
	# FILES_WP[BN_ID,CUR_PART,iter] = CUR_FILE;
	add_in_array_2_index(CUR_FILE, FILES_WP, BN_ID, CUR_PART);
	if (! is_in_array(CUR_FILE,FILES)) # If file not already present
	{
	    add_in_array_1_index(CUR_FILE, FILES_W, BN_ID);
	    FILES[FILE_ITER] = CUR_FILE;
	    FILE_ITER++;
	}
	iter++;
    }
    NB_FILES_WP[BN_ID,CUR_PART] = iter;

    ##########################
    # NEED FOR : keep the parts where a word and file appears in
    # NB_PARTS_WF[word + file] = total parts for this word
    # PARTS_WF[word + file + index] = part
    for (i = 4; i <= NF; i++)
    {
	# NB_PARTS[word + file] = total parts
	CUR_FILE = $i;
	if (length(NB_PARTS_WF[BN_ID,CUR_FILE]) == 0)
	{
	    NB_PARTS_WF[BN_ID,CUR_FILE] = 1;
	    # PARTS[word + file + index] = part
	    PARTS_WF[BN_ID,CUR_FILE,1] = CUR_PART;
	}
	else
	{
	    NB_PARTS_WF[BN_ID,CUR_FILE] += 1;
	    # PARTS[word + file + index] = part
	    #CUR_POS_P_WF = NB_PARTS_WF[BN_ID,CUR_FILE];
	    #PARTS_WF[BN_ID,CUR_FILE,CUR_POS_P_WF] = CUR_PART;
	    add_in_array_2_index(CUR_PART, PARTS_WF, BN_ID, CUR_FILE);
	}
    }

    if (! is_in_array(CUR_PART,PARTS))
    {
	add_in_array_1_index(CUR_PART, PARTS_W, BN_ID);
	PARTS[PART_ITER] = CUR_PART;
	PART_ITER++;
    }

    next;
}

# Now, on the Fragments, let's apply the order
{

#    # Print the 1st file for debug
#    for (bn_iter in BN_LIST)
#    {
#	BN_ID = BN_LIST[bn_iter];
#	nb_parts = NB_PARTS_W[BN_ID];
#	nb_files = NB_FILES_W[BN_ID];
#
#	files_txt = "";
#	for (iter = 1; iter <= nb_files; iter++)
#	{
#	    files_txt = files_txt " " FILES_W[BN_ID,iter];
#	}
#	parts_txt = "";
#	for (iter = 1; iter <= nb_parts; iter++)
#	{
#	    parts_txt = parts_txt " " PARTS_W[BN_ID,iter];
#	}
#
#	#print BN_ID ";" nb_parts ";" nb_files ";" files_txt ";" parts_txt > "./file.csv";
#	print BN_ID ";" nb_parts ";" nb_files > "./file.csv";
#
#	for (iter = 1; iter <= nb_files; iter++)
#	{
#	    file = FILES_W[BN_ID,iter];
#	    nb_parts_loop = NB_PARTS_WF[BN_ID,file];
#
#	    parts_txt = "";
#	    for (iter_loop = 1; iter_loop <= nb_parts_loop; iter_loop++)
#	    {
#		parts_loop = PARTS_WF[BN_ID,file,iter_loop];
#		parts_txt = parts_txt " " parts_loop;
#	    }
#	    #print BN_ID ";" nb_parts ";" nb_files ";" file ";" parts_txt > "./file.csv";
#	}
#
#	for (iter = 1; iter <= nb_parts; iter++)
#	{
#	    part = PARTS_W[BN_ID,iter];
#	    nb_files_loop = NB_FILES_WP[BN_ID,part];
#
#	    files_txt = "";
#	    for (iter_loop = 1; iter_loop <= nb_files_loop; iter_loop++)
#	    {
#		files_loop = FILES_WP[BN_ID,part,iter_loop];
#		files_txt = files_txt " " files_loop;
#	    }
#	    print BN_ID ";" nb_parts ";" nb_files ";" part ";" files_txt > "./file.csv";
#	}
#
#
#	## Verifier les fichiers et les parties
#   }


    if ((toupper($3) != "OBJECTS") && (toupper($3) != "ATTRIBUTES"))
    {
	print $0;
	next;
    }

# Concept ID ; Level ; Type Obj/Attr ; Nb O ; Nb A ; A/O1 ("Name bn:ID", bn:ID) [ ; A/O2 ]

    CONCEPT_ID = $1;
    LEVEL = $2;
    TYPE = $3;
    NB_OBJECTS = $4;
    NB_ATTRIBUTES = $5;

    LIST_CONCEPTS[CONCEPT_ID] = CONCEPT_ID;
    LEVELS[CONCEPT_ID] = LEVEL;
    NB_OBJ[CONCEPT_ID] = NB_OBJECTS;
    NB_ATT[CONCEPT_ID] = NB_ATTRIBUTES;

    if (toupper($3) == "OBJECTS")
    {
	MAX_OBJ_COL = 6 + NB_OBJECTS;
	iter = 1;
	for (i = 6; i < MAX_OBJ_COL; i++)
	{
	    CUR_WORD = $i;
	    BN_ID_POS = match(CUR_WORD, / [^ ]*$/);
	    BN_ID_BRUT = substr(CUR_WORD, RSTART, RLENGTH);
	    BN_ID_TMP = substr(BN_ID_BRUT, 2, (length(BN_ID_BRUT) - 1))
	    #OBJECTS[CONCEPT_ID,iter] = BN_ID_TMP;
	    #OBJECTS_NAME[CONCEPT_ID,iter] = CUR_WORD;
	    add_in_array_1_index(BN_ID_TMP, OBJECTS, CONCEPT_ID);
	    add_in_array_1_index(CUR_WORD, OBJECTS_NAME, CONCEPT_ID);
	    iter++;
	}
	next;
    }

    if (toupper($3) == "ATTRIBUTES")
    {
	MAX_ATT_COL = 6 + NB_ATTRIBUTES;
	iter = 1;
	for (i = 6; i < MAX_ATT_COL; i++)
	{
	    CUR_FILE = $i;
	    #ATTRIBUTES[CONCEPT_ID,iter] = CUR_FILE;
	    add_in_array_1_index(CUR_FILE, ATTRIBUTES, CONCEPT_ID);
	    iter++;
	}
    }
}

    # OUTPUT
    # Concept ID ; Nb Parts ; Part 1 [; Part 2 ; ... ]

    # NB_FILES_WP[word + part] = total files for this word and part
    # FILES_WP[word + part + index] = files
    # NB_FILES_W[word] = total files for this word
    # FILES_W[word + index] = files
    # NB_PARTS_WF[word + file] = total parts for this word and part
    # PARTS_WF[word + file + index] = part
    # NB_PARTS_W[word] = total parts for this word
    # PARTS_W[word + index] = part
    # ATTRIBUTES[CONCEPT_ID + index] = file
    # OBJECTS[CONCEPT_ID + index] = word
    # OBJECTS_NAME[CONCEPT_ID + index] = name
END {
    for (id in LIST_CONCEPTS)
    {
	for (i = 1; i <= MAX_PARTS; i++)
	{
	    FRAGMENT_PARTS[i] = 0;
	    VOTED_PARTS[i] = 0;
	    OUT_PARTS[i] = 0;
	}

	for (iter in TMP_NB_FRAGMENT_WP)
	    delete TMP_NB_FRAGMENT_WP[iter];
	for (iter in TMP_FRAGMENT_WP)
	    delete TMP_FRAGMENT_WP[iter];

	CONCEPT_ID = id;
	LEVEL = LEVELS[id];
	NB_OBJECTS = NB_OBJ[id];
	NB_ATTRIBUTES = NB_ATT[id];

    # NB_FILES_WP[word + part] = total files for this word and part
    # FILES_WP[word + part + index] = files
    # NB_FILES_W[word] = total files for this word
    # FILES_W[word + index] = files
    # NB_PARTS_WF[word + file] = total parts for this word and part
    # PARTS_WF[word + file + index] = part
    # NB_PARTS_W[word] = total parts for this word
    # PARTS_W[word + index] = part

    # ATTRIBUTES[CONCEPT_ID + index] = file
    # OBJECTS[CONCEPT_ID + index] = word
    # OBJECTS_NAME[CONCEPT_ID + index] = name

	# Collect all the parts for each word
	# (get the significative parts by crodssing each word with each file)
	#print CONCEPT_ID > "/dev/stderr";
	for (iWord = 1; iWord <= NB_OBJECTS; iWord++)
	{
	    CUR_WORD = OBJECTS[CONCEPT_ID,iWord];

	    # print CONCEPT_ID ";" CUR_WORD > "/dev/stderr";
	    for (iFile = 1; iFile <= NB_ATTRIBUTES; iFile++)
	    {
		CUR_FILE = ATTRIBUTES[CONCEPT_ID,iFile];
		# print CONCEPT_ID ";" CUR_WORD ";" CUR_FILE > "/dev/stderr";

		TMP_NB_PARTS = NB_PARTS_WF[CUR_WORD,CUR_FILE];
		for (iPart = 1; iPart <= TMP_NB_PARTS; iPart++)
		{
		    CUR_PART = PARTS_WF[CUR_WORD,CUR_FILE,iPart];
		    # print CONCEPT_ID ";" CUR_WORD ";" CUR_FILE ";" CUR_PART > "/dev/stderr";
		    TMP_MAX_PARTS = add_in_array_1_index(CUR_PART, TMP_FRAGMENT_WP, CUR_WORD);
		    TMP_NB_FRAGMENT_WP[CUR_WORD] = TMP_MAX_PARTS;
		}
	    }
	}

	# Read the parts of each word, and intersect them
	EMPTY_WORDS = 0;
	NON_EMPTY_WORDS = 0;
	#for (iter = 1; iter <= MAX_PARTS; iter++)
	# FRAGMENT_PARTS[iter] = 0;

	# Read the parts of each word
	for (iWord = 1; iWord <= NB_OBJECTS; iWord++)
	{
	    CUR_WORD = OBJECTS[CONCEPT_ID,iWord];
	    #print CONCEPT_ID ";" CUR_WORD > "/dev/stderr";

	    for (iter = 1; iter <= MAX_PARTS; iter++)
		TMP_FRAGMENT_PART[CUR_WORD,iter] = 0;

	    # Detect if the current word contain significative parts or not
	    if (length(TMP_NB_FRAGMENT_WP[CUR_WORD]) != 0)
	    {
		TMP_MAX_PARTS = TMP_NB_FRAGMENT_WP[CUR_WORD];
		NON_EMPTY_WORDS += 1;
	    }
	    else
	    {
		TMP_MAX_PARTS = 0;
		EMPTY_WORDS += 1;
	    }

	    #print "MAX PARTS : " TMP_MAX_PARTS > "/dev/stderr";
	    for (iPart = 1; iPart <= TMP_MAX_PARTS; iPart++)
	    {
		CUR_PART = TMP_FRAGMENT_WP[CUR_WORD,iPart];
		CUR_PART += 1; # PARTS SHOULD NEVER BE 0
		#print CONCEPT_ID ";" CUR_WORD ";" CUR_PART > "/dev/stderr";

		TMP_FRAGMENT_PART[CUR_WORD,CUR_PART] = 1;
	    }

	    #print "" > "/dev/stderr";
	    # Count the parts between each word
	    for (iter = 1; iter <= MAX_PARTS; iter++)
	    {
		QTY_PART =  TMP_FRAGMENT_PART[CUR_WORD,iter];
		#print CONCEPT_ID ";" CUR_WORD ";" iter " (" QTY_PART ")" > "/dev/stderr";
		FRAGMENT_PARTS[iter] += QTY_PART;
	    }
	}

	#print "Result for CONCEPT_ID " CONCEPT_ID > "/dev/stderr";

	# Intersect the parts :
	# If the part appears less than the number of non-empty words, then we keep it
	# "non-empty words" : words whose quantity of significative parts is zero
	for (iter = 1; iter <= MAX_PARTS; iter++)
	{
	    QTY_PART = FRAGMENT_PARTS[iter];
	    if ((QTY_PART > 0) && (QTY_PART >= NON_EMPTY_WORDS))
		VOTE = 1
	    else
		VOTE = 0;
	    VOTED_PARTS[iter] = VOTE;
	    #print CONCEPT_ID ";" iter " (" QTY_PART " - " VOTE ")" > "/dev/stderr";
	}


	# Let's write in OUT_PARTS each of the parts retained
	# INTERSECTION : keeps only the common parts between each word
	for (i = 1; i <= MAX_PARTS; i++)
	{
	    OUT_PARTS[i] = VOTED_PARTS[i];
	}

	# Count the number of parts
	OUT_NB_PARTS = 0;
	for (i = 1; i <= MAX_PARTS; i++)
	    if (OUT_PARTS[i] > 0)
		OUT_NB_PARTS++;

	# Print out the numbr of parts and each part
	printf("%s%s%s", CONCEPT_ID, OFS, OUT_NB_PARTS);
	if (OUT_NB_PARTS > 0)
	{
	    for (i = 1; i <= MAX_PARTS; i++)
	    {
		# Because of awk array not managing "0", we make -1
		PART = OUT_PARTS[i];
		if (PART > 0)
		    printf("%s%s", OFS, (i - 1));
	    }
	}
	printf("\n");
    }

}
