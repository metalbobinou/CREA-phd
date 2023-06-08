#! /bin/sh

OUTPUT_PREFIX=final_

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

if [ "$#" != "2" ]; then
    OUTPUT_FILE=${OUTPUT_PREFIX}${INPUT_FILE}
else
    OUTPUT_FILE=$2
fi

source ./functions.sh

#######################################

${AWK} -v OFS="\t" -f choose-morph-rules-FR.awk  \
    ${INPUT_FILE} > ${OUTPUT_FILE}
