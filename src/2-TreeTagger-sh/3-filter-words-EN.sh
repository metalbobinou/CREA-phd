#! /bin/sh

OUTPUT_PREFIX=filtered_

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

# Types de mots a filtrer
TMP_INPUT=`mktemp tmp_input.XXXXX`

# Methode 1 : declaration des types dans une variable
# On indique les types de mots que l'on veut supprimer
#FILTERED_CLASS="PRO:PER DET:ART PRP"
#echo ${FILTERED_CLASS} |                  \
# ${SED} -E 's/([![:space:]]+)/\1\n&/g' |  \
# tr -d " " > ${TMP_INPUT}

# Methode 2 : declaration des types dans un fichier
# On garde avec awk les types de mots que l'on veut supprimer : les non 0
${AWK} -v OFS="\t"   \
 '{
    if ($2 != 0)
      print $1;
  }'                 \
      filter-class-EN.txt > ${TMP_INPUT}

#   filter-class-EN-BNC.txt > ${TMP_INPUT}

#cat -e ${TMP_INPUT}

${AWK} -v OFS="\t" -f filter-words.awk         \
    ${TMP_INPUT} ${INPUT_FILE} > ${OUTPUT_FILE}

rm -f ${TMP_INPUT}
