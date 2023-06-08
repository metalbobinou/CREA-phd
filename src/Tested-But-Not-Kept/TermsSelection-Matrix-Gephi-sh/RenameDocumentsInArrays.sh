#! /bin/sh

OUTPUT_PREFIX=corrected_

function MyUsage()
{
    echo "Usage:"
    echo "$0 File.csv [...] "
    echo ""
}

if [ $# -lt 1 ]; then
    echo "Missing arguments"
    echo ""
    MyUsage
    exit -1
fi

source ./functions.sh

########################################

NUM_FILE=0
for ARG in "$@"
do
    if [ -f "${ARG}" ]; then
        INPUT_NAME="${ARG}"
        INPUT_BASENAME=`basename "${INPUT_NAME}"`
        echo "${INPUT_BASENAME}"

        OUTPUT_NAME="${OUTPUT_PREFIX}${INPUT_BASENAME}"

	TMP1_OUT=`mktemp tmp1.XXXXX`
	TMP2_OUT=`mktemp tmp2.XXXXX`
	TMP3_OUT=`mktemp tmp3.XXXXX`

	cp -f "${INPUT_NAME}" ${TMP1_OUT}

	# Transform the "out_Count_4_parts_included_C1.csv" into "C1"
	${SED} -E 's/;[^;]*(C[0-9]+)\.csv/;\1/g' ${TMP1_OUT} > ${TMP2_OUT}
	# We search for a ";" first, then for any non-; (there are no other ";"
	#  between the ";" and the ".csv" finishing the pattern), next for the
	#  "C" followed by at least 1 number, and ended by a ".csv".
	# As the pattern can be repeated multiple times in the file we use "/g"

	cp -f ${TMP2_OUT} ${OUTPUT_NAME}

	rm -f ${TMP1_OUT}
	rm -f ${TMP2_OUT}
	rm -f ${TMP3_OUT}

    else
        echo "File ${ARG} not found (skipping it)"
    fi
    NUM_FILE=$(( NUM_FILE + 1 ))
done
