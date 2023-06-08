#! /bin/sh

DIR1=FichiersStrategies
DIR2=FichiersStrategies-Etudiants-OK


REF_DIR=${DIR1}
DIFF_DIR=${DIR2}

RETURN_VALUE=0

# Required function for later
myrealpath()
{
    echo $(cd $(dirname "$1") && pwd -P)/$(basename "$1")
}

REF_DIR=`myrealpath ${REF_DIR}`
DIFF_DIR=`myrealpath ${DIFF_DIR}`

for EACHFILE in ${REF_DIR}/*
do
    FILENAME=`basename ${EACHFILE}`
    echo "- Processing: ${FILENAME}"
    diff ${REF_DIR}/${FILENAME} ${DIFF_DIR}/${FILENAME}
    RETURN_VALUE=`expr ${RETURN_VALUE} + $?`
    echo "#########################"
done

if [ "${RETURN_VALUE}" != "0" ]; then
    echo "ERROR ! Files are different"
else
    echo "CHECK PASSED SUCCESFULLY !"
fi

exit ${RETURN_VALUE}
