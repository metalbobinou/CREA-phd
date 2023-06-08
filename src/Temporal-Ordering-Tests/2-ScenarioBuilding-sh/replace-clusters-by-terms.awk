#! /bin/awk

### TODO ###
### NOT IMPLEMENTED #####

# - Read the clusters, put them in memory (terms, priority, ...)
# - Change each cluster by its terms and priority (add priority in the term ?)
#

# Variables :
# OFS=";"
# SUB_OFS=","
# MAX_PARTS=${MAX_PARTS}  # Number max of Parts used while cutting documents
# HEADER=${HEADER}  # Header ? (1 = yes, 0 = no)


# Input file 1 : (1 line Object, 1 line Attribute, 1 line Parts)
# Cluster ID ; Priority ; Nb P ; Part(s) ; Term1/Part1 [; T2/P2 ; ... ]

# Input file 2 :
# Part ; Nb Clusters ; ID Cluster 1 ; ID Cluster 2 ; ..

# Output File :
# Part ; Nb Clusters ; Term 1 ; Term 2 ; ...


BEGIN {
    SKIP_HEADER = 0;
    if ((length(HEADER) != 0) && (HEADER == 1))
	SKIP_HEADER = 1;
}

# Cluster ID ; Priority ; Nb P ; Part(s) ; Term1/Part1 [; T2/P2 ; ... ]
(NR == FNR) {
    # Put in memory : 1st line = priority & terms, 2nd line = part

}

# Part ; Nb Clusters ; ID Cluster 1 ; ID Cluster 2 ; ..
(NR != FNR) {
    # Search in memory for each term (and add its priority ?)

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
