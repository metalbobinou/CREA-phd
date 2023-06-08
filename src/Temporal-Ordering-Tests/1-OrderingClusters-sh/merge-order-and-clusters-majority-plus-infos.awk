#! /bin/awk

# Add the parts of each term (described by its bn:ID) :
# - Put in memory each cluster and the bn:ID contained
# - Browse each bn:ID and the parts where it can be : put in memory the matchs
# - Write at the end the clusters and its parts
#
# Majority strategy : keep the parts that are the most voted for
#
# Example for a cluster :
# Term1 appears in parts : 0, 1, 2, 3, 4
# Term2 appears in parts : 0, 1, 2, 5, 6
# Term3 appears in parts :
# Term4 appears in parts : 7
#
# Majority of voters : Nb Terms with parts / 2 = 3/2 = 1,5 (at least 2)
# Out parts for this cluster : 0, 1, 2

# Variables :
# OFS=";"
# SUB_OFS=","


# Input file 1 (Ordering file) :
# "\"Name bn:ID\" ; bn:ID ; Part ; File1 [; File2 ; ... ]

# Input file 2 (Clusters file) :
# Cluster ID ; Significance ; bn:ID 1 ; bn:ID 2 ; ...

# Output File :
# Cluster ID ; Significance ; Nb Parts ; Parts ; bn:ID 1 ; bn:ID 2 ; ...
# Cluster ID ; Significance ; Nb Parts ; Total Parts ; Parts bn:ID 1 ; Parts bn:ID 2 ; ...
# 0 ; 10 ; 2 ; 14 , 18 ; bn:xxxxxxn ; bn:yyyyyyn
# 0 ; 10 ; 2 ; 14 , 18 ; 14 ; 14 , 18


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
{ Cluster ID ; SIGNIFICANCE ;
    iter = 1; # Never begin at 0
    while (length(array[index_1,index_2,iter]) != 0)
        iter += 1;
    array[index_1,index_2,iter] = value;
    return (iter);
}

function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

BEGIN {
	HIGHEST_PART = 0;
}

# Let's memorize the ordering files : terms and part (1 part per line)
# "\"Name bn:ID\" ; bn:ID ; Part ; File1 [; File2 ; ... ]
FNR == NR {
    TERM = trim($1);
    BN_ID = trim($2);
    PART = trim($3);

	if (HIGHEST_PART < (PART + 1))
		HIGHEST_PART = (PART + 1);

    if (length(ORDER_NB_PARTS[BN_ID]) == 0)
    {
	#print "[NEW] BN : " BN_ID " PARTS : " PART > "/dev/stderr";
	# If new term, we create the number of parts and it
	add_in_array_0_index(BN_ID, ORDER_BN);
	ORDER_NB_PARTS[BN_ID] = 1;
	add_in_array_1_index(PART, ORDER_BN_PARTS, BN_ID);
    }
    else
    {
	#print "[OLD] BN : " BN_ID " PARTS : " PART > "/dev/stderr";
	# If term is already known, we add it to the parts
	ORDER_NB_PARTS[BN_ID] += 1;
	add_in_array_1_index(PART, ORDER_BN_PARTS, BN_ID);
    }

    next ;
}

# Let's read the clusters and put them in memory
# Cluster ID ; Significance ; bn:ID 1 ; bn:ID 2 ; ...
FNR != NR {
    CLUSTER_ID = trim($1);
    CLUSTER_ID += 1; # Never use "0"
    QTY = trim($2);

    # Nb of BN:ID in the cluster
    CLUSTER_NB_BN[CLUSTER_ID] = NF - 2;
    # Significance of cluster saved
    SIGNIFICANCE[CLUSTER_ID] = QTY;
    # Save the ID of the cluster
    add_in_array_0_index(CLUSTER_ID, CLUSTERS);

    # Nb parts for this cluster
    CLUSTER_NB_PARTS[CLUSTER_ID] = 0;

    # Extract each BN:ID
    for (i = 3; i <= NF; i++)
    {
	BN_ID = trim($i);
	add_in_array_1_index(BN_ID, CLUSTER_CONTENT, CLUSTER_ID);
    }

    next ;
}

# CLUSTERS[n] : list of clusters
# CLUSTER_NB_BN[C] : number of bn:ID in the cluster C
# CLUSTER_CONTENT[C,n] : list of bn:ID for each cluster (C)
# CLUSTER_NB_PARTS[C] : number of parts in the cluster C (redundancy inside)
# SIGNIFICANCE[C] : significance of the cluster
#
# ORDER_BN[n] : list of bn:ID with a part
# ORDER_NB_PARTS[B] : number of parts for the bn:ID B in ordering file
# ORDER_BN_PARTS[B,n] : list of parts for each bn:ID (B)

