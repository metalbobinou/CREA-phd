#! /bin/awk

# Add the second file (new clusters) into the first file (reference clusters).
# "new clusters" file : contains clusters of terms to add into the second file.
# "reference clusters" file : an equivalent of a database of clusters of terms.
# If first line of "new clusters" file shouldn't be taken into account, explain it by
# putting "1' in the variable "AVOID_FIRST_LINE" (it could be a cluster with noise).
# The ID of clusters in the "new clusters" file are ignored.

# FIRST FILE : REFERENCE CLUSTERS FILE (DB)
# SECOND FILE : NEW CLUSTERS FILE

# Variables :
# OFS = ";"
# "AVOID_FIRST_LINE" = "1" [1 = avoid the first line of "new clusters" file]
# "FORCE_COUNT" = integer [the given integer is forced on every cluster]

# Input file (Reference) :
# ID_Cluster ; Qty Occurrences Cluster ; Word1 ; Word2 ; ...

# Input file (NEW CLUSTERS FILE) :
# ID_Cluster ; Word1 ; Word2 ; ...

# Output file :
# ID_Cluster ; Qty Occurrences Cluster ; Word1 ; Word2 ; ...


function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

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

# Type checking
function o_class(obj,   q, x, z)
{
    q = CONVFMT;
    CONVFMT = "% g";
    split(" " obj "\1" obj, x, "\1");
    x[1] = obj == x[1];
    x[2] = obj == x[2];
    x[3] = obj == 0;
    x[4] = obj "" == +obj;
    CONVFMT = q;
    z["0001"] = z["1101"] = z["1111"] = "number";
    z["0100"] = z["0101"] = z["0111"] = "string";
    z["1100"] = z["1110"] = "strnum";
    z["0110"] = "undefined";
    return (z[x[1] x[2] x[3] x[4]]);
}


# Global variables
BEGIN {
    NB_CLUSTERS = 0
    NEW_CLUSTERS_FILE_LINE = 1;

    # Option for forcing some clusters to appear in a precise number
    if ((length(FORCE_COUNT) != 0) &&
	((o_class(FORCE_COUNT) == "strnum") || (o_class(FORCE_COUNT) == "number")))
	IS_FORCED_COUNT = 1;
    else
	IS_FORCED_COUNT = 0;
}


# Reference Clusters file (DB) : let's put them in memory
NR == FNR {
    if (NF < 2)
	next ;

    NB_CLUSTERS += 1;
    NB_TERMS = NF - 2; ##### DEPEND ON NUMBER OF NON-TERMS COLUMNS (ID + QTY) (see for)
    NB_QTY = trim($2); # Qty of times this cluster was counted in other files/before
    add_in_array_0_index(NB_TERMS, TAB_NB_TERMS); # Nb of Terms in the current cluster
    add_in_array_0_index(NB_QTY, TAB_QTY_CLUSTER); # Qty of times this clusters was counted
    for (i = 3; i <= NF; i++)
    {
	TERM = trim($i);
	add_in_array_1_index(TERM, TAB_TERMS, NB_CLUSTERS);
    }
    next ;
}

