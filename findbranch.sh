#!/bin/bash
SCRIPT=$(readlink -f ${BASH_SOURCE[0]})
DIR="${SCRIPT%/git_scripts/findbranch.sh}"
. $DIR/git/contrib/completion/git-prompt.sh
__git_ps1
