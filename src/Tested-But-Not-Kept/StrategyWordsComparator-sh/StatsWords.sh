#! /bin/sh

if [ $# -lt 2 ]; then
    echo "Missing arguments"
    echo "$0 output_file input_file1 ..."
    exit -1
fi

source ./functions.sh

#########################

LOOP=0
for ARG in "$@"
do
    if [ "${LOOP}" = "0" ]; then
	LOOP=$((LOOP + 1))
	OUTPUT_NAME=${ARG}
	echo "" > ${OUTPUT_NAME}
	TMP_REFERENCE=`mktemp tmp.reference.XXXXX`
	continue
    fi

    INPUT_FILE=${ARG}
    IN_BASENAME=`basename ${INPUT_FILE}`

    if [ ! -f "${INPUT_FILE}" ]; then
	echo "File ${INPUT_FILE} does not exist (it is ignored)"
	continue
    fi

    TMP1_HEADER=`mktemp tmp1.header.XXXXX`
    TMP2_ATTRIBUTES=`mktemp tmp2.attributes.XXXXX`
    TMP3_SORT=`mktemp tmp3.sort.XXXXX`
    TMP4_REORGANIZED=`mktemp tmp4.reorganized.XXXXX`
    TMP5_REORGANIZED=`mktemp tmp5.reorganized.XXXXX`
    TMP6_OUTPUT=`mktemp tmp6.output.XXXXX`

    ${HEAD} -n 1 ${INPUT_FILE} > ${TMP1_HEADER}
    ${TR} ';' '\n' < ${TMP1_HEADER} > ${TMP2_ATTRIBUTES}
    ${SORT} -o ${TMP3_SORT} ${TMP2_ATTRIBUTES}
    ${AWK} -v OFS=";" -f move_last_col_as_first.awk \
	${TMP3_SORT} > ${TMP4_REORGANIZED}
    ${SED} -e 's/;/ /2g' ${TMP4_REORGANIZED} > ${TMP5_REORGANIZED}
    ${JOIN} -a 1 -a 2 -1 1 -2 1 -o 0,1.2,2.2 -e "NULL" -t ';' \
	${TMP5_REORGANIZED} ${TMP_REFERENCE} > ${TMP6_OUTPUT}
    ${CAT} ${TMP6_OUTPUT} > ${TMP_REFERENCE}

#    ${JOIN} -a 2 -1 1  ${TMP_REFERENCE} ${TMP4_REORGANIZED} > ${TMP5_JOIN}

#    ${UNIQ} -c ${TMP_FILE1} > ${TMP_FILE2}
#    ${SORT} -r -k1,1 -o ${TMP_FILE3} ${TMP_FILE2}
#    ${AWK} -v OFS=" " -f print_1st_col_and_others.awk \
#	${TMP3_SORT} > ${TMP4_REORGANIZED}
#
#    ${AWK} -v OFS=" " '{ sum += $1 } END{ print sum }' ${TMP_FILE2} > ${SUM_FILE}

#    rm -f ${TMP1_HEADER}
#    rm -f ${TMP2_ATTRIBUTES}
#    rm -f ${TMP3_SORT}
#    rm -f ${TMP4_JOIN}
#    rm -f ${TMP_REFERENCE}

done
