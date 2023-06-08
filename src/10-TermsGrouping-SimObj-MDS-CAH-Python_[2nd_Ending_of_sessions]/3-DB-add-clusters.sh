#! /bin/sh

if [ $# -lt 2 ]; then
    echo "Missing arguments"
    echo "$0 Reference_Clusters.csv new_clusters.csv [...]"
    echo ""
    echo "Reference_Clusters.csv : "
    echo "ID_Cluster ; Qty Occurrences Cluster ; Word1 ; Word2 ; ..."
    echo "[identifier ; nb of times a cluster appeared ; term 1 ; term 2 ; ...]"
    echo ""
    exit -1
fi

source ./functions.sh

########################################

REFERENCE_FILE="$1"
REFERENCE_BASENAME=`basename "${REFERENCE_FILE}"`
shift

if [ ! -f "${REFERENCE_FILE}" ]; then
    #echo "Error:"
    echo "!!! Warning : !!!"
    echo "Reference file ${REFERENCE_FILE} doesn't exists"
    echo "Creating an empty one"
    echo "" > "${REFERENCE_FILE}"
    #exit -2
fi

for ARG in "$@"
do
    if [ -f "${ARG}" ]; then
        IN_NAME="${ARG}"
        BASENAME=`basename "${IN_NAME}"`

	echo "-- ${BASENAME} --"

	TMP1_IN=`mktemp tmp1.XXXXX`
	TMP2_OUT=`mktemp tmp2.XXXXX`

	cp -f "${IN_NAME}" ${TMP1_IN}

	# Update the DB. BEWARE: IT ALWAYS TAKE INTO ACCOUNT THE FIRST LINE
        ${AWK} -F ";" -v OFS=";" -v AVOID_FIRST_LINE="0" \
               -f DB-add-clusters.awk \
               "${REFERENCE_FILE}" ${TMP1_IN} > ${TMP2_OUT}
	# -v FORCE_COUNT="42" is a possible option for forcing a specific count

	cp -f ${TMP2_OUT} "${REFERENCE_FILE}"

	rm -f ${TMP1_IN}
	rm -f ${TMP2_OUT}
    else
	echo "#### Missing file: ${ARG}"
    fi
done
