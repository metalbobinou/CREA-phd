#! /bin/awk

# - Read the clusters, put them in memory (terms, priority, ...)
# - Change each cluster by its terms and priority (add priority in the term ?)
# Works in a column file for clusters to change

# Variables :
# OFS=";"
# SUB_OFS=","
# MAX_PARTS=${MAX_PARTS}  # Number max of Parts used while cutting documents
# HEADER=${HEADER}  # Header in clusters references ? (1 = yes, 0 = no)


# Input file 1 : (1 line Object, 1 line Attribute, 1 line Parts)
# Cluster ID ; Priority ; Nb P ; Part(s) ; Term1/Part1 [; T2/P2 ; ... ]

# Input file 2 : (vertical !)
# Part ; Nb Clusters ; ID Cluster 1 ; ID Cluster 2 ; ..

# Output File :
# Part ; Nb Clusters ; Term 1 ; Term 2 ; ...


# Trim a string by the left, right, and both
function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

# Find if a value is already stored in an array (only calls with 2 parameters)
# Return 1 if found, 0 if not found
function is_in_array(value, array,   iter)
{
    for (iter in array)
    {
        if (value == array[iter])
            return 1;
    }
    return 0;
}

## Add value at the end of an array, and return the position at insertion
# (indexes of arrays in awk are tricky : they are just concatenated with SUBSEP
#  therefore : tab[ab,cd] is the same as tab[ab@cd] if SUBSEP is set to '@'.
#  SUBSEP = "\034"  by default (rare and non-printable character).
#  Do not change SUBSEP "after" putting values in a multidimensional array)
# BEWARE OF INDEX AT 0 ! The concatenation remove the trailing "0" in numbers

# Add one element at the end of the array (index begin at 1)
function add_in_array_0_index(value, array,   iter)
{
    iter = 1; # Never begin at 0
    while (length(array[iter]) != 0)
        iter += 1;
    array[iter] = value;
    return (iter);
}

# Add one element at the end of the array, with index given in parameter (begin at 1)
function add_in_array_1_index(value, array, index_1,   iter)
{
    iter = 1; # Never begin at 0
    while (length(array[index_1,iter]) != 0)
        iter += 1;
    array[index_1,iter] = value;
    return (iter);
}




BEGIN {
    SKIP_HEADER = 0;
    if ((length(HEADER) != 0) && (HEADER == 1))
	SKIP_HEADER = 1;
}

# Cluster ID ; Priority ; Nb P ; Part(s) ; Term1/Part1 [; T2/P2 ; ... ]
(NR == FNR) {
    # Put in memory : 1st line = priority & terms, 2nd line = part

    if ((NR == 1) && (SKIP_HEADER == 1))
        next ;

    if (SKIP_HEADER == 1)
	LINE = NR - 1;
    else
	LINE = NR;

    CLUSTER_ID = trim($1);
    PRIORITY = trim($2);
    NB_PARTS = trim($3);
    PARTS = trim($4); # separated by SUB_OFS

    CLUSTER_ID += 1; # Avoid "0" for awk arrays

    #if ((LINE % 2) == 0)
        TYPE = "PARTS";
    #else
	TYPE = "TERMS";

    if (toupper(TYPE) == "TERMS")
    {
	PRIORITY_OF_CLUSTER[CLUSTER_ID] = PRIORITY;
	UNIQUE_PARTS_IN_CLUSTER[CLUSTER_ID] = NB_PARTS;
	for (col = 5; col <= NF; col++)
	{
	    TERM = trim($col);
	    # If 1st reading of the current cluster, let's create the array
	    if (length(NB_TERMS_IN_CLUSTER[CLUSTER_ID]) == 0)
		NB_TERMS_IN_CLUSTER[CLUSTER_ID] = 0;

	    # In any case, let's add the current term
	    add_in_array_1_index(TERM, TERMS_IN_CLUSTER, CLUSTER_ID);
	    NB_TERMS_IN_CLUSTER[CLUSTER_ID] += 1;
	}
    }
    else if (toupper(TYPE) == "PARTS")
    {
	iter = 1;
	for (col = 4; col <= NF; col++)
	{
	    # If there is a part attached to the term, let's keep it
	    if (length($col) != 0)
	    {
		PART = trim($col);
		PARTS_IN_CLUSTER[CLUSTER_ID,iter] = PART;
	    }
	    iter += 1;
	}
    }
}

# Part ; Nb Clusters ; ID Cluster 1 ; ID Cluster 2 ; ..
(NR != FNR) {
    # Search in memory for each term (and add its priority ?)

    ## ARRAYS IN MEMORY : ##
    # PRIORITY_OF_CLUSTER[CLUSTER_ID] = PRIORITY;      # Priority of the cluster
    # UNIQUE_PARTS_IN_CLUSTER[CLUSTER_ID] = NB_PARTS;  # Nb of unique parts
    # NB_TERMS_IN_CLUSTER[CLUSTER_ID];                 # Nb of terms in the cluster
    # TERMS_IN_CLUSTER[CLUSTER_ID,iter] = TERM;        # Terms in the cluster
    # PARTS_IN_CLUSTER[CLUSTER_ID,iter] = PART;        # Optional part

    # Input file 2 : (vertical !)
    # Part ; Nb Clusters ; ID Cluster 1 ; ID Cluster 2 ; ..

    ## Register parts in an array (line 1)
    if (FNR == 1)
    {
	for (i = 1; i <= NF; i++)
	{
	    OUT_PARTS[i] = trim($i);
	}
	print $0
	next ;
    }

    ## Skip Nb Clusters lines (line 2)
    if (FNR == 2)
    {
	print $0;
	next ;
    }


    ## ARRAYS IN MEMORY : ##
    # PRIORITY_OF_CLUSTER[CLUSTER_ID] = PRIORITY;      # Priority of the cluster
    # UNIQUE_PARTS_IN_CLUSTER[CLUSTER_ID] = NB_PARTS;  # Nb of unique parts
    # NB_TERMS_IN_CLUSTER[CLUSTER_ID];                 # Nb of terms in the cluster
    # TERMS_IN_CLUSTER[CLUSTER_ID,iter] = TERM;        # Terms in the cluster
    # PARTS_IN_CLUSTER[CLUSTER_ID,iter] = PART;        # Optional part

    ## Process each line : one cluster per column
    for (i = 1; i <= NF; i++)
    {
	CUR_PART = OUT_PART[i];
	CUR_CLUSTER_ID = trim($i);

	OUT_STR = ""; # Manages empty cell

	if (length(CUR_CLUSTER_ID) != 0)
	{
	    CUR_CLUSTER_ID += 1; # Avoid "0" in awk arrays
	    NB_TERMS = NB_TERMS_IN_CLUSTER[CUR_CLUSTER_ID];
	    for (j = 1; j <= NB_TERMS; j++)
	    {
		CUR_TERM = TERMS_IN_CLUSTER[CUR_CLUSTER_ID,j];

		if (j == 1)
		    OUT_STR = CUR_TERM;
		else
		    OUT_STR = OUT_STR SUB_OFS CUR_TERM;
	    }
	}
	if (i == 1)
	    printf("%s", OUT_STR);
	else
	    printf("%s%s", OFS, OUT_STR);
    }
    printf("\n");
}

# Output File :
# Cluster ID ; Priority ; Nb P ; Part(s) ; Term1 [; Term2 ; ... ]
