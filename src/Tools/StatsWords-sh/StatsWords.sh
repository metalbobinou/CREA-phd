#! /bin/sh

OUTPUT_PREFIX=stats_
SUM_PREFIX=sum_

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
    SUM_FILE=${SUM_PREFIX}${IN_BASENAME}
else
    OUTPUT_FILE=$2
    SUM_FILE=${SUM_PREFIX}$2
fi

source ./functions.sh

#########################

if [ ! -f "${INPUT_FILE}" ]; then
    echo "File ${INPUT_FILE} does not exist"
    exit -1
fi

TMP_FILE1=`mktemp tmp1.XXXXX`
TMP_FILE2=`mktemp tmp2.XXXXX`
TMP_FILE3=`mktemp tmp3.XXXXX`


${SORT} -o ${TMP_FILE1} ${INPUT_FILE}
${UNIQ} -c ${TMP_FILE1} > ${TMP_FILE2}
${SORT} -r -k1,1 -o ${TMP_FILE3} ${TMP_FILE2}
${AWK} -v OFS=" " -f print_1st_col_and_others.awk \
    ${TMP_FILE3} > ${OUTPUT_FILE}

${AWK} -v OFS=" " '{ sum += $1 } END{ print sum }' ${TMP_FILE2} > ${SUM_FILE}

rm -f ${TMP_FILE1}
rm -f ${TMP_FILE2}
rm -f ${TMP_FILE3}
