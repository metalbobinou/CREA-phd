#! /bin/awk

# Read first all the kept types (refused types were already filtered out)
#
# In the data file, the script tests if each word has a known type, and rewrite
# it if it has a known type

NR == FNR { FilterTypes[$1] = $1; next }
#BEGIN { OFS = "    " }
{
    hasType = 0;
    for (Type in FilterTypes)
	if ($2 ~ Type)
	{
	    hasType = 1;
	}

    if (hasType == 0)
    {
	print $1,$2,$3;
    }
}
