#! /bin/awk

# -v SEP=";" given as variable

# If we are on the 1st line
NR == 1 {
    # Let's build and print a line with numbers
    for (i = 1; i <= NF; i++)
    {
	col_num = i - 1;
	if (i == 1)
	    NUMS = "X";
	else
	    NUMS = NUMS SEP col_num;
    }
    print NUMS;
}

NR != 1 {
    #print (NR - 1) SEP $1
    
    # Let's copy each field and add a number in front
    for (i = 1; i <= NF; i++)
    {
	if (i == 1)
	    COLS = (NR - 1);
	else
	    COLS = COLS SEP $i;
    }
    print COLS;
}
