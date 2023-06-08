#! /bin/sh

# Useful functions (like "realpath")
source ${SCRIPTS_DIR}/useful.sh

# Process each file in the "input" directory with the "php program"
filterprocessfolder()
{
    PHP_EXEC=`myrealpath ${PHP_EXEC}`
    PHP_DIR=`myrealpath ${PHP_DIR}`
    INPUT_DIR=`myrealpath ${INPUT_DIR}`
    OUTPUT_DIR=`myrealpath ${OUTPUT_DIR}`
    CWD=`myrealpath $CWD`

    if [ ! -d ${OUTPUT_DIR} ]; then
	mkdir -p ${OUTPUT_DIR}
    fi

    echo "# Processing input files from folder: ${INPUT_DIR}/*"

    cd ${PHP_DIR}
    for EACHFILE in ${INPUT_DIR}/*
    do
	FILE_BASENAME=`basename ${EACHFILE}`
	FILENAME="${INPUT_DIR}/${FILE_BASENAME}"
	php ${PHP_EXEC} ${FILENAME}
	OUTFILE_INCL="included_${FILE_BASENAME}"
	OUTFILE_EXCL="excluded_${FILE_BASENAME}"
	mv -f ${OUTFILE_INCL} ${OUTPUT_DIR}
	mv -f ${OUTFILE_EXCL} ${OUTPUT_DIR}
    done
    cd ${CWD}
}
