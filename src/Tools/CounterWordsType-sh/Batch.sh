#! /bin/sh

SCRIPT_SHELL=CounterWordsType.sh

REF_DIR=refs
REF_LIST=RequiredWords-bn.txt,IT-Experts-bn.txt,IT-Students-bn.txt,Non-Experts-bn.txt

DATA_DIR=data

for DATA_FILE in ${DATA_DIR}/*
do
    echo "${DATA_FILE}"
    OLD_IFS=${IFS}
    IFS=','
    for REF in ${REF_LIST}
    do
	REF_FILE=${REF_DIR}/${REF}
	sh ${SCRIPT_SHELL} ${REF_FILE} ${DATA_FILE}
	echo ""
	echo "####"
	echo ""
    done
    echo "#######################################################"
    echo "#######################################################"
    echo "#######################################################"
    echo ""
    IFS=${OLD_IFS}
done
