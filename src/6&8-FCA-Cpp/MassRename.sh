#! /bin/sh

INPUT_DIR=FichiersStrategies-KIP-txt-OK
OUTPUT_DIR=FichiersStrategies-lol

PIVOT=E

PREFIX="${PIVOT}*"
SUFFIX="*${PIVOT}"

# Required function for later
myrealpath()
{
    echo $(cd $(dirname "$1") && pwd -P)/$(basename "$1")
}

INPUT_DIR=`realpath ${INPUT_DIR}`
OUTPUT_DIR=`realpath ${OUTPUT_DIR}`

if [ ! -d ${OUTPUT_DIR} ]; then
    mkdir -p ${OUTPUT_DIR}
fi

for EACHFILE in ${INPUT_DIR}/*
do
    BASENAME=`basename ${EACHFILE}`
    PREFIX_NAME=${BASENAME%%${PREFIX}}
    SUFFIX_NAME=${BASENAME##${SUFFIX}}
    NEWNAME=out_matrix.csv${SUFFIX_NAME}
    echo "${BASENAME} : ${NEWNAME} : ${PREFIX_NAME}  -  ${SUFFIX_NAME}"
    #cp ${EACHFILE} ${OUTPUT_DIR}/${NEWNAME}
done
