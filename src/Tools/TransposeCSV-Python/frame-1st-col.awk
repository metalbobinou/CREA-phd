#! /bin/awk

NR <= 1 { print $0 }
NR > 1 {
    for (i = 1; i <= NF; i++)
    {
	if (i == 1)
	{
	    printf "\""$i"\""
	}
	else
	{
	    printf "%s%s",OFS,$i
	}
    }
    print ""
}
