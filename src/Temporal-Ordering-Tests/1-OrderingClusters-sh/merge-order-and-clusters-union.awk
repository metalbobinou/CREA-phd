#! /bin/awk

# Add the parts of each term (described by its bn:ID) :
# - Put in memory each cluster and the bn:ID contained
# - Browse each bn:ID and the parts where it can be : put in memory the matchs
# - Write at the end the clusters and its parts
#
# Union strategy : each part is kept


# Variables :
# OFS=";"
# SUB_OFS=","


# Input file 1 (Clusters file) :
# Cluster ID ; Significance ; bn:ID 1 ; bn:ID 2 ; ...

# Input file 2 (Ordering file) :
# "\"Name bn:ID\" ; bn:ID ; Part ; File1 [; File2 ; ... ]

# Output File :
# Cluster ID ; Significance ; Nb Parts ; Parts ; bn:ID 1 ; bn:ID 2 ; ...
# 0 ; 10 ; 2 ; 14 , 18 ; bn:xxxxxxn ; bn:yyyyyyn


# Search for a value in an array (thanks StackOverflow)
# USAGE : split("444 555 666", z); smartmatch(555, z);
# WARNING : CANNOT SEARCH FOR 0 !
function smartmatch(diamond, rough, x, y)
{
    for (x in rough) y[rough[x]]
    return diamond in y
}

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

# Add one element at the end of the array, with 2 indexes given in parameter (begin at 1)
function add_in_array_2_index(value, array, index_1, index_2,   iter)
{
    iter = 1; # Never begin at 0
    while (length(array[index_1,index_2,iter]) != 0)
        iter += 1;
    array[index_1,index_2,iter] = value;
    return (iter);
}

function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }


# Let's memorize the clusters file
# Cluster ID ; Significance ; bn:ID 1 ; bn:ID 2 ; ...
FNR == NR {
    CLUSTER_ID = trim($1);
    CLUSTER_ID += 1; # Never use "0"
    QTY = trim($2);

    # Nb of BN:ID in the cluster
    NB_BN[CLUSTER_ID] = NF - 2;
    # Significance of cluster saved
    SIGNIFICANCE[CLUSTER_ID] = QTY;
    # Save the ID of the cluster
    add_in_array_0_index(CLUSTER_ID, CLUSTERS);

    # Nb parts for this cluster
    NB_PARTS[CLUSTER_ID] = 0;

    # Extract each BN:ID
    for (i = 3; i <= NF; i++)
    {
	BN_ID = trim($i);
	add_in_array_1_index(BN_ID, CLUSTER_CONTENT, CLUSTER_ID);
    }

    next; # DO NOT EXECUTE NEXT PROCEDURE UNTIL FILE IS IN MEMORY
}

# Now, on the ordering file, search if a BN:ID exists and add the order in an array
# "\"Name bn:ID\" ; bn:ID ; Part ; File1 [; File2 ; ... ]
{
    ORDER_BN_ID = trim($2);
    ORDER_PART = trim($3);

    # If current bn:ID is not found, let's skip it
    if (is_in_array(ORDER_BN_ID, CLUSTER_CONTENT) == 0)
	next;

    # bn:ID is found in at least one cluster

    # For each cluster that contains the bn:ID, add the current part to a dedicated array
    for (iter in CLUSTERS)
    {
	CLUSTER_ID = CLUSTERS[iter];
	# Iterate on each bn:ID of the current cluster
	MAX_BN = NB_BN[CLUSTER_ID];
	for (iter_BN = 1; iter_BN <= MAX_BN; iter_BN++)
	{
	    # If one of the bn:ID is the same as the one in the ordering, let's get its part
	    CUR_CLUSTER_BN = CLUSTER_CONTENT[CLUSTER_ID, iter_BN];
	    if (CUR_CLUSTER_BN == ORDER_BN_ID)
	    {
		add_in_array_1_index(ORDER_PART, CLUSTER_PARTS, CLUSTER_ID);
		NB_PARTS[CLUSTER_ID] += 1;
	    }
	}
    }
}

# Finally, rewrite the clusters in a file and add the parts
# Cluster ID ; Significance ; Parts ; bn:ID 1 ; bn:ID 2 ; ...
END {
    for (iter in CLUSTERS)
    {
	CLUSTER_ID = CLUSTERS[iter];
	QTY = SIGNIFICANCE[CLUSTER_ID];
	# Cluster ID - 1 to avoid 0 in array
	printf("%s%s%s%s", (CLUSTER_ID - 1), OFS, QTY, OFS);

	# For each line/cluster : print first the number of parts, then the parts
	MAX_PARTS = NB_PARTS[CLUSTER_ID];
	PARTS = "";
	for (iter_PARTS = 1; iter_PARTS <= MAX_PARTS; iter_PARTS++)
	{
	    CUR_CLUSTER_PART = CLUSTER_PARTS[CLUSTER_ID, iter_PARTS];
	    if (iter_PARTS == 1)
		PARTS = CUR_CLUSTER_PART;
	    else
		PARTS = PARTS SUB_OFS CUR_CLUSTER_PART;
	}
	printf("%s%s%s", MAX_PARTS, OFS, PARTS);

	# For each line/cluster : rewrite the bn:ID included
	MAX_BN = NB_BN[CLUSTER_ID];
	for (iter_BN = 1; iter_BN <= MAX_BN; iter_BN++)
	{
	    CUR_CLUSTER_BN = CLUSTER_CONTENT[CLUSTER_ID, iter_BN];
	    printf("%s%s", OFS, CUR_CLUSTER_BN);
	}
	printf("%s", "\n");
    }
}
