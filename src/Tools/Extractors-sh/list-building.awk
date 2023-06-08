#! /bin/awk

# Build a list for bowbowbow-apriori
#
# Format :
# [item_id]\t[item_id]\n
# [item_id]\t[item_id]\t[item_id]\t[item_id]\t[item_id]\n
# [item_id]\t[item_id]\t[item_id]\t[item_id]\n
#
# Row is transaction
# [item_id] is a numerical value
# There is no duplication of items in each transaction

BEGIN {
    OFS = "\t"
}

{
    # We skip the 5 first columns
    beginning = 6;
    for (i = beginning; i <= NF; i++)
    {
	if (i == beginning)
	    OUT = $i
	else
	    OUT = OUT OFS $i
    }
    print OUT
}
