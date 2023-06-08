#! /bin/sh

# Useful functions (like "realpath")
source ${SCRIPTS_DIR}/useful.sh

# Process all the files in the "input" directory with the "php program"
matrixprocessfolder()
{
    PHP_EXEC=`myrealpath ${PHP_EXEC}`
    PHP_DIR=`myrealpath ${PHP_DIR}`
    INPUT_DIR=`myrealpath ${INPUT_DIR}`
    OUTPUT_DIR=`myrealpath ${OUTPUT_DIR}`
    CWD=`myrealpath $CWD`

    if [ ! -d ${OUTPUT_DIR} ]; then
	mkdir -p ${OUTPUT_DIR}
    fi

    echo "# Gathering input files from folder: ${INPUT_DIR}/*"

    MATRIX_DATA=
    for EACHFILE in ${INPUT_DIR}/*
    do
	FILE_BASENAME=`basename ${EACHFILE}`
	FULL_FILENAME="${INPUT_DIR}/${FILE_BASENAME}"
	MATRIX_DATA="${MATRIX_DATA} ${FULL_FILENAME}"
    done

    echo "# Processing PHP program"

    cd ${PHP_DIR}
    php ${PHP_EXEC} ${MATRIX_DATA}
    mv -f "out_matrix.csv" ${OUTPUT_DIR}
    cd ${CWD}
}
