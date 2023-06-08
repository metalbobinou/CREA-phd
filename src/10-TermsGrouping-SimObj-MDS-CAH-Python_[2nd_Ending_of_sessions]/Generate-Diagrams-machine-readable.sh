#! /bin/sh

OUTPUT_CAH_PREFIX=CAH_
OUTPUT_MDS_PREFIX=MDS_
OUTPUT_K_MEANS_PREFIX=K-MEANS_

SCRIPT1_PYTHON=./src/CAH-Dendrogramme.py
SCRIPT2_PYTHON=./src/MDS-MultiDimensionalScaling-Dissimilarities.py
SCRIPT3_PYTHON=./src/K-Means+MDS-Dissimiliarities-machine-readable.py

SCRIPT1_SIMILARITY_TO_DISSIMILARITY=similarity-to-dissimilarity-simple.awk
SCRIPT2_SIMILARITY_TO_DISSIMILARITY=similarity-to-dissimilarity-complex.awk

SIMILARITY_TO_DISSIMILARITY=${SCRIPT2_SIMILARITY_TO_DISSIMILARITY}

if [ "$#" == "0" ]; then
    echo "Missing arguments"
    echo "$0 input_file1.csv [...]"
    exit -1
fi

source ./functions.sh

########################################

SCRIPT1_PYTHON=`myrealpath ${SCRIPT1_PYTHON}`
SCRIPT2_PYTHON=`myrealpath ${SCRIPT2_PYTHON}`
SCRIPT3_PYTHON=`myrealpath ${SCRIPT3_PYTHON}`

for ARG in "$@"
do
    if [ -f "${ARG}" ]; then
	IN_NAME="${ARG}"
	BASENAME=`basename "${IN_NAME}"`

	echo "-- ${BASENAME} --"

	OUTPUT_CAH_NAME="${OUTPUT_CAH_PREFIX}${BASENAME}"
	OUTPUT_MDS_NAME="${OUTPUT_MDS_PREFIX}${BASENAME}"
	OUTPUT_K_MEANS_NAME="${OUTPUT_K_MEANS_PREFIX}${BASENAME}"

	TMP1_IN=`mktemp tmp1.XXXXX`
	TMP1_NO_WORD=`mktemp tmp1.no-word.XXXXX`
	TMP1_TRANSFORMED=`mktemp tmp1.transformed.XXXXX`
	TMP1_DIAG=`mktemp tmp1.diag.XXXXX`
	TMP1_VAL=`mktemp tmp1.VAL.XXXXX`
	TMP1_COMMA=`mktemp tmp1.comma.XXXXX`
	TMP1_CAH_IN=`mktemp tmp1.CAH.in.XXXXX`
	TMP1_MDS_IN=`mktemp tmp1.MDS.in.XXXXX`
	TMP1_K_MEANS_IN=`mktemp tmp1.K-Means.in.XXXXX`
	TMP2_OUT=`mktemp tmp2.XXXXX`

	cp -f "${IN_NAME}" ${TMP1_IN}

	# Remove the word in the terms : just keep the bn:ID
	${AWK} -F ";" -v OFS=";" \
	       -f clean-terms-from-word.awk \
	       ${TMP1_IN} > ${TMP1_NO_WORD}

	#############################
	# Transformations of matrix #
	#############################
	# Matrix of similarity : diagonal at 1 or 100% (object is 100% equal to itself)
	# Matrix of dissimilarity : diagonal at 0 or 0% (object is 0% equal to itself)
	#
	# MDS : requires a dissimalrity matrix (with 0 at diagonal)
	# Similarity to Dissimilarity :
	# SimToDiss Simple : apply (1 - value) on each cell [value between -1 & 1]
        # SimToDiss Complex : (sii + si'i' - 2 * sii')^1/2

	# Apply the similarity to dissimilarity transformation to each cell of the matrix
	${AWK} -F ";" -v OFS=";" \
	       -f ${SIMILARITY_TO_DISSIMILARITY} \
	       ${TMP1_NO_WORD} > ${TMP1_TRANSFORMED}

	# Replace the dot "." in the number by a comma ","
	${SED}  's/\([[:digit:]]\)\.\([[:digit:]]\)/\1,\2/g' \
		 ${TMP1_TRANSFORMED} > ${TMP1_COMMA}

	# Save
	cp -f ${TMP1_NO_WORD} NO-WORD.csv
	cp -f ${TMP1_TRANSFORMED} TRANSFORMED.csv
	#cp -f ${TMP1_DIAG} DIAG.csv
	#cp -f ${TMP1_VAL} VAL.csv
	#cp -f ${TMP1_COMMA} COMMA.csv

	#################################
	# Generate the CAH/Dendrogramme #
	#################################
	#echo "-- ${BASENAME} : CAH / Dendrogram"

	#cp -f ${TMP1_NO_BN} ${TMP1_CAH_IN}

	## Basic call
	##${PYTHON} ${SCRIPT1_PYTHON} ${TMP1_CAH_IN} ${TMP2_OUT}
	## Complex call
	## script.py filename outfile separator XSize YSize dpi
	## Regular print
	##${PYTHON} ${SCRIPT1_PYTHON} ${TMP1_CAH_IN} ${TMP2_OUT} ";" 10 8 300
	## Bigger pic for : Directe, Indirecte, S=M
	#${PYTHON} ${SCRIPT1_PYTHON} ${TMP1_CAH_IN} ${TMP2_OUT} ";" 40 32 300

	########################
	# Generate the K-Means #
	########################
	echo "-- ${BASENAME} : K-Means"

	cp -f ${TMP1_TRANSFORMED} ${TMP1_K_MEANS_IN}

	${PYTHON} ${SCRIPT3_PYTHON} ${TMP1_K_MEANS_IN} ${TMP2_OUT}

	rm -f ${TMP1_IN}
	rm -f ${TMP1_NO_WORD}
	rm -f ${TMP1_TRANSFORMED}
	rm -f ${TMP1_DIAG}
	rm -f ${TMP1_VAL}
	rm -f ${TMP1_COMMA}
	rm -f ${TMP1_CAH_IN}
 	rm -f ${TMP1_MDS_IN}
	rm -f ${TMP1_K_MEANS_IN}
	rm -f ${TMP2_OUT}
    fi
done
