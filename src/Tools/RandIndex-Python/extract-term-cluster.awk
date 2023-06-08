#! /bin/awk

# List the selected terms from a file and their cluster

# Variables :
# OFS = ";"

# Input file (data file) :
# [Cluster ID] ; term1 ; term2 ; ...
# 1;text;url; ...
# 2;php;python; ...

# Output file :
# Term ; [Cluster ID]
# php;1
# python;1
# url;2
# text;2
# ...


function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

BEGIN {
	CLUSTER_ID = 1;
	NB_WORD = 0;
}

# Data file
{
	CLUSTER_ID = $1;

	for (i = 2; i <= NF; i++)
	{
		TERM = trim($i);
		NB_WORD += 1;

		printf("%s%s%s\n", TERM, OFS, CLUSTER_ID);
	}

	CLUSTER_ID += 1;
}
