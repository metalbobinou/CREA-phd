#! /bin/sh

function MyUsage()
{
    echo "Usage:"
    echo "$0 ConceptualWeighTerms.csv"
    echo ""
    echo "Format of ConceptualWeighTerms.csv:"
    echo "Name bn:ID ; Conceptual Weigh"
    echo "... ; ... "
}

if [ $# -ne 1 ]; then
    echo "1 argument is required. 1 and not more."
    echo ""
    MyUsage
    exit -1
fi

source ./functions.sh

########################################

INPUT_NAME=$1

if [ ! -f "${INPUT_NAME}" ]; then
    echo "File ${INPUT_NAME} does not exist"
    echo ""
    MyUsage
    exit -1
fi

INPUT_BASENAME=`basename "${INPUT_NAME}"`

#OUTPUT_NAME="${OUTPUT_PREFIX}${INPUT_BASENAME}"

TMP1_OUT=`mktemp tmp1.XXXXX`
TMP2_OUT=`mktemp tmp2.XXXXX`
TMP3_OUT=`mktemp tmp3.XXXXX`
TMP4_OUT=`mktemp tmp4.XXXXX`

cp -f "${INPUT_NAME}" ${TMP1_OUT}

# INPUT_NAME :
# "Name bn:ID ; Conceptual Weight"

${AWK} -v FS=";" -v OFS=";" \
       '{
       CUR_WORD = "\"" $1 "\"";
       BN_ID_POS = match(CUR_WORD, / [^ ]*$/);
       BN_ID_BRUT = substr(CUR_WORD, RSTART, RLENGTH);
       BN_ID = substr(BN_ID_BRUT, 2, (length(BN_ID_BRUT) - 2));

       # Convert the string to a number
       CONCEPTUAL_WEIGHT = $2 + 0;

       if (CONCEPTUAL_WEIGHT >= 0.25)
       {
         printf("%s%s%s%s%s\n", CUR_WORD, OFS, BN_ID, OFS, CONCEPTUAL_WEIGHT);
       }
        }' \
       ${TMP1_OUT} > ${TMP2_OUT}

# "\"Name bn:ID\" ; bn:ID ; Conceptual Weight

# Sort parts by BN_ID first, and then by parts number
#${SORT} -t";" -k1,3 "${ORDERING_NAME}" > ${ORDERED_PARTS}

cat ${TMP2_OUT}

rm -f ${TMP1_OUT}
rm -f ${TMP2_OUT}
rm -f ${TMP3_OUT}
rm -f ${TMP4_OUT}
