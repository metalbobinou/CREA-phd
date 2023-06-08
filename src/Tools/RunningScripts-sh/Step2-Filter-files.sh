#! /bin/sh

COMMON_PREFIX=/Users/metalman/svn/these/Experiences/CourseContentComparator
#COMMON_PREFIX=/home/metalman/svn/these/Experiences/CourseContentComparator

PHP_DIR=${COMMON_PREFIX}/FilterWordList-PHP
PHP_EXEC=${PHP_DIR}/main.php
DISAMBIGUATE_DIR=${COMMON_PREFIX}/3-disambiguated/PHP-automatic
FILTERED_DIR=${COMMON_PREFIX}/4-scored-filtered
SCRIPTS_DIR=${COMMON_PREFIX}/RunningScripts-sh

PHP_EXEC=${PHP_EXEC}
PHP_DIR=${PHP_DIR}
INPUT_DIR=${DISAMBIGUATE_DIR}
OUTPUT_DIR=${FILTERED_DIR}

CWD=`pwd`

##############

echo "# Filtering started"

source ${SCRIPTS_DIR}/Step2.sh

filterprocessfolder

echo "# Filtering finished"
