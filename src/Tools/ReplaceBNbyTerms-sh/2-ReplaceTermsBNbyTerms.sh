#! /bin/sh

OUTPUT_PREFIX=tbn-to-t_

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

	OUTPUT_NAME="${OUTPUT_PREFIX}${BASENAME}"

	TMP1_IN=`mktemp tmp1.XXXXX`
	TMP2_OUT=`mktemp tmp2.XXXXX`

	cp -f "${IN_NAME}" ${TMP1_IN}

	# Replace terms bn:ID in every column and line by AWK method
	${AWK} -F ";" -v OFS=";" \
	       -f replace-terms-bn-to-terms.awk \
	       ${TMP1_IN} > ${TMP2_OUT}

	# Change bn:ID everywhere in the document by SED method
	# ????

	cp -f ${TMP2_OUT} "${OUTPUT_NAME}"

	rm -f ${TMP1_IN}
	rm -f ${TMP2_OUT}
    fi
done
