#! /bin/awk

# Join back the two files of Objects and Attributes...
# One per line (Obj first, Att then)

# Variables :
# OFS=";"

# Input File 1 (Objects) :
# Concept ID ; Level ; Objects ; Nb Obj ; Nb Attr ; Object1 ; Object2 ; ...

# Input File 2 (Attributes) :
# Concept ID ; Level ; Attributes ; Nb Obj ; Nb Attr ; Attrib1 ; Attrib2 ; ...

# Output File (Objects/Attributes) :
# Concept ID ; Level ; Obj/Attr ; Nb Obj ; Nb Attr ; Obj/Att1 ; Obj/Att2 ; ...


# Print a header
BEGIN {
    printf("%s\n",
	   "Concept ID;Level;Type Obj/Att;Nb Obj;Nb Att;Objects/Attributes;");
}

# Store the objects lines
FNR == NR {
    line[$1] = $0;
    next;
}

# For each attribute, print its object line
#  then the attribute line
{
    printf("%s\n", line[$1]);
    printf("%s\n", $0);
}
