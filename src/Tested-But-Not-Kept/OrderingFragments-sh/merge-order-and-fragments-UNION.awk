#! /bin/awk

# Calculate the order of the fragments :
# - Find all the possible parts of each word within each file
# - Gather multiple useful values (word = parts, word + file = parts, word + part = files)
# - For each concept/fragment :
#  - find all the parts of each word
#  - find all the parts of each word within each file
# - Print all the parts of each word within each file
# When reading the parts, this script creates the UNION of the parts per word :
#  all the possible parts are added

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
function smartmatch(diamond, rough,   x, y)
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
	iter = 1;
	for (iPart in PARTS)
	{
	    VAL = PARTS[iPart];
	    # PARTS_W[word + index] = part
	    PARTS_W[LAST_BN_ID,iter] = VAL;
	    iter++;
	}
	# NB_PARTS_W[word] = total parts
	NB_PARTS_W[LAST_BN_ID] = iter; # PART_ITER

	iter = 1;
	for (iFile in FILES)
	{
	    VAL = FILES[iFile];
	    # FILES_W[word + index] = file
	    FILES_W[LAST_BN_ID,iter] = VAL;
	    iter++;
	}
	# NB_FILES_W[word] = total files
	NB_FILES_W[LAST_BN_ID] = iter;

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
	FILES_WP[BN_ID,CUR_PART,iter] = CUR_FILE;
	if (! is_in_array(CUR_FILE,FILES))
	{
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
	    CUR_POS_P_WF = NB_PARTS_WF[BN_ID,CUR_FILE] + 1;
	    NB_PARTS_WF[BN_ID,CUR_FILE] += 1;
	    # PARTS[word + file + index] = part
	    PARTS_WF[BN_ID,CUR_FILE,CUR_POS_P_WF] = CUR_PART;
	}
    }

    if (! is_in_array(CUR_PART,PARTS))
    {
	PARTS[PART_ITER] = CUR_PART;
	PART_ITER++;
    }

    next;
}

# Now, on the Fragments, let's apply the order
{
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
	    OBJECTS[CONCEPT_ID,iter] = BN_ID_TMP;
	    OBJECTS_NAME[CONCEPT_ID,iter] = CUR_WORD;
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
	    ATTRIBUTES[CONCEPT_ID,iter] = CUR_FILE;
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
	for (i = 1; i < MAX_PARTS; i++)
	    VOTED_PARTS[i] = 0;

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

        for (i = 1; i <= MAX_PARTS + 1; i++)
	{
	    OUT_PARTS_W[i] = 0;
	    OUT_PARTS_WF[i] = 0;
	    OUT_PARTS[i] = 0;
	}

	# UNUSED
	# For each BN_ID of current Concept/Fragment,
	#  gets each possible part, and put them in OUT_PARTS_W[PART]
	# UNION : Each BN_ID adds its PARTS for the Concept
        for (iWord = 1; iWord <= NB_OBJECTS; iWord++)
	{
	    CUR_BN = OBJECTS[CONCEPT_ID,iWord];
	    CUR_BN_NAME = OBJECTS_NAME[CONCEPT_ID,iWord];
	    for (iter = 1; iter < NB_PARTS_W[CUR_BN]; iter++)
	    {
		# PART + 1 because "0" is not managed in the array cell number
		pos = PARTS_W[CUR_BN,iter] + 1;
		OUT_PARTS_W[pos] += 1;
	    }
	}

	# For each BN_ID of current Concept/Fragment,
	#   get each file of the current Concept/Fragment,
	#     get each part for this Word and File, and write them in OUT_PARTS
	# UNION : Each BN_ID adds its PARTS for the Concept
	for (iWord = 1; iWord <= NB_OBJECTS; iWord++)
	{
	    CUR_BN = OBJECTS[CONCEPT_ID,iWord];
	    CUR_BN_NAME = OBJECTS_NAME[CONCEPT_ID,iWord];
	    for (iFile = 1; iFile <= NB_ATTRIBUTES; iFile++)
	    {
		CUR_FILE = ATTRIBUTES[CONCEPT_ID,iFile];
		for (iter = 1; iter <= NB_PARTS_WF[CUR_BN,CUR_FILE]; iter++)
		{
		    # PART + 1 because "0" is not managed in the array cell number
		    if (length(PARTS_WF[CUR_BN,CUR_FILE,iter]) != 0)
		    {
			pos = PARTS_WF[CUR_BN,CUR_FILE,iter] + 1;
			OUT_PARTS_WF[pos] += 1;
		    }
		}
	    }
	}

#	for (i = 1; i <= MAX_PARTS; i++)
#	    print "OUT_PARTS_W[" i "] = " OUT_PARTS_W[i] > "/dev/stderr";
#	for (i = 1; i <= MAX_PARTS; i++)
#	    print "OUT_PARTS_WF[" i "] = " OUT_PARTS_WF[i] > "/dev/stderr";


	# Let's write in OUT_PARTS each of the parts retained
	# UNION : we write "all" the possible parts
	for (i = 1; i <= MAX_PARTS; i++)
	{
#	    print "CONCEPT : " CONCEPT_ID " OUT_PART : " OUT_PARTS_WF[i];
	    OUT_PARTS[i] = OUT_PARTS_WF[i];
	}

#	for (i = 1; i <= MAX_PARTS; i++)
#	    print "OUT_PARTS[" i "] = " OUT_PARTS[i] > "/dev/stderr";


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
		# Because of awk array not managing "0", we reduce the number
		PART = OUT_PARTS[i];
		if (PART > 0)
		    printf("%s%s", OFS, (i - 1));
	    }
	}
	printf("\n");
    }

}
