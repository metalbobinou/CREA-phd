#! /bin/sh

DIR2_1=Comparaison
DIR2_2=Comparaison-Etudiants-OK

REF_DIR2=${DIR2_1}
DIFF_DIR2=${DIR2_2}

RETURN_VALUE=0

# Required function for later
myrealpath()
{
    echo $(cd $(dirname "$1") && pwd -P)/$(basename "$1")
}

REF_DIR2=`myrealpath ${REF_DIR2}`
DIFF_DIR2=`myrealpath ${DIFF_DIR2}`

for EACHFILE in ${REF_DIR2}/*
do
    FILENAME=`basename ${EACHFILE}`
    echo "- Processing: ${FILENAME}"
    diff ${REF_DIR2}/${FILENAME} ${DIFF_DIR2}/${FILENAME}
    RETURN_VALUE=`expr ${RETURN_VALUE} + $?`
    echo "#########################"
done

if [ "${RETURN_VALUE}" != "0" ]; then
    echo "ERROR ! Files are different in dir: ${DIR2_1}"
else
    echo "CHECK PASSED SUCCESFULLY FOR DIR: ${DIR2_1} !"
fi

exit ${RETURN_VALUE}
