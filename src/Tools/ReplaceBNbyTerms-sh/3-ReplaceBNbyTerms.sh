#! /bin/sh

OUTPUT_PREFIX=bn-to-t_

if [ $# -lt 2 ]; then
    echo "Missing arguments"
    echo "$0 reference_list.csv input_file1.csv [...]"
    echo ""
    echo "Format of reference_list.csv :"
    echo "bn:ID ; Term"
    echo "bn:xxxxxx ; word1"
    echo "... ; ..."
    exit -1
fi

source ./functions.sh

########################################

REFERENCE_FILE="$1"
REFERENCE_BASENAME=`basename "${REFERENCE_FILE}"`
shift

if [ ! -f "${REFERENCE_FILE}" ]; then
    echo "Error:"
    echo "Reference file ${REFERENCE_FILE} doesn't exists"
    exit -2
fi

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

	# Replace bn:ID in every column and line by AWK method
	${AWK} -F ";" -v OFS=";" \
	       -f replace-bn-to-terms.awk \
	       "${REFERENCE_FILE}" ${TMP1_IN} > ${TMP2_OUT}

	# Change bn:ID everywhere in the document by SED method
	# ????

	cp -f ${TMP2_OUT} "${OUTPUT_NAME}"

	rm -f ${TMP1_IN}
	rm -f ${TMP2_OUT}
    fi
done