# New Clusters files : let's add a cluster "if" it's not already inside the DB
NR != FNR {
    # If we should avoid the 1st line, let's skip it
    if (((AVOID_FIRST_LINE == 1) && (NEW_CLUSTERS_FILE_LINE == 1)) ||
	(NF < 2))
    {
	NEW_CLUSTERS_FILE_LINE += 1;
	next ;
    }

    #print "##### DEBUG : [NBCLUSTER " NB_CLUSTERS "] " $0 > "/dev/stderr";

    # If cluster is new, we add it to memory (avoid risk of similar cluster in same file)
    # "Is New" == "1" ; "Is Not New" == "0"
    IS_NEW = 1;
    ID_SAME_OLD_CLUSTER = -1; # ID of the old cluster with the same terms

    CUR_NB_TERMS = NF - 1;
    # For current line, let's iterate over each cluster in memory and compare it
    for (i = 1; i <= NB_CLUSTERS; i++)
    {
        ID = i;

        MAX_TERMS = TAB_NB_TERMS[ID];
	#print "DEBUG [old cluster] : Nb Terms " MAX_TERMS > "/dev/stderr";

	# 1st rule : is there the same number of terms ? If not : let's skip
	if (CUR_NB_TERMS == MAX_TERMS)
	{
	    # 2nd rule : if at least 1 word is different, we quit the current cluster
	    for (j = 2; j <= NF; j++)
	    {
		# Test each term : if current term is found, we pass to the next one
		# "Term Is Different" == "1" ; "Term Is Same" == "0"
		SAME_LOCAL_TERM = 1;
		CUR_TERM = trim($j);
		#print "DEBUG : [new term] " CUR_TERM > "/dev/stderr";
		for (k = 1; k <= MAX_TERMS; k++)
		{
		    REF_TERM = TAB_TERMS[ID,k];
		    #print "DEBUG : " REF_TERM > "/dev/stderr";

		    # If term is found: change value & go to next word of new cluster
		    if (CUR_TERM == REF_TERM)
		    {
			#print "term found, next new term" > "/dev/stderr";
			SAME_LOCAL_TERM = 0;
			break ;
		    }
		}

		# If at least 1 term is different, we quit the current cluster
		# (detection : the full list of words have been read, and not a single one
		#  was similar/put SAME_LOCAL_TERMS at 0... the variable stayed at 1)
		if (SAME_LOCAL_TERM == 1)
		{
		    #print "DEBUG : 1 term is different, next old cluster" > "/dev/stderr";
		    break ;
		}
	    }
	    # If every word of the new cluster is the same as in the old cluster, we skip
	    # the current cluster
	    # + we keep in ID_SAME_OLD_CLUSTER the ID of the old cluster
	    # (detection : the terms loop naturaly ended && SAME_LOCAL_TERMS was put at 0)
	    if (SAME_LOCAL_TERM == 0)
	    {
		#print "DEBUG : every term is the same, next new cluster" > "/dev/stderr";
		IS_NEW = 0;
		ID_SAME_OLD_CLUSTER = ID;
		#break ; # for () if () if (* we are here)
	    }
	}
	# If one cluster is already the same, we skip the other
	# + we update the number of time this cluster appeared
	if (IS_NEW == 0)
	{
	    #print "DEBUG : break of old cluster/next new cluster/cur new cluster to memory" > "/dev/stderr";
	    if (IS_FORCED_COUNT == 0)
		TAB_QTY_CLUSTER[ID_SAME_OLD_CLUSTER] += 1;
	    else
		TAB_QTY_CLUSTER[ID_SAME_OLD_CLUSTER] = FORCE_COUNT;
	    break ;
	}
    }

    # If the cluster is new, we add it in memory !
    # (detection : the cluster loop naturaly ended && IS_NEW stayed at 1)
    if (IS_NEW == 1)
    {
	#print "DEBUG : cur new cluster to memory" > "/dev/stderr";
	NB_CLUSTERS += 1;
	NB_TERMS = NF - 1;
	if (IS_FORCED_COUNT == 0)
	    NB_QTY = 1; # This cluster appears 1 time for now
	else
	    NB_QTY = FORCE_COUNT;
	add_in_array_0_index(NB_TERMS, TAB_NB_TERMS);
	add_in_array_0_index(NB_QTY, TAB_QTY_CLUSTER);
	for (i = 2; i<= NF; i++)
	{
	    TERM = trim($i);
	    add_in_array_1_index(TERM, TAB_TERMS, NB_CLUSTERS);
	}
    }

    NEW_CLUSTERS_FILE_LINE += 1;

    next ;
}

# Let's write back all the results
END {
    # NB_CLUSTERS : number of clusters (& ID of each cluster from 1 to max ;) )
    # TAB_QTY_CLUSTER : number of times the cluster was counted in other files/before
    # TAB_NB_TERMS[Cluster_ID] : number of terms in each cluster
    # TAB_TERMS[Cluser_ID, n] : terms in each cluster (1 to n)

    for (i = 1; i <= NB_CLUSTERS; i++)
    {
	ID = i;
	printf("%s", ID);

	# Print the quantity of times the cluster appeared in total
	if (length(TAB_QTY_CLUSTER[ID]) != 0)
	    QTY_CLUSTERS = TAB_QTY_CLUSTER[ID];
	else
	    QTY_CLUSTERS = 1;
	printf("%s%s", OFS, QTY_CLUSTERS);

	# Print each term from each cluster
	MAX_TERMS = TAB_NB_TERMS[ID];
	for (j = 1; j <= MAX_TERMS; j++)
	{
	    TERM = TAB_TERMS[ID,j];
	    printf("%s%s", OFS, TERM);
	}

	printf("\n");
    }
}
