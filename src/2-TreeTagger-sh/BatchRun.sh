#! /bin/sh

INPUT_DIR=1-input/tableofcontent
OUTPUT_DIR=2-tagged


INPUT_DIR=../${INPUT_DIR}
OUTPUT_DIR=../${OUTPUT_DIR}/

for EACHFILE in ${INPUT_DIR}/*
do
    echo "-- Processing: ${EACHFILE}"
    FILE_BASENAME=`basename ${EACHFILE}`
    FILE_FINAL_NAME="tagged_${FILE_BASENAME}.txt"
    ### java, jar, executable, langue, fichier                              
    sh 0-run.sh ${EACHFILE} ${FILE_FINAL_NAME}
    mv -f ${FILE_FINAL_NAME} ${OUTPUT_DIR}
done
