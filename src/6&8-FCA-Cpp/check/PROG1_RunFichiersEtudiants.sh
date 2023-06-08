#! /bin/sh

INPUT_DIR=FichiersEtudiants

PROGRAM=FCA-1-StrategyPreProcessing

# Obtain the real physical path of an object (file or directory)
myrealpath()
{
    echo $(cd $(dirname "$1") && pwd -P)/$(basename "$1")
}


CWD=`${CWD}`

INPUT_DIR=`myrealpath ${INPUT_DIR}`
PROGRAM=`myrealpath ${PROGRAM}`

LIST_FILES=
for EACHFILE in ${INPUT_DIR}/*
do
#    echo "-- Getting: ${EACHFILE}"
    FILE_BASENAME=`basename "${EACHFILE}"`
    FILE_FULLNAME="${INPUT_DIR}/${FILE_BASENAME}"
    LIST_FILES="${LIST_FILES} ${FILE_FULLNAME}"
    # Tant que ca leak, il faut faire fichier par fichier
    ${PROGRAM} ${FILE_FULLNAME}
done

cd ${CWD}

# Lorsque le programme ne leakera plus, on passera a ca
# exec ${PROGRAM} ${LIST_FILES}
