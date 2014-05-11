#!/bin/bash

echo 'C_SOURCE_FILES += main.c'
grep '<FilePath>'  *.uvproj | sort -u \
	| grep -v 'arm_startup_nrf51.s' \
	| grep -v 'main.c' \
	| grep -v 'system_nrf51.c' \
	| sed -e 's#<FilePath>##' \
	-e 's#</FilePath>##' \
	-e 's#^[ 	]*#C_SOURCE_FILES += #' \
	| tr '\' '/' 2>/dev/null

echo ''
grep '<IncludePath>'  *.uvproj \
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

