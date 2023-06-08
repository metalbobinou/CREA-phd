#! /bin/awk

# Select candidates clusters for each part :
# - Each line with the bn:ID and parts are kept
# - Lines with only part numbers (not odd lines) are deleted
# - A parameter indicates if there is an header or not

# Variables :
# OFS=";"
# SUB_OFS=","
# MAX_PARTS=${MAX_PARTS}  # Number max of Parts used while cutting documents
# HEADER=${HEADER}  # Header ? (1 = yes, 0 = no)


# Input file : (1 line Object, 1 line Attribute, 1 line Parts)
# Cluster ID ; Priority ; Nb P ; Part(s) ; Term1/Part1 [; T2/P2 ; ... ]

# Output File :
# Cluster ID ; Priority ; Nb P ; Part(s) ; Term1 [; Term2 ; ... ]

BEGIN {
    SKIP_HEADER = 0;
    if ((length(HEADER) != 0) && (HEADER == 1))
	SKIP_HEADER = 1;
}

{
    if ((NR == 1) && (SKIP_HEADER == 1))
        next ;

    # Input file : (1 line Object, 1 line Attribute, 1 line Parts)
    # Cluster ID ; Priority ; Nb P ; Part(s) ; Term1/Part1 [; T2/P2 ; ... ]

    if (SKIP_HEADER == 1)
	LINE = NR - 1;
    else
	LINE = NR;


    CONCEPT_ID = $1;
    PRIORITY = $2;
    NB_PARTS = $3;

    if ((LINE % 2) == 0)
	TYPE = "PARTS";
    else
	TYPE = "TERMS";

    if (toupper(TYPE) == "TERMS")
    {
	if (NB_PARTS > 0)
	{
	    print $0;
	}
    }
}

# Output File :
# Cluster ID ; Priority ; Nb P ; Part(s) ; Term1 [; Term2 ; ... ]
