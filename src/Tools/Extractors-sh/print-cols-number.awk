#! /bin/awk

# -v SEP=";" given as variable

# If we are on the 1st line
NR == 1 {
    # Let's build and print a line with numbers
    for (i = 1; i <= NF; i++)
    {
	col_num = i - 1;
	if (i == 1)
	    NUMS = "";
	else
	    NUMS = NUMS SEP col_num;
    }
    print NUMS;

    # Let's build and print a line with the 1st column content
    for (i = 1; i <= NF; i++)
    {
	if (i == 1)
	    COLS = $i;
	else
	    COLS = COLS SEP $i;
    }
    print COLS;
}
