#! /bin/awk

# Change every occurrences of a term from the reference file (1st file) into
# the cluster associated to it in the 2nd file

# Variables :
# OFS = ";"

# Input file 1 (Reference File) :
# Term1
# Term2
# Term3
# ...

# Input file 2 (data file) :
# [Cluster ID] ; Term1 ; Term2 ; ...
# 1;text;url; ...
# 2;php;python; ...

# Output file :
#     Term1    ;    Term2     ; ...
# [Cluster ID] ; [Cluster ID] ; ...


function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

BEGIN {
	TERMS_COUNT = 0;
	OUT_HEADER = "";
	CLUSTER_ID = 1;
	OUT_TAB_COUNT = 0;
}

# Reference file
NR == FNR {
    TERM = trim($1);
    TERMS_COUNT += 1;
    TERMS[TERMS_COUNT] = TERM;

    next ;
}

# Data file
NR != FNR {
	CLUSTER_ID = $1;

	# Search within the file given in parameter
	for (i = 2; i <= NF; i++)
    {
		COL = trim($i);
		found = 0;

		# Check in the reference if it's found
		for (j = 1; j <= TERMS_COUNT; j++)
		{
			REF_WORD = TERMS[TERMS_COUNT];

			# If the current word is found in the ref, let's add it
			if (REF_WORD = COL)
			{
				found = 1;
				OUT_TAB_COUNT += 1;
				OUT_TAB[OUT_TAB_COUNT] = CLUSTER_ID;
				break;
			}
		}

		# Write error if the current word was not found
		if (found == 0)
		{
			ERR = "Word " COL " was not found in the reference";
			print ERR > "/dev/stderr";
		}
    }
	CLUSTER_ID += 1;
}


END {

	# Prepare Header first
	for (i = 1; i <= TERMS_COUNT; i++)
	{
		if (i == 1)
			OUT_HEADER = TERMS[1];
		else
			OUT_HEADER = OUT_HEADER OFS TERMS[i];
	}


	# Prepare Partitions
	for (i = 1; i <= OUT_TAB_COUNT; i++)
	{
		if (i == 1)
			OUT_TERMS = OUT_TAB[1];
		else
			OUT_TERMS = OUT_TERMS OFS OUT_TAB[i];
	}

	# Print header
	printf("%s\n", OUT_HEADER);

	# Print partitions
	printf("%s\n", OUT_TERMS);
}
