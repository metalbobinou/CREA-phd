#! /bin/awk

# Add a line for each concept declaring in which parts it belongs to

# Variables :
# OFS=";"
# SUB_OFS=","
# MAX_PARTS="${MAX_PARTS}"


# INPUT FILE 1 : (FRAGMENTS ORDER)
# Concept ID ; Nb Parts ; Part 1 [; Part 2 ; ... ]

# INPUT FILE 2 : (CLEAN FRAGMENTS)
# Concept ID ; Level ; Type Obj/Attr ; Nb O ; Nb A ; A/O1 ("Name bn:ID", bn:ID) [ ; A/O2 ; ... ]


# OUTPUT FILE :
# Concept ID ; Level ; Type Obj/Attr/Parts ; Nb O ; Nb A ; Nb Parts ; ATT1/OBJ1 ("Name bn:ID", bn:ID)/PART1 [ ; ATT2/OBJ2/PART2 ; ... ]

BEGIN {
    LAST_CONCEPT_ID = "";
}

FNR == NR {
    if (NR == 1)
	next;

    MAX_IN_PARTS = $2;
    IN_NB_PARTS[$1] = MAX_IN_PARTS;

    for (i = 1; i <= MAX_IN_PARTS; i++)
    {
	CUR_FIELD = $(i + 2);
	IN_PARTS[$1,i] = CUR_FIELD;
    }

    next;
}

{
    if ((toupper($3) != "OBJECTS") && (toupper($3) != "ATTRIBUTES"))
    {
	printf("%s%s%s%s%s%s", $1, OFS, $2, OFS, "Type Obj/Att/Part", OFS);
	printf("%s%s%s%s%s%s", $4, OFS, $5, OFS, "Nb Part", OFS);
	printf("%s%s", "Objects/Attributes/Parts", OFS);
	printf("\n");
        next;
    }

    CONCEPT_ID = $1;
    LEVEL = $2;
    TYPE_COL = $3;
    NB_OBJECTS = $4;
    NB_ATTRIBUTES = $5;
    NB_PARTS = IN_NB_PARTS[CONCEPT_ID];

    if ((length(LAST_CONCEPT_ID) != 0) && (CONCEPT_ID != LAST_CONCEPT_ID))
    {
	printf("%s%s%s%s%s%s", LAST_CONCEPT_ID, OFS, LAST_LEVEL, OFS, "Parts", OFS);
	printf("%s%s%s%s%s", LAST_NB_OBJECTS, OFS, LAST_NB_ATTRIBUTES, OFS, LAST_NB_PARTS);
	for (i = 1; i <= LAST_NB_PARTS; i++)
	{
	    printf("%s%s", OFS, IN_PARTS[LAST_CONCEPT_ID,i]);
	}
	printf("\n");

	LAST_LEVEL = LEVEL;
	LAST_NB_OBJECTS = NB_OBJECTS;
	LAST_NB_ATTRIBUTES = NB_ATTRIBUTES;
	LAST_NB_PARTS = NB_PARTS;

	LAST_CONCEPT_ID = CONCEPT_ID;
    }
    else
    {
	# First iteration
	LAST_LEVEL = LEVEL;
	LAST_NB_OBJECTS = NB_OBJECTS;
	LAST_NB_ATTRIBUTES = NB_ATTRIBUTES;
	LAST_NB_PARTS = NB_PARTS;

	LAST_CONCEPT_ID = CONCEPT_ID;
    }

    if ((toupper($3) == "OBJECTS") || (toupper($3) == "ATTRIBUTES"))
    {
	printf("%s%s%s%s%s%s", CONCEPT_ID, OFS, LEVEL, OFS, TYPE_COL, OFS);
	printf("%s%s%s%s%s", NB_OBJECTS, OFS, NB_ATTRIBUTES, OFS, NB_PARTS);
	for (i = 6; i <= NF; i++)
	    printf("%s%s", OFS, $i);
	printf("\n");
    }
}

END {
    printf("%s%s%s%s%s%s", CONCEPT_ID, OFS, LEVEL, OFS, "Parts", OFS);
    printf("%s%s%s%s%s", NB_OBJECTS, OFS, NB_ATTRIBUTES, OFS, NB_PARTS);
    for (i = 1; i <= NB_PARTS; i++)
    {
	printf("%s%s", OFS, IN_PARTS[CONCEPT_ID,i]);
    }
    printf("\n");
}
