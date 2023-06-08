#! /bin/sh

COMMON_PREFIX=/Users/metalman/svn/these/Experiences/CourseContentComparator
#COMMON_PREFIX=/home/metalman/svn/these/Experiences/CourseContentComparator

PHP_DIR=${COMMON_PREFIX}/Matrix-PHP
PHP_EXEC=${PHP_DIR}/main.php
DISAMBIGUATE_DIR=${COMMON_PREFIX}/3-disambiguated/statecharts-content-tagged
MATRIX_DIR=${COMMON_PREFIX}/5-input-matrix
SCRIPTS_DIR=${COMMON_PREFIX}/RunningScripts-sh

PHP_EXEC=${PHP_EXEC}
PHP_DIR=${PHP_DIR}
INPUT_DIR=${DISAMBIGUATE_DIR}
OUTPUT_DIR=${MATRIX_DIR}

CWD=`pwd`

##############

echo "# Matrixification started"

source ${SCRIPTS_DIR}/Step3.sh

matrixprocessfolder

echo "# Matrixification finished"
