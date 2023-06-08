#! /bin/sh

OUTPUT_PREFIX=CAH_

SCRIPT1_PYTHON=./src/CAH-Dendrogramme.py

if [ "$#" == "0" ]; then
    echo "Missing arguments"
    echo "$0 input_file1.csv [...]"
    exit -1
fi

source ./functions.sh

########################################

SCRIPT1_PYTHON=`myrealpath ${SCRIPT1_PYTHON}`

for ARG in "$@"
do
    if [ -f "${ARG}" ]; then
	IN_NAME="${ARG}"
	BASENAME=`basename "${IN_NAME}"`

	OUTPUT_NAME="${OUTPUT_PREFIX}${BASENAME}"

	TMP1_NAME=`mktemp tmp1.XXXXX`
	TMP2_NAME=`mktemp tmp2.XXXXX`

	cp -f "${IN_NAME}" ${TMP1_NAME}

	#################################
	# Generate the CAH/Dendrogramme #
	#################################
	# Basic call
	#${PYTHON} ${SCRIPT1_PYTHON} ${TMP1_NAME} ${TMP2_NAME}
	# Complex call
	# script.py filename outfile separator XSize YSize dpi
	# Regular print
	#${PYTHON} ${SCRIPT1_PYTHON} ${TMP1_NAME} ${TMP2_NAME} ";" 10 8 300
	# Bigger pic for : Directe, Indirecte, S=M
	${PYTHON} ${SCRIPT1_PYTHON} ${TMP1_NAME} ${TMP2_NAME} ";" 40 32 300

	cp -f ${TMP2_NAME}.png "${OUTPUT_NAME}.png"

	rm -f ${TMP1_NAME}
	rm -f ${TMP2_NAME} ${TMP2_NAME}.png
    fi
done
