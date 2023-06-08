#! /bin/sh

OUTPUT_PREFIX=list_
OUTPUT_PREFIX_REPLACED=replaced_

function myusage()
{
    echo "Usage:"
    echo "$0 reference-file file-to-modify"
    echo ""
    echo "Format of reference-file (colstrans_*/lines_* from Extract-1st-col.sh):"
    echo "number ; reference"
    echo "1 ; expression"
    echo "2 ; another expression"
    echo "... ; ..."
}

if [ $# != 2 ]; then
    echo "Missing arguments"
    echo ""
    myusage
    exit -1
fi

source ./functions.sh

#########################

if [ -f "$1" ] && [ -f "$2" ]; then
    REFERENCE_FILE="$1"
    INPUT_NAME="$2"
    INPUT_BASENAME=`basename "${INPUT_NAME}"`
    echo "${INPUT_BASENAME}"

    OUTPUT_NAME="${OUTPUT_PREFIX}${INPUT_BASENAME}"
    OUTPUT_REPLACED="${OUTPUT_PREFIX_REPLACED}${INPUT_BASENAME}"

    TMP1_OUT=`mktemp tmp1.XXXXX`
    TMP2_OUT=`mktemp tmp2.XXXXX`
    TMP3_OUT=`mktemp tmp3.XXXXX`

    ### REPLACE
    # Replace occurrences of expressions from the 2nd column of ref file
    ${AWK} -F ";" -v SEP=";"        \
	-f replace-expressions-numbers.awk   \
	"${REFERENCE_FILE}" "${INPUT_NAME}" > ${TMP1_OUT}

    cp -f ${TMP1_OUT} "${OUTPUT_REPLACED}"

    ### LISTING
    # Delete the 5 first useless columns
    ${AWK} -F ";" -v SEP=";"  \
        -f list-building.awk  \
	${TMP1_OUT} > ${TMP2_OUT}

    ### TRIM
    # Delete the useless space at the end
    ${AWK} -F "\t"       \
	'{$1=$1;print}'  \
	${TMP2_OUT} > ${TMP3_OUT}

    cp -f ${TMP3_OUT} "${OUTPUT_NAME}"

    rm -f ${TMP1_OUT}
    rm -f ${TMP2_OUT}
    rm -f ${TMP3_OUT}
else
    echo "Reference file or File to modify do not exist"
    echo "Try again with existing file"
    echo ""
    myusage
    exit -2
fi
