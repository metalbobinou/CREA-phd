#! /bin/sh

OUTPUT_PREFIX=transposed_

SCRIPT1_PYTHON=./src/Transpose.py
SCRIPT2_AWK=./frame-1st-col.awk

if [ "$#" == "0" ]; then
    echo "Missing arguments"
    echo "$0 input_file [output_file]"
    exit -1
fi

source ./functions.sh

########################################

SCRIPT1_PYTHON=`myrealpath ${SCRIPT1_PYTHON}`
SCRIPT2_AWK=`myrealpath ${SCRIPT2_AWK}`

for ARG in "$@"
do
    if [ -f "${ARG}" ]; then
	IN_NAME="${ARG}"
	BASENAME=`basename ${IN_NAME}`
	OUT_NAME=${OUTPUT_PREFIX}${BASENAME}
	TMP_NAME=`mktemp tmp.XXXXX`
	${PYTHON} ${SCRIPT1_PYTHON} ${ARG} ${TMP_NAME}
	${AWK} -v FS=";" -v OFS=";" -f ${SCRIPT2_AWK}  \
	    ${TMP_NAME} > ${OUT_NAME}
	rm -f ${TMP_NAME}
    fi
done
