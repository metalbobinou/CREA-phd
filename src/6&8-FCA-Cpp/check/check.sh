#! /bin/sh

LOGFILE=diff-log

PROG1=FCA-1-StrategyPreProcessing
PROG2=FCA-3-FragmentsExtraction
PROG3=FCA-4-Measures
PROG4=FCA-5-Generalisation

SCRIPT1_1=FCA-Strategy-KIP-CompareDirs.sh
SCRIPT1_2=FCA-Strategy-Etudiants-CompareDirs.sh
TMP_DIR1=FichiersStrategies

SCRIPT2_1=FCA-FragmentsExtraction-Etudiants-CompareDirs.sh
TMP_DIR2_1=InterTreillis

SCRIPT3_1=FCA-Measures-Etudiants-CompareDirs.sh
TMP_DIR3_1=Comparaison

cp ../${PROG1} ./
cp ../${PROG2} ./
cp ../${PROG3} ./

RETURN_VALUE=0
LAST_OK=1

##############################################################

# 1st program (Strategy)
./${PROG1} KIP/out_matrix.csv
sh ${SCRIPT1_1} > ${LOGFILE}.1_1.log
RETURN_VALUE=`expr ${RETURN_VALUE} + $?`
if [ "${RETURN_VALUE}" = "0" ]; then
    echo "## Test 1 (1) : SUCCESS"
    rm -f ${LOGFILE}.1_1.log
    LAST_OK="1-1"
else
    echo "!! Test 1 (1) : FAIL"
fi
rm -rf ${TMP_DIR1}

####

sh PROG1_RunFichiersEtudiants.sh
sh ${SCRIPT1_2} > ${LOGFILE}.1_2.log
RETURN_VALUE=`expr ${RETURN_VALUE} + $?`
if [ "${RETURN_VALUE}" = "0" ]; then
    echo "## Test 1 (2) : SUCCESS"
    rm -f ${LOGFILE}.1_2.log
    LAST_OK="1-2"
else
    echo "!! Test 1 (2) : FAIL"
fi
rm -rf ${TMP_DIR1}

##############################################################

# 2nd program (FragmentExports)
sh PROG2_RunFichiersEtudiants.sh
sh ${SCRIPT2_1} > ${LOGFILE}.2_1.log
RETURN_VALUE=`expr ${RETURN_VALUE} + $?`
if [ "${RETURN_VALUE}" = "0" ]; then
    echo "## Test 2 (1) : SUCCESS"
    rm -f ${LOGFILE}.2_1.log
    LAST_OK="2-1"
else
    echo "!! Test 2 (1) : FAIL"
fi
rm -rf ${TMP_DIR2_1}

##############################################################

# 3rd program (Measures)
sh PROG3_RunFichiersEtudiants.sh
sh ${SCRIPT3_1} > ${LOGFILE}.3_1.log
RETURN_VALUE=`expr ${RETURN_VALUE} + $?`
if [ "${RETURN_VALUE}" = "0" ]; then
    echo "## Test 3 (1) : SUCCESS"
    rm -f ${LOGFILE}.3_1.log
    LAST_OK="3-1"
else
    echo "!! Test 3 (1) : FAIL"
fi
rm -rf ${TMP_DIR3_1}

##############################################################

# 4th program (Generalisation)

##############################################################

rm -f ${PROG1}
rm -f ${PROG2}
rm -f ${PROG3}

if [ "${RETURN_VALUE}" = "0" ]; then
    echo ""
    echo "############################"
    echo "## SUCCESS ON ALL TESTS ! ##"
    echo "############################"
    echo ""
else
    echo ""
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo "!! FAILURE AFTER TEST ${LAST_OK} !!"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo ""
fi
