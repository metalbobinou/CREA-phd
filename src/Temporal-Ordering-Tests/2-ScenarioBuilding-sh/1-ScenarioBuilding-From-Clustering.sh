#! /bin/sh

OUTPUT_CLUSTERS_PREFIX=scenario_clusters_
OUTPUT_TERMS_PREFIX=scenario_terms_
OUTPUT_UNIQUE_TERMS_PREFIX=scenario_unique_terms_

function MyUsage()
{
    echo "Usage:"
    echo "$0 NbParts Ordered-Fragments-file [...] "
    echo ""
    echo "NbParts : an integer giving the number of parts (NbParts > 0)"
    echo ""
    echo "Format of Fragments-file-union: (1st line Object, 2nd line Attribute, 3rd line Part, ...)"
    echo "Concept ID ; Priority ; Nb P ; Part(s) ; Term1/Part1 [; T2/P2 ; ... ]"
    echo "... ; ... ; ... ; ... "
    echo ""
}

if [ $# -lt 2 ]; then
    echo "Missing arguments"
    echo ""
    MyUsage
    exit -1
fi

source ./functions.sh

########################################

MAX_PARTS=$1

if [ $1 -le 0 ]; then
    echo "NbParts must be positive and not null"
    echo ""
    MyUsage
    exit -1
fi

# Let's skip the number of parts, now
shift

NUM_FILE=0
for ARG in "$@"
do
    if [ -f "${ARG}" ]; then
        INPUT_NAME="${ARG}"
        INPUT_BASENAME=`basename "${INPUT_NAME}"`
        echo "${INPUT_BASENAME}"

        OUTPUT_CLUSTERS_NAME="${OUTPUT_CLUSTERS_PREFIX}${INPUT_BASENAME}"
	OUTPUT_TERMS_NAME="${OUTPUT_TERMS_PREFIX}${INPUT_BASENAME}"
	OUTPUT_UNIQUE_TERMS_NAME="${OUTPUT_UNIQUE_TERMS_PREFIX}${INPUT_BASENAME}"

	CLUSTERS_FILE="${INPUT_NAME}"
	CLUSTERS_TMP=`mktemp tmp0.clusters.XXXXX`
	TMP1_PARTS=`mktemp tmp1.with.parts.XXXXX`
	TMP2_NO_PARTS=`mktemp tmp2.no.parts.XXXXX`
	TMP3_PARTS=`mktemp tmp3.with.parts.XXXXX`
	TMP4_NO_PARTS=`mktemp tmp4.no.parts.XXXXX`
	TMP5_PARTS=`mktemp tmp5.with.parts.XXXXX`
	TMP6_NO_PARTS=`mktemp tmp6.no.parts.XXXXX`
	TMP7_OUT=`mktemp tmp7.XXXXX`
	TMP8_OUT=`mktemp tmp8.XXXXX`
	TMP9_OUT=`mktemp tmp9.XXXXX`
	TMP10_OUT=`mktemp tmp10.XXXXX`
	TMP11_OUT=`mktemp tmp11.XXXXX`
	TMP12_OUT=`mktemp tmp12.XXXXX`
	TMP13_OUT=`mktemp tmp13.XXXXX`
	TMP14_OUT=`mktemp tmp14.XXXXX`

	# Input :
	# Cluster ID ; Priority ; Nb P ; Part(s) ; Term1/Part1 [; T2/P2 ; ... ]

	# Select useful clusters for each part
	#  (select those with one or more part(s))
	${AWK} -v FS=";" -v OFS=";" -v SUB_OFS="," \
	       -v MAX_PARTS="${MAX_PARTS}" -v HEADER="0" \
	       -f select-clusters-with-part.awk \
	       "${CLUSTERS_FILE}" > ${TMP1_PARTS}

	# Select useful clusters for each part
	#  (select those without any part(s))
	${AWK} -v FS=";" -v OFS=";" -v SUB_OFS="," \
	       -v MAX_PARTS="${MAX_PARTS}" -v HEADER="0" \
	       -f select-clusters-without-part.awk \
	       "${CLUSTERS_FILE}" > ${TMP2_NO_PARTS}

	# Copy the clean clusters in a file for future reuse
	${CAT} ${TMP1_PARTS} ${TMP2_NO_PARTS} > ${CLUSTERS_TMP}


	# Input 2 :
	# Cluster ID ; Priority ; Nb P ; Part(s) ; Term1 [; Term2 ; ... ]

	# Change point of view : extract the cluster ID linked to a part
	${AWK} -v FS=";" -v OFS=";" -v SUB_OFS="," \
	       -v MAX_PARTS="${MAX_PARTS}" -v HEADER="0" \
	       -f extract-clusters-per-part.awk \
	       ${TMP1_PARTS} > ${TMP3_PARTS}
	${SORT} -k1,1 ${TMP3_PARTS} > ${TMP5_PARTS}

	# Change point of view for "no parts" : extract the cluster ID in all parts
	${AWK} -v FS=";" -v OFS=";" -v SUB_OFS="," \
	       -v MAX_PARTS="${MAX_PARTS}" -v HEADER="0" \
	       -f extract-clusters-all-parts.awk \
	       ${TMP2_NO_PARTS} > ${TMP4_NO_PARTS}
	${SORT} -k1,1 ${TMP4_NO_PARTS} > ${TMP6_NO_PARTS}


	# Intermediate output :
        # Part ; Nb Clusters ; ID Cluster 1 ; ID Cluster 2 ; ..

	# No need for merge : clusters are already separated by parts/no parts)

	# No need for priorization : clusters are already sorted by importance

	# Distribute the "no parts" clusters into the parts  (at end)
	#  -- it respects priorization --
	${AWK} -v FS=";" -v OFS=";" -v SUB_OFS="," \
	       -v MAX_PARTS="${MAX_PARTS}" \
	       -f merge-selected-fragments-in-parts.awk \
	       ${TMP5_PARTS} ${TMP6_NO_PARTS} > ${TMP7_OUT}

	# Intermediate output :
	# Part ; Nb Clusters ; ID Cluster 1 ; ID Cluster 2 ; ...

	# Transpose CSV for pretty print (column will describe content)
	${AWK} -v FS=";" -v SEP=";" \
	       -f transpose-csv.awk \
	       ${TMP7_OUT} > ${TMP8_OUT}

	cp -f ${TMP8_OUT} "${OUTPUT_CLUSTERS_NAME}"

        # Replace
	${AWK} -v FS=";" -v OFS=";" -v SUB_OFS="," \
	       -v MAX_PARTS="${MAX_PARTS}" -v HEADER="0" \
               -f replace-clusters-by-terms-vertical.awk \
               ${CLUSTERS_TMP} ${TMP8_OUT} > ${TMP9_OUT}

	cp -f ${TMP9_OUT} "${OUTPUT_TERMS_NAME}"

	# Output :
	#      Part 0    |     Part 1    |     Part 2    |     Part 3
	#   Nb Clusters  |  Nb Clusters  |  Nb Clusters  |   Nb Clusters
	#    Cluster 1   |   Cluster 1   |   Cluster 4   | [Unordered Cluster]
	#   [Unordered]  |   Cluster 2   |   Cluster 2   |
	#                |   Cluster 3   |  [Unordered]  |
	#                |  [Unordered]  |


	############ Unique terms processing

	# Transpose CSV for pretty print (column will describe content)
        ${AWK} -v FS=";" -v SEP=";" \
               -f transpose-csv.awk \
               ${TMP9_OUT} > ${TMP10_OUT}

	# Transform SUB_OFS into OFS
	${AWK} -v FS=";" -v OFS=";" -v SUB_OFS="," \
               -f extract-sub-ofs.awk \
	       ${TMP10_OUT} > ${TMP11_OUT}

	# Remove similar terms
	${AWK} -v FS=";" -v OFS=";" \
               -f remove-duplicate-terms.awk \
	       ${TMP11_OUT} > ${TMP12_OUT}

	# Count terms
	${AWK} -v FS=";" -v OFS=";" \
	       -f count-terms.awk \
	       ${TMP12_OUT} > ${TMP13_OUT}

	# Transpose back
	${AWK} -v FS=";" -v SEP=";" \
               -f transpose-csv.awk \
               ${TMP13_OUT} > ${TMP14_OUT}

	cp -f ${TMP14_OUT} "${OUTPUT_UNIQUE_TERMS_NAME}"

	# Output :
	#      Part 0    |     Part 1    |     Part 2    |     Part 3
	#   Nb Clusters  |  Nb Clusters  |  Nb Clusters  |   Nb Clusters
	#     Nb Terms   |    Nb Terms   |    Nb Terms   |     Nb Terms
	#      Word 1    |     Word 1    |     Word 4    |      Word 5
	#      Word 5    |     Word 2    |     Word 2    |
	#                |     Word 3    |     Word 5    |
	#                |     Word 5    |


	rm -f ${CLUSTERS_TMP}
	rm -f ${TMP1_PARTS}
	rm -f ${TMP2_NO_PARTS}
	rm -f ${TMP3_PARTS}
	rm -f ${TMP4_NO_PARTS}
	rm -f ${TMP5_PARTS}
	rm -f ${TMP6_NO_PARTS}
	rm -f ${TMP7_OUT}
	rm -f ${TMP8_OUT}
	rm -f ${TMP9_OUT}
	rm -f ${TMP10_OUT}
	rm -f ${TMP11_OUT}
	rm -f ${TMP12_OUT}
	rm -f ${TMP13_OUT}
	rm -f ${TMP14_OUT}
    else
        echo "File ${ARG} not found (skipping it)"
    fi
    NUM_FILE=$(( NUM_FILE + 1 ))
done
