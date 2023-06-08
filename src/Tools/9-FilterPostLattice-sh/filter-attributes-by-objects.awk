#! /bin/awk

# Filter the attributes based on the ID of the fragment of the objects
# Only the attributes associated with a kept fragment should be copied

# Variables :
# OFS=";"

# Input File 1 (Objects) :
# Concept ID ; Level ; Objects ; Nb Obj ; Nb Attr ; Object1 ; Object2 ; ...

# Input File 2 (Attributes) :
# Concept ID ; Level ; Attributes ; Nb Obj ; Nb Attr ; Attribute1 ; Attribute2 ; ...

# Output File (Attributes) :
# Concept ID ; Level ; Attributes ; Nb Obj ; Nb Attr ; Attribute1 ; Attribute2 ; ...


# Each object is read (only the filtered objets are here)
FNR == NR {
    ID[$1] = 1;
    next;
}

# Each attribute is read
{
    if (ID[$1] == 1)
	print $0;
}
