#! /bin/awk

# List the selected terms from a file and their cluster
# Put unknown terms into a different cluster each time

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# !!!! MAXIMAL VALUE IS HARDCODED !!!!
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# Variables :
# OFS = ";"

# Input file 1 (data file) :
# Term ; [Cluster ID]
# php;1
# python;1
# url;2
# text;2
# ...

# Input file 2 (Reference File) :
# Term1
# Term2
# Term3
# ...

# Output file :
#     Term1    ;    Term2     ; ...
# [Cluster ID] ; [Cluster ID] ; ...


function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

BEGIN {
	# Define the error case of Clusters
    MAX_INT = 424242424242;
	UNKNOWN_CLUSTER_VALUE = MAX_INT;

	TERMS_COUNT = 0;
	OUT_HEADER = "";
	OUT_TAB_COUNT = 0;
}


# Data file
NR == FNR {
	TERM = trim($1);
	CLUSTER_ID = trim($2);

	# Add each term with its cluster ID in an array
	TERMS_COUNT += 1;
	DATA_TERMS_WORD[TERMS_COUNT] = TERM;
	DATA_TERMS_CLUSTER[TERMS_COUNT] = CLUSTER_ID;

    next ;
}

# Reference file
NR != FNR {
	REF_WORD = trim($1);

	found = 0;
	# Check in the data file if it's found
	for (i = 1; i <= TERMS_COUNT; i++)
	{
		DATA_WORD = DATA_TERMS_WORD[i];
		DATA_CLUSTER = DATA_TERMS_CLUSTER[i];

		# If the current word is found in the ref, let's add it
		if (REF_WORD == DATA_WORD)
		{
			found = 1;
			OUT_TAB_COUNT += 1;
			OUT_TAB_TERM[OUT_TAB_COUNT] = DATA_WORD;
			OUT_TAB_CLUSTER[OUT_TAB_COUNT] = DATA_CLUSTER;
			break;
		}
	}

	# Write an error if the current word was not found + Put default cluster
	if (found == 0)
	{
		ERR = "Word " REF_WORD " was not found in the reference";
		print ERR > "/dev/stderr";

		OUT_TAB_COUNT += 1;
		OUT_TAB_TERM[OUT_TAB_COUNT] = REF_WORD;
		OUT_TAB_CLUSTER[OUT_TAB_COUNT] = UNKNOWN_CLUSTER_VALUE;
		UNKNOWN_CLUSTER_VALUE -= 1;
	}
}


END {

	# Prepare Header first (list of terms)
	for (i = 1; i <= OUT_TAB_COUNT; i++)
	{
		if (i == 1)
			OUT_HEADER = OUT_TAB_TERM[1];
		else
			OUT_HEADER = OUT_HEADER OFS OUT_TAB_TERM[i];
	}


	# Prepare Partitions (list of clusters)
	for (i = 1; i <= OUT_TAB_COUNT; i++)
	{
		if (i == 1)
			OUT_CLUSTERS = OUT_TAB_CLUSTER[1];
		else
			OUT_CLUSTERS = OUT_CLUSTERS OFS OUT_TAB_CLUSTER[i];
	}

	# Print header
	printf("%s\n", OUT_HEADER);

	# Print partitions
	printf("%s\n", OUT_CLUSTERS);
}
