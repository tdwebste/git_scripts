#!/bin/bash
SCRIPT=$(readlink -f ${BASH_SOURCE[0]})
DIR="${SCRIPT%/git_scripts/findbranch.sh}"
source /usr/lib/git-core/git-sh-prompt
__git_ps1