# Finally, rewrite the clusters in a file and add the parts
# Cluster ID ; "TERMS" ; Nb Parts ; Parts ; bn:ID 1 ; bn:ID 2 ; ...
# Cluster ID ; "PARTS" ; Nb Parts ; Parts ; Parts bn:ID 1 ; Parts bn:ID 2 ; ...
END {
    for (iter in CLUSTERS)
    {
	CLUSTER_ID = CLUSTERS[iter];
	#print "CLUSTER : " CLUSTER_ID > "/dev/stderr";

	# Build the array of bn:ID and there parts
	delete TMP_PARTS; # Parts of each bn:ID
	delete TMP_MAX_PARTS; # Nb of Parts per bn:ID
	TOTAL_NB_PARTS = 0;
	MAX_BN = CLUSTER_NB_BN[CLUSTER_ID];
	TERMS_WITH_PARTS = 0;
	TERMS_WITHOUT_PARTS = 0;
	# For each bn:ID, find its parts
	for (iter_BN = 1; iter_BN <= MAX_BN; iter_BN++)
	{
	    CUR_BN_ID = CLUSTER_CONTENT[CLUSTER_ID,iter_BN];
	    TMP_MAX_PARTS[CUR_BN_ID] = 0;
	    #print "[ARRAY BUILD] " CUR_BN_ID > "/dev/stderr";
	    # Search parts of the current bn:ID
	    if (length(ORDER_NB_PARTS[CUR_BN_ID]) > 0)
	    {
		TERMS_WITH_PARTS += 1;
		MAX_PARTS = ORDER_NB_PARTS[CUR_BN_ID];
		TOTAL_NB_PARTS += MAX_PARTS;
		#print "-- PARTS : "  MAX_PARTS > "/dev/stderr";
		for (iter_PART = 1; iter_PART <= MAX_PARTS; iter_PART++)
		{
		    # Put the parts in the array
		    CUR_PART = ORDER_BN_PARTS[CUR_BN_ID,iter_PART];
		    add_in_array_1_index(CUR_PART, TMP_PARTS, CUR_BN_ID);
		    TMP_MAX_PARTS[CUR_BN_ID] += 1;
		    #print " -- P : " CUR_PART > "/dev/stderr";
		}
	    }
		else
			TERMS_WITHOUT_PARTS += 1;
	}
	NB_TERMS_IN_CLUSTER = TERMS_WITH_PARTS + TERMS_WITHOUT_PARTS;


	#### CALCULATE THE OUT PARTS
	# Majority strategy

	# Prepare array with each part counter
	delete COUNT_PARTS_OUT; # Counter of each part
	for (iter_PART = 1; iter_PART <= HIGHEST_PART; iter_PART++)
	{
		COUNT_PARTS_OUT[iter_PART] = 0;
	}

	# Count each part from each term
	MAX_BN = CLUSTER_NB_BN[CLUSTER_ID];
	for (iter_BN = 1; iter_BN <= MAX_BN; iter_BN++)
	{
		CUR_BN_ID = CLUSTER_CONTENT[CLUSTER_ID,iter_BN];
		if (length(ORDER_NB_PARTS[CUR_BN_ID]) > 0)
	    {
			MAX_PARTS = ORDER_NB_PARTS[CUR_BN_ID];
			for (iter_PART = 1; iter_PART <= MAX_PARTS; iter_PART++)
			{
				# Put the parts in the array
				CUR_PART = ORDER_BN_PARTS[CUR_BN_ID,iter_PART];
				CUR_PART += 1; # Avoid 0
				COUNT_PARTS_OUT[CUR_PART] += 1;
			}
		}
	}

	## DEBUG : print the number of time each part appears
	#print "CLUSTER_ID : " CLUSTER_ID "  Terms : " NB_TERMS_IN_CLUSTER " (P : " TERMS_WITH_PARTS " NP : " TERMS_WITHOUT_PARTS ")" > "/dev/stderr";
	#for (iter_PART = 1; iter_PART <= HIGHEST_PART; iter_PART++)
	#{
	#	print "count[" (iter_PART - 1) "] " COUNT_PARTS_OUT[iter_PART] > "/dev/stderr";
	#}


	# COUNT_PARTS_OUT[] : array with each number of occurrences of parts
	# HIGHEST_PART : highest part found
	# TERMS_WITH_PARTS : nb of terms with parts
	# TERMS_WITHOUT_PARTS : nb of terms without parts
	# NB_TERMS_IN_CLUSTER : number of terms in the cluster
	# TOTAL_NB_PARTS : grand total of parts in all terms of the cluster

	MAJORITY_PARTS = "";
	NB_MAJORITY_PARTS = 0;
	MAJORITY_MIN = TERMS_WITH_PARTS / 2;
	print "CLUSTER_ID : " CLUSTER_ID "  Terms : " NB_TERMS_IN_CLUSTER " (P : " TERMS_WITH_PARTS " NP : " TERMS_WITHOUT_PARTS ")" > "/dev/stderr";
	for (iter_PART = 1; iter_PART <= HIGHEST_PART; iter_PART++)
	{
		CUR_PART = iter_PART - 1;
		CUR_VOTES = COUNT_PARTS_OUT[iter_PART];
		if (CUR_VOTES > MAJORITY_MIN)
		{
			print "count[" (iter_PART - 1) "] " COUNT_PARTS_OUT[iter_PART] " > " MAJORITY_MIN > "/dev/stderr";
			if (length(MAJORITY_PARTS) == 0)
			MAJORITY_PARTS = CUR_PART;
			else
			MAJORITY_PARTS = MAJORITY_PARTS SUB_OFS CUR_PART;
			NB_MAJORITY_PARTS += 1;
		}
		else
		{
			print "count[" (iter_PART - 1) "] " COUNT_PARTS_OUT[iter_PART] " <= " MAJORITY_MIN > "/dev/stderr";
		}
	}
	PARTS = MAJORITY_PARTS;

	#### PRINT OUTPUT

	## Print 1st line :
	# Cluster ID ; Significance ; "TERMS" ; Nb Parts ; Parts ; bn:ID 1 ; bn:ID 2 ; ...

	QTY = SIGNIFICANCE[CLUSTER_ID];
        # Cluster ID - 1 to avoid 0 in array + print "TERMS"
	OUTPUT_CLUSTER_ID = CLUSTER_ID - 1;
	printf("%s%s%s%s%s%s", OUTPUT_CLUSTER_ID, OFS, QTY, OFS, "TERMS", OFS);


	###############################################################
	# Print by calculating each part (global : copy all the parts of each term)
	#UNION_PARTS = "";
	#MAX_BN = CLUSTER_NB_BN[CLUSTER_ID];
    #    for (iter_BN = 1; iter_BN <= MAX_BN; iter_BN++)
    #    {
    #        CUR_BN_ID = CLUSTER_CONTENT[CLUSTER_ID,iter_BN];
	#    CUR_NB_PARTS = TMP_MAX_PARTS[CUR_BN_ID];
	#    for (iter_PART = 1; iter_PART <= CUR_NB_PARTS; iter_PART++)
	#    {
	#		CUR_PART = TMP_PARTS[CUR_BN_ID,iter_PART];
	#	if (length(UNION_PARTS) == 0)
	#	    UNION_PARTS = CUR_PART;
	#	else
	#	    UNION_PARTS = UNION_PARTS SUB_OFS CUR_PART;
	#    }
	#}
	#PARTS = UNION_PARTS;
	###############################################################


	# TOTAL_NB_PARTS # Global nb of parts (union)
	# NB_MAJORITY_PARTS;  # Majority nb of parts (majority)

	# Print Nb Parts
	#OUT_TOTAL_NB_PARTS = TOTAL_NB_PARTS;  # Global nb of parts (union)
	OUT_TOTAL_NB_PARTS = NB_MAJORITY_PARTS;  # Majority nb of parts (majority)
	printf("%s%s", OUT_TOTAL_NB_PARTS, OFS);

	# Print Parts
	printf("%s%s", PARTS, OFS);


	# Print each bn:ID
	BN_IDS = "";
	MAX_BN = CLUSTER_NB_BN[CLUSTER_ID];
        for (iter_BN = 1; iter_BN <= MAX_BN; iter_BN++)
        {
	    CUR_BN_ID = CLUSTER_CONTENT[CLUSTER_ID,iter_BN];
	    if (length(BN_IDS) == 0)
		BN_IDS = CUR_BN_ID;
	    else
		BN_IDS = BN_IDS OFS CUR_BN_ID;
	}
	printf("%s", BN_IDS);

	printf("\n");

	# 2nd line
	# Cluster ID ; Significance ; "PARTS" ; Nb Parts ; Parts ; Parts bn:ID 1 ; Parts bn:ID 2 ; ...

	# Cluster ID - 1 to avoid 0 in array + print "PARTS"
	printf("%s%s%s%s%s%s", OUTPUT_CLUSTER_ID, OFS, QTY, OFS, "PARTS", OFS);

	# Print Nb Parts
	printf("%s%s", OUT_TOTAL_NB_PARTS, OFS);

	# Print each part (global)
	printf("%s", PARTS);

	# Print each local part (part of each bn:ID)
	MAX_BN = CLUSTER_NB_BN[CLUSTER_ID];
        for (iter_BN = 1; iter_BN <= MAX_BN; iter_BN++)
        {
	    LOCAL_PARTS = "";
	    CUR_BN_ID = CLUSTER_CONTENT[CLUSTER_ID,iter_BN];
	    CUR_NB_PARTS = TMP_MAX_PARTS[CUR_BN_ID];
            for (iter_PART = 1; iter_PART <= CUR_NB_PARTS; iter_PART++)
            {
                CUR_PART = TMP_PARTS[CUR_BN_ID,iter_PART];
		if (length(LOCAL_PARTS) == 0)
		    LOCAL_PARTS = CUR_PART;
		else
		    LOCAL_PARTS = LOCAL_PARTS SUB_OFS CUR_PART;
            }
	    printf("%s%s", OFS, LOCAL_PARTS);
	}

	printf("\n");
    }
}
