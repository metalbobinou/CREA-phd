#! /bin/awk

# Change the point of view

# Variables :
# OFS=";"
# SUB_OFS=","
# MAX_PARTS=${MAX_PARTS}  # Number max of Parts used while cutting documents
# HEADER=${HEADER}  # Header ? (1 = yes, 0 = no)


# Input file :
# Cluster ID ; Priority ; Nb P ; Part(s) ; Term1 [; Term2 ; ... ]

# Output File :
# Part ; Nb Clusters ; ID Cluster 1 ; ID Cluster 2 ; ...


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




BEGIN {
    SKIP_HEADER = 0;
    if ((length(HEADER) != 0) && (HEADER == 1))
	SKIP_HEADER = 1;
    TOTAL_PARTS = MAX_PARTS;
    TOTAL_CLUSTERS = 1;
}

{
    if ((NR == 1) && (SKIP_HEADER == 1))
        next ;

    # Input file :
    # Cluster ID ; Priority ; Nb P ; Part(s) ; Term1 [; Term2 ; ... ]

    CLUSTER_ID = $1;
    PRIORITY = $2;
    NB_PARTS = $3;

    CLUSTER_ID += 1; # Avoid "0" for awk array

    if (NB_PARTS == 0)
    {
	CLUSTERS_ARRAY[TOTAL_CLUSTERS] = CLUSTER_ID;
	TOTAL_CLUSTERS += 1;
    }
}

# Output File :
# Part ; Nb Clusters ; ID Cluster 1 ; ID Cluster 2 ; ...

END {
    for (i = 1; i <= TOTAL_PARTS; i++)
    {
	OUT_PART = i - 1; # Avoid "0" for awk array

	NB_CLUSTERS = 0;
	for (j = 1; j < TOTAL_CLUSTERS; j++)
	{
	    CUR_CLUSTER = CLUSTERS_ARRAY[j];
	    OUT_CLUSTER = CUR_CLUSTER - 1; # Avoid "0" for awk

	    if (NB_CLUSTERS == 0)
		STR_CLUSTERS = OUT_CLUSTER;
	    else
		STR_CLUSTERS = STR_CLUSTERS OFS OUT_CLUSTER;
	    NB_CLUSTERS += 1;
	}
	printf("%s%s%s%s%s\n", OUT_PART, OFS, NB_CLUSTERS, OFS, STR_CLUSTERS);
    }
}
