#! /bin/sh

OUTPUT_CAH_PREFIX=CAH_
OUTPUT_MDS_PREFIX=MDS_

SCRIPT1_PYTHON=./src/CAH-Dendrogramme.py
#SCRIPT2_PYTHON=./src/MDS-MultiDimensionalScaling-Dissimilarities.py
SCRIPT2_PYTHON=./src/MDS-MultiDimensionalScaling-Similarities.py

if [ "$#" == "0" ]; then
    echo "Missing arguments"
    echo "$0 input_file1.csv [...]"
    exit -1
fi

source ./functions.sh

########################################

SCRIPT1_PYTHON=`myrealpath ${SCRIPT1_PYTHON}`
SCRIPT2_PYTHON=`myrealpath ${SCRIPT2_PYTHON}`

for ARG in "$@"
do
    if [ -f "${ARG}" ]; then
	IN_NAME="${ARG}"
	BASENAME=`basename "${IN_NAME}"`

	echo "-- ${BASENAME} --"

	OUTPUT_CAH_NAME="${OUTPUT_CAH_PREFIX}${BASENAME}"
	OUTPUT_MDS_NAME="${OUTPUT_MDS_PREFIX}${BASENAME}"

	TMP1_IN=`mktemp tmp1.XXXXX`
	TMP1_CAH_IN=`mktemp tmp1.CAH.in.XXXXX`
	TMP1_MDS_IN=`mktemp tmp1.MDS.in.XXXXX`
	TMP2_OUT=`mktemp tmp2.XXXXX`

	cp -f "${IN_NAME}" ${TMP1_IN}


	#################################
	# Generate the CAH/Dendrogramme #
	#################################
	echo "-- ${BASENAME} : CAH / Dendrogram"

	cp -f ${TMP1_IN} ${TMP1_CAH_IN}

	# Basic call
	#${PYTHON} ${SCRIPT1_PYTHON} ${TMP1_CAH_IN} ${TMP2_OUT}
	# Complex call
	# script.py filename outfile separator XSize YSize dpi
	# Regular print
	#${PYTHON} ${SCRIPT1_PYTHON} ${TMP1_CAH_IN} ${TMP2_OUT} ";" 10 8 300
	# Bigger pic for : Directe, Indirecte, S=M
	${PYTHON} ${SCRIPT1_PYTHON} ${TMP1_CAH_IN} ${TMP2_OUT} ";" 40 32 300

	cp -f ${TMP2_OUT}.png "${OUTPUT_CAH_NAME}.png"

	##############################################
	# Generate the MDS/Multi-Dimensional Scaling #
	##############################################
	echo "-- ${BASENAME} : MDS / Multi-Dimensional Scaling"

	cp -f ${TMP1_IN} ${TMP1_MDS_IN}

	${PYTHON} ${SCRIPT2_PYTHON} ${TMP1_MDS_IN} ${TMP2_OUT}

	cp -f ${TMP2_OUT}.png "${OUTPUT_MDS_NAME}.png"

	rm -f ${TMP1_IN}
	rm -f ${TMP1_CAH_IN}
 	rm -f ${TMP1_MDS_IN}
	rm -f ${TMP2_OUT} ${TMP2_OUT}.png
    fi
done
