#!/bin/bash

uvprojfile="$1"

echo '
# check the TARGET_CHIP and BOARD
TARGET_CHIP := NRF51822_QFAA_CA
BOARD := BOARD_PCA10001
'

echo '
# check CFAGS remove extra -DNRF51 -DDEBUG_NRF_USER
CFLAGS += -DNRF51822_QFAA_CA'
grep '<Define>'  $uvprojfile | sort -u \
	| sed -e 's#<Define>##' \
	-e 's#</Define>##' \
	| grep -v '^[ 	]*$' \
	| sed -e 's#  *# -D#g' \
	-e 's#^[ 	]*#CFLAGS += #'


echo ''
echo 'C_SOURCE_FILES += main.c'
grep '<FilePath>'  $uvprojfile | sort -u \
	| grep -v 'arm_startup_nrf51.s' \
	| grep -v 'main.c' \
	| grep -v 'system_nrf51.c' \
	| sed -e 's#<FilePath>##' \
	-e 's#</FilePath>##' \
	-e 's#^[ 	]*#C_SOURCE_FILES += #' \
	| tr '\' '/' 2>/dev/null

echo ''
grep '<IncludePath>' $uvprojfile  \
	| sed -e 's#<IncludePath>##' \
	-e 's#</IncludePath>##' \
	| grep -v '^[ 	]*$' \
	| sort -u \
	| tr ';' '\n' \
	| grep -v 'Include[ 	]*$' \
	| grep -v '\.\.[ 	]*$' \
	| sed  -e 's#^[ 	]*#-I"#' \
	-e 's#[ 	]*$#"#' \
	-e 's#^[ 	]*#INCLUDEPATHS += #' \
	| tr '\' '/' 2>/dev/null

echo ''
#grep '<TargetName>' $uvprojfile  \
#	| sed -e 's#<TargetName>##' \
#	-e 's#</TargetName>##' \
#	| grep -v '^[ 	]*$' \
#	| head -1 \
#	| sed -e 's#^[ 	]*##' \
#	-e 's#[ 	].*##' \
#	-e 's#^#OUTPUT_FILENAME := #' \
#	-e 's#$#_gcc#'

echo "$uvprojfile" | sed -e 's#\.uvproj#_gcc#' \
	-e 's#^#OUTPUT_FILENAME := #' 

echo '
SDK_PATH = ../../../../../

DEVICE_VARIANT := xxaa
#DEVICE_VARIANT := xxab

USE_SOFTDEVICE := S110
#USE_SOFTDEVICE := s210

include $(SDK_PATH)Source/templates/gcc/Makefile.common
'



