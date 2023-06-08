#! /bin/awk

# Filter and keeps objects following rules :
# - Keep object if there are at least 1 object (remove the empty concept)
# - Keep object if there are at least 2 attributes

# Variables :
# OFS=";"

# Input File (Objects) :
# Concept ID ; Level ; Objects ; Nb Obj ; Nb Attr ; Object1 ; Object2 ; ...

# Output File (Objects) :
# Concept ID ; Level ; Attributess ; Nb Obj ; Nb Attr ; Attribute1 ; Attribute2 ; ...


{
    # Keep the not Objects not empty + 2 Attributes at least
    if (($4 != 0) && ($5 >= 2))
	print
}
