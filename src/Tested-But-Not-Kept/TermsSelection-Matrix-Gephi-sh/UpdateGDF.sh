#! /bin/sh

function myusage()
{
    echo "Usage:"
    echo "$0 reference-file GDF-to-modify-1 [GDF-to-modify-2 ...]"
    echo ""
    echo "Format of reference-file (lines_* or new_lines_*):"
    echo "ID ; text"
    echo "N1 ; expression"
    echo "N2 ; another expression"
    echo "... ; ..."
}

if [ $# -lt 2 ]; then
    echo "Missing arguments"
    echo ""
    myusage
    exit -1
fi

source ./functions.sh

#########################

if [ -f "$1" ] && [ -f "$2" ]; then
    REFERENCE_FILE="$1"
    # Work on data files only, now
    shift

    for ARG in $@
    do
	if [ -f "${ARG}" ]; then
	    INPUT_NAME="${ARG}"
	    INPUT_BASENAME=`basename "${INPUT_NAME}"`
	    echo "${INPUT_BASENAME}"

	    OUTPUT_NAME="${INPUT_NAME}"

	    TMP1_OUT=`mktemp tmp1.XXXXX`
	    TMP2_OUT=`mktemp tmp2.XXXXX`

	    ### CHANGE OFS OF REF-FILE (from ";" to ",")
	    ${AWK} -F ";" -v OFS="," \
		   '{ for (i = 1; i <= NF; i++) {printf("%s%s", $i, OFS)} printf("\n") }' \
		   ${REFERENCE_FILE} > ${TMP1_OUT}

	    ### REPLACE DATA
	    # Replace occurrences of expressions from the 2nd column of ref file
	    ${AWK} -F "," -v OFS="," -v SUB_OFS="," \
		   -f replace-ID-by-ref-2nd-col-GDF-nodedef.awk \
		   ${TMP1_OUT} "${INPUT_NAME}" > ${TMP2_OUT}

	    cp -f ${TMP2_OUT} "${OUTPUT_NAME}"

	    rm -f ${TMP1_OUT}
	    rm -f ${TMP2_OUT}
	fi
    done
else
    echo "Reference file or File to modify do not exist"
    echo "Try again with existing file"
    echo ""
    myusage
    exit -2
fi
