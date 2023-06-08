#! /bin/sh

OUTPUT_PREFIX=flat_

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

if [ "$#" != "2" ]; then
    OUTPUT_FILE=${OUTPUT_PREFIX}${INPUT_FILE}
else
    OUTPUT_FILE=$2
fi

source ./functions.sh

#####################################

TMP1_OUT=`mktemp tmp1.XXXXX`
TMP2_OUT=`mktemp tmp2.XXXXX`

${SED} -E 's/([![:space:]]+)/\1\n&/g' ${INPUT_FILE} > ${TMP1_OUT}
#${SED} -E 's/[[:punct:]]*([[:alpha:]]+)[[:punct:]]*/\1\n&/g' ${TMP1_OUT} > ${TMP2_OUT}
#cat ${TMP2_OUT} | tr -d [:blank:] > ${OUTPUT_FILE}
cat ${TMP1_OUT} | tr -d [:blank:] > ${OUTPUT_FILE}

rm -f ${TMP1_OUT}
rm -f ${TMP2_OUT}
