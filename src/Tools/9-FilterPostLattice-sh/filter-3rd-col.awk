#! /bin/awk

# Filter and keep lines if they are "Objects" or "Attributes"

# Variables :
# OFS=";"
# FILTERED="Objects"  (or "Attributes")

# Input File (Obj/Attr) :
# Concept ID ; Level ; Objects/Attributes ; Nb Obj ; Nb Attr ; O/A1 ; O/A2 ; ..

# Output File (Objects) :
# Concept ID ; Level ; Objects|Attributes ; Nb Obj ; Nb Attr ; O|A1 ; O|A2 ; ..


{
    if (toupper($3) == toupper(FILTERED))
	print
}
