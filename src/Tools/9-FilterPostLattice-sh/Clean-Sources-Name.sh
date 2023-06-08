#! /bin/sh

OUTPUT_PREFIX=clean_

# Clean the sources files (specific to the PHP courses case)

function MyUsage()
{
    echo "Usage:"
    echo "$0 Stats-File.csv"
    echo ""
    echo "Format of Stats-File:"
    echo "Name ; bn:ID ; Part ; File1 [; File 2 ; ... ]"
    echo "\"cours bn:00076429n\" ; bn:00076429n ; 0 ; out_C1.csv ; out_C3.csv"
    echo "... ; ... ; ... ; ... "
}

if [ $# -ne 1 ]; then
    echo "Missing arguments"
    echo ""
    MyUsage
    exit -1
fi

source ./functions.sh

#########################

if [ -f "$1" ]; then
    INPUT_NAME="$1"
    INPUT_BASENAME=`basename "${INPUT_NAME}"`
    echo "${INPUT_BASENAME}"

    OUTPUT_NAME="${OUTPUT_PREFIX}${INPUT_BASENAME}"

    TMP1_OUT=`mktemp tmp1.XXXXX`

    # Transform the "out_Count_4_parts_included_C1.csv" into "C1"
    ${SED} -E 's/;[^;]*(C[0-9]+)\.csv/;\1/g' "${INPUT_NAME}" > ${TMP1_OUT}
    # We search for a ";" first, then for any non-; (there are no other ";"
    #  between the ";" and the ".csv" finishing the pattern), next for the
    #  "C" followed by at least 1 number, and ended by a ".csv".
    # As the pattern can be repeated multiple times in the file we use "/g"

    # Write back results
    cp -f ${TMP1_OUT} "${OUTPUT_NAME}"

    rm -f ${TMP1_OUT}
fi
