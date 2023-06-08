#! /bin/awk

{
    for (i = 1; i <= NF; i++)
    {
	if (i == 1)
	{
	    FIRST_COL=$i
	}
	else
	{
	    printf "%s%s",$i,OFS
	}
    }
    printf "%s%s",FIRST_COL,ORS
}
