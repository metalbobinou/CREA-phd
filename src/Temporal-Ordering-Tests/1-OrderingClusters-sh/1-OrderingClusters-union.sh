#! /bin/sh

OUTPUT_PREFIX=ordered-union_

# Merge clusters and parts with a "union" strategy :
# Parts of each term are used.
#
# Example for a cluster:
# Term1 appears in parts : 0, 1, 2, 3, 4
# Term2 appears in parts : 0, 1, 2, 5, 6
# Term3 appears in parts : 7
#
# Out parts for this cluster : 0, 1, 2, 3, 4, 5, 6, 7

function MyUsage()
{
    echo "Usage:"
    echo "$0 Clusters-file Ordering-file"
    echo ""
    echo "Format of Clusters-file-union:"
    echo "Cluster ID ; Significance ; bn:ID 1 ; bn:ID 2 ; ... "
    echo "0 ; 10 ; bn:00079583n ; bn:00079589n ; ... "
    echo "... ; ... ; ... ; ... "
    echo ""
    echo "Format of Ordering-file-union:"
    echo "\"Name bn:ID\" ; bn:ID ; Part ; File1 [; File2 ; ... ]"
    echo "\"variables bn:00079583n\" ; bn:00079583n ; 0 ; C1 ; C2"
    echo "... ; ... ; ... ; ... "
}

if [ $# -lt 2 ] || [ $# -gt 2 ]; then
    if [ $# -lt 2 ]; then
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

INPUT_CLUSTERS=$1
INPUT_ORDERING=$2

if [ ! -f "${INPUT_CLUSTERS}" ]; then
    echo "File ${INPUT_CLUSTERS} does not exist"
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

CLUSTERS_NAME="${INPUT_CLUSTERS}"
CLUSTERS_BASENAME=`basename "${CLUSTERS_NAME}"`
ORDERING_NAME="${INPUT_ORDERING}"
ORDERING_BASENAME=`basename "${ORDERING_NAME}"`

OUTPUT_NAME="${OUTPUT_PREFIX}${CLUSTERS_BASENAME}"

TMP1_ORDERING_IN=`mktemp tmp1.ordering.in.XXXXX`
TMP2_ORDERING_SORTED=`mktemp tmp2.ordering.sorted.XXXXX`
TMP2_CLUSTERS_IN=`mktemp tmp2.clusters.in.XXXXX`
TMP3_CLUSTERS_COMPUTED=`mktemp tmp3.clusters.computed.XXXXX`
TMP4_CLUSTERS_OUT=`mktemp tmp4.clusters.out.XXXXX`


cp -f "${CLUSTERS_NAME}" ${TMP2_CLUSTERS_IN}
cp -f "${ORDERING_NAME}" ${TMP1_ORDERING_IN}


# CLUSTERS_NAME :
# Cluster ID ; Significance ; bn:ID 1 ; bn:ID 2 ; ...

# ORDERING_NAME :
# "\"Name bn:ID\" ; bn:ID ; Part ; File1 [; File2 ; ... ]

# Sort parts by BN_ID first, and then by parts number
${SORT} -t";" -k1,3 ${TMP1_ORDERING_IN} > ${TMP2_ORDERING_SORTED}

# CLUSTERS_NAME :
# Cluster ID ; Significance ; bn:ID 1 ; bn:ID 2 ; ...

# ORDERING_NAME :
# "\"Name bn:ID\" ; bn:ID ; Part ; File1 [; File2 ; ... ]

# Merge the Fragments and Ordering
${AWK} -v FS=";" -v OFS=";" -v SUB_OFS="," \
       -f merge-order-and-clusters-union.awk  \
       ${TMP2_CLUSTERS_IN} ${TMP2_ORDERING_SORTED} > ${TMP3_CLUSTERS_COMPUTED}


#cp -f ${TMP3_CLUSTERS_COMPUTED} ORDER.csv


# CLUSTERS_ORDER :
# Concept ID ; Significance ; Nb Parts ; [ Part 1 , Part 2 , ... ] ; bn:ID 1 [; bn:ID 2 ; ... ]

# Clean the redundant number of parts
${AWK} -v FS=";" -v OFS=";" -v SUB_OFS="," \
       -f clean-redundant-parts.awk  \
       ${TMP3_CLUSTERS_COMPUTED} > ${TMP4_CLUSTERS_OUT}


cp -f ${TMP4_CLUSTERS_OUT} "${OUTPUT_NAME}"

rm -f ${TMP1_ORDERING_IN}
rm -f ${TMP2_ORDERING_SORTED}
rm -f ${TMP2_CLUSTERS_IN}
rm -f ${TMP3_CLUSTERS_COMPUTED}
rm -f ${TMP4_CLUSTERS_OUT}
