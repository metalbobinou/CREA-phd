#! /bin/awk

NR == FNR { FilterTypes[$1]; next }
{
    for (Type in FilterTypes)
	if ($0 !~ Type)
	{
	    print $2 $3
	}
}
