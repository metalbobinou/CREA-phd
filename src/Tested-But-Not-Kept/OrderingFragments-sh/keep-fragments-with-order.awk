#! /bin/awk

# Keep only the lines where the number of parts is not 0

# Variables :
# OFS=";"
# SUB_OFS=","

# INPUT FILE :
# Concept ID ; Level ; Type Obj/Attr/Parts ; Nb O ; Nb A ; Nb Parts ; ATT1/OBJ1 ("Name bn:ID", bn:ID)/PART1 [ ; ATT2/OBJ2/PART2 ; ... ]

# OUTPUT FILE :
# Concept ID ; Level ; Type Obj/Attr/Parts ; Nb O ; Nb A ; Nb Parts ; ATT1/OBJ1 ("Name bn:ID", bn:ID)/PART1 [ ; ATT2/OBJ2/PART2 ; ... ]

NR == 1 {
    print $0;
}

NR != 1 {
    NB_PARTS = $6;
    if (NB_PARTS > 0)
	print $0;
}
