#! /bin/sh

# OUTPUT_PREFIX=unknown_

if [ $# -lt 1 ]; then
    echo "Missing arguments"
    echo "$0 input_file1.csv [...]"
    exit -1
fi

source ./functions.sh

########################################

for ARG in "$@"
do
    if [ -f "${ARG}" ]; then
	IN_NAME="${ARG}"
	BASENAME=`basename "${IN_NAME}"`

	echo "-- ${BASENAME} --"

	#OUTPUT_NAME="${OUTPUT_PREFIX}${BASENAME}"

	TMP1_IN=`mktemp tmp1.XXXXX`
	TMP2_OUT=`mktemp tmp2.XXXXX`
	TMP3_OUT=`mktemp tmp3.XXXXX`

	cp -f "${IN_NAME}" ${TMP1_IN}

	# Remove the header of the strategy matrix (infos)
	${AWK} -F ";" -v OFS=";" \
	       -f remove-header.awk \
	       ${TMP1_IN} > ${TMP2_OUT}

	# Remove the 1st column of the strategy matrix (infos)
	${AWK} -F ";" -v OFS=";" \
	       -f remove-1st-col.awk \
	       ${TMP2_OUT} > ${TMP3_OUT}

	echo ""
	${CAT} ${TMP3_OUT}
	echo ""

	#cp -f ${TMP2_OUT} "${OUTPUT_NAME}"

	echo "--- END OF CURRENT PROCESSING ---"
	echo "#################################"
	echo "#################################"

	rm -f ${TMP1_IN}
	rm -f ${TMP2_OUT}
	rm -f ${TMP3_OUT}
    fi
done
