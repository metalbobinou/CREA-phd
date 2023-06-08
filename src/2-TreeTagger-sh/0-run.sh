#! /bin/sh

OUTPUT_PREFIX=processed_

if [ "$#" == "0" ] || [ $# -gt 2 ]; then
    if [ "$#" == "0" ]; then
        echo "Missing arguments"
        echo "$0 input_file [output_file]"
        exit -1
    else
        echo "Too much argument"
        echo "$0 input_file [output_file]"
        exit -2
    fi
fi

INPUT_FILE=$1
IN_BASENAME=`basename ${INPUT_FILE}`

if [ "$#" != "2" ]; then
    OUTPUT_FILE=${OUTPUT_PREFIX}${IN_BASENAME}
else
    OUTPUT_FILE=$2
fi

source ./functions.sh

#########################

if [ ! -f "${INPUT_FILE}" ]; then
    echo "File ${INPUT_FILE} does not exist"
    exit -1
fi

TMP1_FILE=`mktemp tmp1.XXXXX`
TMP2_FILE=`mktemp tmp2.XXXXX`
TMP3_FILE=`mktemp tmp3.XXXXX`

sh ./1-flat-file.sh ${INPUT_FILE} ${TMP1_FILE}

sh ./2-tag-words.sh ${TMP1_FILE} ${TMP2_FILE}

sh ./3-filter-words.sh ${TMP2_FILE} ${TMP3_FILE}

sh ./4-choose-morph-words.sh ${TMP3_FILE} ${OUTPUT_FILE}

rm -f ${TMP1_FILE}
rm -f ${TMP2_FILE}
rm -f ${TMP3_FILE}
