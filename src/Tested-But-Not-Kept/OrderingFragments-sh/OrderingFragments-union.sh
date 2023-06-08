#! /bin/sh

OUTPUT_PREFIX=ordered-union_

function MyUsage()
{
    echo "Usage:"
    echo "$0 NbParts Fragments-file Ordering-file"
    echo ""
    echo "NbParts : an integer giving the number of parts (NbParts > 0)"
    echo ""
    echo "Format of Fragments-file-union: (1st line Object, 2nd line Attribute, ...)"
    echo "Concept ID ; Level ; Type Obj/Attr ; Nb O ; Nb A ; Obj1/Attr1 [; O/A2 ; ... ]"
    echo "... ; ... ; ... ; ... "
    echo ""
    echo "Format of Ordering-file-union:"
    echo "\"Name bn:ID\" ; bn:ID ; Part ; File1 [; File2 ; ... ]"
    echo "\"variables bn:00079583n\" ; bn:00079583n ; 0 ; C1 ; C2"
    echo "... ; ... ; ... ; ... "
}

if [ $# -lt 3 ] || [ $# -gt 3 ]; then
    if [ $# -lt 3 ]; then
        echo "Missing arguments"
	echo ""
	MyUsage
        exit -1
    else
        echo "Too much argument"
	echo ""
	MyUsage
        exit -2
    fi
fi

source ./functions.sh

########################################

MAX_PARTS=$1
INPUT_FRAGMENTS=$2
INPUT_ORDERING=$3

if [ $1 -le 0 ]; then
    echo "NbParts must be positive and not null"
    echo ""
    MyUsage
    exit -1
fi
if [ ! -f "${INPUT_FRAGMENTS}" ]; then
    echo "File ${INPUT_FRAGMENTS} does not exist"
    echo ""
    MyUsage
    exit -1
fi
if [ ! -f "${INPUT_ORDERING}" ]; then
    echo "File ${INPUT_ORDERING} does not exist"
    echo ""
    MyUsage
    exit -1
fi

FRAGMENTS_NAME="${INPUT_FRAGMENTS}"
FRAGMENTS_BASENAME=`basename "${FRAGMENTS_NAME}"`
ORDERING_NAME="${INPUT_ORDERING}"
ORDERING_BASENAME=`basename "${ORDERING_NAME}"`


OUTPUT_NAME="${OUTPUT_PREFIX}${FRAGMENTS_BASENAME}"

CLEAN_FRAGMENTS=`mktemp tmp.clean_frags.XXXXX`
ORDERED_PARTS=`mktemp tmp.ordered_parts.XXXXX`
FRAGMENTS_ORDER=`mktemp tmp.fragments_order.XXXXX`
TMP1_OUT=`mktemp tmp1.XXXXX`


# FRAGMENTS_NAME :
# Concept ID ; Level ; Type Obj/Attr ; Nb O ; Nb A ; Obj1/Attr1 [; O/A2 ; ... ]

# Divide the "Object" columns into a field with "Name bn:ID" and one "bn:ID"
${AWK} -v FS=";" -v OFS=";" -v SUB_OFS="," \
       -f divide-babelnetid-col.awk  \
       "${FRAGMENTS_NAME}" > ${CLEAN_FRAGMENTS}

# ORDERING_NAME :
# "\"Name bn:ID\" ; bn:ID ; Part ; File1 [; File2 ; ... ]

# Sort parts by BN_ID first, and then by parts number
${SORT} -t";" -k1,3 "${ORDERING_NAME}" > ${ORDERED_PARTS}

# Get max number of files in the ordering file column (C1;C3;C5 = 3 files)
${AWK} -v FS=";" -v OFS=";" -v SUB_OFS="," -v MAX_PARTS="${MAX_PARTS}" \
       'BEGIN {max=0}  { if (max < (NF - 3)) max=(NF - 3) } END {print max}' \
       ${ORDERED_PARTS} > ${TMP1_OUT}
MAX_ORDERING_FILES=`cat ${TMP1_OUT}`


# ORDERING_NAME :
# "\"Name bn:ID\" ; bn:ID ; Part ; File1 [; File2 ; ... ]

# CLEAN_FRAGMENTS :
# Concept ID ; Level ; Type Obj/Attr ; Nb O ; Nb A ; A/O1 ("Name bn:ID", bn:ID) [ ; A/O2 ; ... ]

# Merge the Fragments and Ordering... and create an order of fragments
${AWK} -v FS=";" -v OFS=";" -v SUB_OFS="," -v MAX_PARTS="${MAX_PARTS}" \
       -v MAX_ORDERING_FILES="${MAX_ORDERING_FILES}" \
       -f merge-order-and-fragments-UNION.awk  \
       ${ORDERED_PARTS} ${CLEAN_FRAGMENTS} > ${FRAGMENTS_ORDER}


# FRAGMENTS_ORDER :
# Concept ID ; Nb Parts ; Part 1 [; Part 2 ; ... ]

# CLEAN_FRAGMENTS :
# Concept ID ; Level ; Type Obj/Attr ; Nb O ; Nb A ; A/O1 ("Name bn:ID", bn:ID) [ ; A/O2 ; ... ]

# Merge back fragments and their orders
${AWK} -v FS=";" -v OFS=";" -v SUB_OFS="," -v MAX_PARTS="${MAX_PARTS}" \
       -f fragments-ordered-merged.awk \
       ${FRAGMENTS_ORDER} ${CLEAN_FRAGMENTS} > ${TMP1_OUT}

#echo ""
#echo "Parts :"
#cat ${ORDERED_PARTS}
#echo ""
#echo "Clean Fragments :"
#cat ${CLEAN_FRAGMENTS}
#echo ""
#echo "Merge result :"
#cat ${FRAGMENTS_ORDER}
#echo""
#cat ${TMP1_OUT}

cp -f ${TMP1_OUT} "${OUTPUT_NAME}"

rm -f ${FRAGMENTS_ORDER}
rm -f ${ORDERED_PARTS}
rm -f ${CLEAN_FRAGMENTS}
rm -f ${TMP1_OUT}
