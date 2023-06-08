#! /bin/sh

OUTPUT_PREFIX=partition_
OUTPUT_READABLE_PREFIX=readable_${OUTPUT_PREFIX}
OUTPUT_REF=reference_partition.csv

MONO_CLUSTER_PREFIX=${OUTPUT_PREFIX}mono-excl_
MONO_CLUSTER_READABLE_PREFIX=${OUTPUT_READABLE_PREFIX}mono-excl_

MULTI_CLUSTER_PREFIX=${OUTPUT_PREFIX}multi-excl_
MULTI_CLUSTER_READABLE_PREFIX=${OUTPUT_READABLE_PREFIX}multi-excl_

if [ $# -lt 1 ]; then
    echo "Missing arguments"
    echo "$0 ref_clusters.csv [clusters-file1.csv ...]"
    exit -1
fi

source ./functions.sh

########################################

TMP1_IN=`mktemp tmp1.XXXXX`
TMP2_OUT=`mktemp tmp2.XXXXX`

cp -f "$1" ${TMP1_IN}

${AWK} -F ";" -v OFS=";" \
	       '{ for (i = 2; i <= NF; i++) {
	       	  if (i != 2)
		     { print SUB_OFS $i }
		  else
		     { print $i } } }' \
	       ${TMP1_IN} > ${TMP2_OUT}

cp -f ${TMP2_OUT} ${OUTPUT_REF}

rm -f ${TMP1_IN}
rm -f ${TMP2_OUT}


for ARG in "$@"
do
    if [ -f "${ARG}" ]; then
	IN_NAME="${ARG}"
	BASENAME=`basename "${IN_NAME}"`

	echo "-- ${BASENAME} --"

	#OUTPUT_NAME="${OUTPUT_PREFIX}${BASENAME}"
	#OUTPUT_READABLE_NAME="${OUTPUT_READABLE_PREFIX}${BASENAME}"

	OUTPUT_MONO_NAME="${MONO_CLUSTER_PREFIX}${BASENAME}"
	OUTPUT_MONO_READABLE_NAME="${MONO_CLUSTER_READABLE_PREFIX}${BASENAME}"

	OUTPUT_MULTI_NAME="${MULTI_CLUSTER_PREFIX}${BASENAME}"
	OUTPUT_MULTI_READABLE_NAME="${MULTI_CLUSTER_READABLE_PREFIX}${BASENAME}"

	TMP1_IN=`mktemp tmp1.XXXXX`
	TMP2_OUT=`mktemp tmp2.XXXXX`
	TMP3_OUT=`mktemp tmp3.XXXXX`

	cp -f "${IN_NAME}" ${TMP1_IN}

	# Create the list of terms and their cluster per file
	${AWK} -F ";" -v OFS=";" \
	       -f extract-term-cluster.awk \
	       ${TMP1_IN} > ${TMP2_OUT}


	##### MONO CLUSTER
	# Create the partition per file (Unknown terms are put in 1 cluster)
	${AWK} -F ";" -v OFS=";" \
	       -f extract-partition-unknown-mono-cluster.awk \
	       ${TMP2_OUT} ${OUTPUT_REF} > ${TMP3_OUT}

	cp -f ${TMP3_OUT} "${OUTPUT_MONO_READABLE_NAME}"

	# Remove the header within each file
	${AWK} -F ";" -v OFS=";" \
	       'NR > 1' \
	       ${OUTPUT_MONO_READABLE_NAME} > ${OUTPUT_MONO_NAME}


	##### MULTI CLUSTERS
	# Create the partition per file (Unknown terms are put in X clusters)
	${AWK} -F ";" -v OFS=";" \
	       -f extract-partition-unknown-multi-clusters.awk \
	       ${TMP2_OUT} ${OUTPUT_REF} > ${TMP3_OUT}

	cp -f ${TMP3_OUT} "${OUTPUT_MULTI_READABLE_NAME}"

	# Remove the header within each file
	${AWK} -F ";" -v OFS=";" \
	       'NR > 1' \
	       ${OUTPUT_MULTI_READABLE_NAME} > ${OUTPUT_MULTI_NAME}

	rm -f ${TMP1_IN}
	rm -f ${TMP2_OUT}
	rm -f ${TMP3_OUT}
    fi
done
