#! /bin/awk

# Count how many cell with a specific value can be found

# Variables :
# OFS = ";"
# SEARCHED = "TERM";

function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

BEGIN {
    MY_COUNTER = 0;
}

{
    for (i = 1; i <= NF; i++)
	if (trim($i) == SEARCHED)
	    MY_COUNTER += 1;
}

END {
    printf("%d\n", MY_COUNTER);
}
