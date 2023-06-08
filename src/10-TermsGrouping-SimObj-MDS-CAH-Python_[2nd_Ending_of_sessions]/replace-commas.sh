#! /bin/sh

OUTPUT_PREFIX=CtoD_

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

	# Replace the commas by dot
	sed 's/\([0-9]\),\([0-9]\)/\1.\2/g' ${TMP1_IN} > ${TMP2_OUT}

	cp -f ${TMP2_OUT} "${OUTPUT_NAME}"

	rm -f ${TMP1_IN}
	rm -f ${TMP2_OUT}
    fi
done
