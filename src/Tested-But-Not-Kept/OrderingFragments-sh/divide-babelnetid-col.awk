#! /bin/awk

# Clean the Fragments Files in order to add a sub-field containing the bn:ID
# The bn:ID alone is useful for joining multiple files
# Only the "Objects" lines are modified

# Variables :
# OFS=";"
# SUB_OFS=","

# Input file : (1 line Object, 1 line Attribute)
# Concept ID ; Level ; Type Obj/Attr ; Nb O ; Nb A ; Obj1/Attr1 [; O/A2 ; ... ]

# Output File : (1 line Object, 1 line Attribute)
# Concept ID ; Level ; Type Obj/Attr ; Nb O ; Nb A ; Obj1/Attr1 [; O/A2 ; ... ]


{
    # If column do "not" contains "Name bn:ID", let's copy it as is
    if (toupper($3) != "OBJECTS")
    {
	print $0;
    }
    else
    {
	# Print the first fixed columns
	printf("%s%s%s%s%s%s%s%s%s", $1, OFS, $2, OFS, $3, OFS, $4, OFS, $5);

        # Get number of objects concerned
	NB_OBJ = $4;

	# Read and process each object (from field 6)
	for (i = 1; i <= NB_OBJ; i++)
	{
	    # We read words from field 6 until the end
	    CUR_WORD = $(i + 5);
	    CUR_WORD = "\"" CUR_WORD "\"";

	    ## bn:ID has a specific length ????

	    # match :    /:[^:]*$/
	    # [^:]*  (a [^...] is a negated bracket expression) will match 0+
	    #  characters other than :, so, only the last : is matched with
	    #  the first :.
	    # Pattern details :
	    # :      - a : followed with...
	    # [^:]*  - any 0+ chars other than :
	    # $      - end of string.
	    BN_ID_POS = match(CUR_WORD, / [^ ]*$/);

	    # match puts variables RSTART and RLENGTH to indicate
	    #  the matched pattern
	    BN_ID_BRUT = substr(CUR_WORD, RSTART, RLENGTH);

	    # Substr gets : ' bn:XXXXX"' let's remove first and last chars
	    BN_ID = substr(BN_ID_BRUT, 2, (length(BN_ID_BRUT) - 2))

	    #WORDS[i] = CUR_WORD;
	    #BN[i] = BN_ID;

	    # Print each subfield
	    printf("%s%s %s %s", OFS, CUR_WORD, SUB_OFS, BN_ID);
	}
	printf("\n");
    }
}
