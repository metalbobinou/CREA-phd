#! /bin/awk

# Sort Fragments ID by their ID

# Variables :
# OFS=";"
# MAX_PARTS=${MAX_PARTS}  # Number max of Parts used while cutting documents


# Input file :
# Part ; Nb Fragments ; ID Fragment 1 [ ; ID Fragment 2 ; ... ]

# Output File :
# Part ; Nb Fragments ; ID Fragment 1 [ ; ID Fragment 2 ; ... ]


# Sort an array ("asort" is GNU awk extension :( )
# Usage : array_sort(array)   (ignore the next parameters)
function array_sort(array_sort_array, array_sort_x, array_sort_y, array_sort_z)
{
  for (array_sort_x in array_sort_array)
  {
      array_sort_y = array_sort_array[array_sort_x];
      array_sort_z = array_sort_x - 1;
      while (array_sort_z && array_sort_array[array_sort_z] > array_sort_y)
      {
	  array_sort_array[array_sort_z + 1] = array_sort_array[array_sort_z];
	  array_sort_z--;
      }
      array_sort_array[array_sort_z + 1] = array_sort_y;
  }
}


{
    CUR_PART = $1;
    MAX_FRAGS = $2;

    CUR_PART += 1; # Avoid 0

    for (iter in ARRAY)
	delete ARRAY[iter];
    NB_FRAGS = 0;

    for (i = 3; i <= NF; i++)
    {
	CUR_FRAG = $i;
	CUR_FRAG += 1; # Avoid 0

	ARRAY[i] = CUR_FRAG;
	NB_FRAGS++;
    }
    asort(ARRAY); # GNU awk only
    #array_sort(ARRAY);


    # Output File :
    # Part ; Nb Fragments ; ID Fragment 1 [ ; ID Fragment 2 ; ... ]

    printf("%s%s%s", (CUR_PART - 1), OFS, NB_FRAGS);
    for (iter in ARRAY)
    {
	if (length(ARRAY[iter]) != 0) # Because of array_sort function...
	{
	    CUR_FRAG = ARRAY[iter];
	    printf("%s%s", OFS, (CUR_FRAG - 1));
	}
    }
    printf("\n");
}
