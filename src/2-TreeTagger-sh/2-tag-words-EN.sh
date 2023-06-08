#! /bin/sh

OUTPUT_PREFIX=tagged_

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

#####################

DICO=english.par
#DICO=english-bnc.par

FULL_TT_PATH=`myrealpath ${TT_PATH}`
DICO_PATH=${TT_PATH}/lib/${DICO}


#${TT_PATH}/bin/tree-tagger input.txt output.txt

#${TT_PATH}/bin/tree-tagger -token -lemma ${DICO_PATH} input.txt output.txt

${FULL_TT_PATH}/bin/tree-tagger -token -lemma ./${TT_PATH}/lib/${DICO} ${INPUT_FILE} ${OUTPUT_FILE}
