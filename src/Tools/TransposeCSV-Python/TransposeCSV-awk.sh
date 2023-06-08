#! /bin/sh

OUTPUT_PREFIX=transposed_

function MyUsage()
{
    echo "Usage:"
    echo "$0 File.csv [...] "
    echo ""
}

if [ $# -lt 1 ]; then
    echo "Missing arguments"
    echo ""
    MyUsage
    exit -1
fi

source ./functions.sh

########################################

NUM_FILE=0
for ARG in "$@"
do
    if [ -f "${ARG}" ]; then
        INPUT_NAME="${ARG}"
        INPUT_BASENAME=`basename "${INPUT_NAME}"`
        echo "${INPUT_BASENAME}"

        OUTPUT_NAME="${OUTPUT_PREFIX}${INPUT_BASENAME}"

	MATRIX_FILE="${INPUT_NAME}"
	TMP1_OUT=`mktemp tmp1.XXXXX`

	# Transpose the matrix
	${AWK} -v FS=";" -v OFS=";" \
	       -f transpose-csv.awk \
	       ${MATRIX_FILE} > ${TMP1_OUT}

	cp -f ${TMP1_OUT} "${OUTPUT_NAME}"

	rm -f ${TMP1_OUT}
    else
        echo "File ${ARG} not found (skipping it)"
    fi
    NUM_FILE=$(( NUM_FILE + 1 ))
done
