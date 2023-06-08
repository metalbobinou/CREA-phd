#! /bin/sh

OUTPUT_PREFIX=fragments_

OUTPUT_ATTR=ATTR_
OUTPUT_OBJ=OBJ_

if [ $# -lt 1 ]; then
    echo "Missing arguments"
    echo ""
    echo "Usage:"
    echo "$0 file1 [files] ..."
    echo ""
    echo "Filter the fragments based on rules (at least 2 objects)"
    exit -1
fi

source ./functions.sh

#########################

NUM_FILE=0
for ARG in "$@"
do
    if [ -f "${ARG}" ]; then
        INPUT_NAME="${ARG}"
        INPUT_BASENAME=`basename "${INPUT_NAME}"`
        echo "${INPUT_BASENAME}"

	OUTPUT_OBJ_NAME="${OUTPUT_PREFIX}${OUTPUT_OBJ}${INPUT_BASENAME}"
	OUTPUT_ATTR_NAME="${OUTPUT_PREFIX}${OUTPUT_ATTR}${INPUT_BASENAME}"
	OUTPUT_NAME="${OUTPUT_PREFIX}${INPUT_BASENAME}"

	TMP1_OBJ_OUT=`mktemp tmp1.OBJ.XXXXX`
	TMP1_ATTR_OUT=`mktemp tmp1.ATTR.XXXXX`
	TMP2_OBJ_OUT=`mktemp tmp2.OBJ.XXXXX`
	TMP2_ATTR_OUT=`mktemp tmp2.ATTR.XXXXX`
	TMP3_OUT=`mktemp tmp3.XXXXX`
	TMP4_OUT=`mktemp tmp4.XXXXX`

	# We filter the "Attributes"
	${AWK} -v FS=";" -v OFS=";" -v FILTERED="Attributes" \
	       -f filter-3rd-col.awk  \
	       "${INPUT_NAME}" > ${TMP1_ATTR_OUT}

	# We keep the "Objects"
	${AWK} -v FS=";" -v OFS=";" -v FILTERED="Objects" \
	       -f filter-3rd-col.awk  \
	       "${INPUT_NAME}" > ${TMP1_OBJ_OUT}

	# We keep the not null "Objects"
	${AWK} -v FS=";" -v OFS=";" \
	       -f filter-null-and-few-attributes.awk  \
	       ${TMP1_OBJ_OUT} > ${TMP2_OBJ_OUT}

	# We keep the associated "Attributes" to the filtered "Objects"
	${AWK} -v FS=";" -v OFS=";" \
	       -f filter-attributes-by-objects.awk  \
	       ${TMP2_OBJ_OUT} ${TMP1_ATTR_OUT} > ${TMP2_ATTR_OUT}

	# We join back the Objects first, and the Attribute next
	${AWK} -v FS=";" -v OFS=";" \
	       -f join-objects-attributes.awk  \
	       ${TMP2_OBJ_OUT} ${TMP2_ATTR_OUT} > ${TMP3_OUT}

	# Transform the "included_C1.csv" into "C1"
	${SED} -E 's/;[^;]*(C[0-9]+)\.csv/;\1/g' ${TMP3_OUT} > ${TMP4_OUT}
	# We search for a ";" first, then for any non-; (there are no other ";"
	#  between the ";" and the ".csv" finishing the pattern), next for the
	#  "C" followed by at least 1 number, and ended by a ".csv".
	# As the pattern can be repeated multiple times in the file we use "/g"

  # Concept ID ; Level ; Type Obj/Attr ; Nb O ; Nb A ; Obj1/Attr1 ; O/A2 ; ...

	mv -f ${TMP2_OBJ_OUT} "${OUTPUT_OBJ_NAME}"
	mv -f ${TMP2_ATTR_OUT} "${OUTPUT_ATTR_NAME}"
	mv -f ${TMP4_OUT} "${OUTPUT_NAME}"

	rm -f ${TMP1_OBJ_OUT}
	rm -f ${TMP1_ATTR_OUT}
	rm -f ${TMP2_OBJ_OUT}
	rm -f ${TMP2_ATTR_OUT}
	rm -f ${TMP3_OUT}
	rm -f ${TMP4_OUT}
    fi
    NUM_FILE=$(( NUM_FILE + 1 ))
done
