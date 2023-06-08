#! /bin/sh

OUTPUT_PREFIX=replaced_

function myusage()
{
    echo "Usage:"
    echo "$0 reference-file file-to-modify"
    echo ""
    echo "Format of reference-file (lines_*):"
    echo "ID ; text"
    echo "N1 ; expression"
    echo "N2 ; another expression"
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

    TMP1_OUT=`mktemp tmp1.XXXXX`

    ### REPLACE
    # Replace occurrences of expressions from the 2nd column of ref file
    ${AWK} -F ";" -v OFS=";" -v SUB_OFS="," \
	-f replace-ID-by-ref.awk   \
	"${REFERENCE_FILE}" "${INPUT_NAME}" > ${TMP1_OUT}

    cp -f ${TMP1_OUT} "${OUTPUT_NAME}"

    rm -f ${TMP1_OUT}
else
    echo "Reference file or File to modify do not exist"
    echo "Try again with existing file"
    echo ""
    myusage
    exit -2
fi
