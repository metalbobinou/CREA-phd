#! /bin/awk

# -v SEP=";" given as variable

# If we are on the 1st line
NR == 1 {
    # Let's build and print a line with numbers
    for (i = 1; i <= NF; i++)
    {
	col_num = i - 1;
	if (i == 1)
	    NUMS = SEP;
	else
	    NUMS = NUMS SEP col_num;
    }
    print NUMS;
    
    # Let's build and print a line with the 1st column/field content
    for (i = 1; i <= NF; i++)
    {
	if (i == 1)
	    COLS = SEP $i;
	else
	    COLS = COLS SEP $i;
    }
    print COLS;
}

NR != 1 {
    #print (NR - 1) SEP $1
    
    # Let's copy each field and add a number in front
    for (i = 1; i <= NF; i++)
    {
	if (i == 1)
	    COLS = (NR - 1) SEP $i;
	else
	    COLS = COLS SEP $i;
    }
    print COLS;
}
