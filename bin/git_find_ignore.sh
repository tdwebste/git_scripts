#!/usr/bin/env bash

set -u

repo="${1:-.}"

if ! top=$(git -C "$repo" rev-parse --show-toplevel 2>/dev/null); then
    echo "ERROR: '$repo' is not inside a Git working tree" >&2
    exit 1
fi

top=$(cd "$top" && pwd -P)

git_dir=$(
    git -C "$top" rev-parse \
        --path-format=absolute \
        --git-dir
)

common_dir=$(
    git -C "$top" rev-parse \
        --path-format=absolute \
        --git-common-dir
)

info_exclude=$(
    git -C "$top" rev-parse \
        --path-format=absolute \
        --git-path info/exclude
)

show_file_status()
{
    local file="$1"

    if [[ -f "$file" ]]; then
        printf 'EXISTS:  %s\n' "$file"
    else
        printf 'MISSING: %s\n' "$file"
    fi
}

echo "===== REPOSITORY ====="
echo "Working tree: $top"
echo "Git directory: $git_dir"
echo "Common Git directory: $common_dir"

echo
echo "===== .gitignore FILES ====="

found=0

while IFS= read -r -d '' file; do
    printf '%s\n' "$file"
    found=1
done < <(
    find "$top" \
        -type d -name '.git' -prune -o \
        -type f -name '.gitignore' -print0
)

if (( found == 0 )); then
    echo "None found"
fi

echo
echo "===== REPOSITORY info/exclude ====="
show_file_status "$info_exclude"

echo
echo "===== CONFIG DEFINITIONS AND INCLUDES ====="

if ! git -C "$top" config \
        --includes \
        --show-origin \
        --show-scope \
        --get-regexp \
        '^(core\.excludesfile|include\.path|includeif\..*\.path)$'
then
    echo "No core.excludesFile or include directives found"
fi

echo
echo "===== EFFECTIVE GLOBAL EXCLUDE FILE ====="

if effective_exclude=$(
    git -C "$top" config \
        --includes \
        --path \
        --get core.excludesFile 2>/dev/null
); then
    if [[ -z "$effective_exclude" ]]; then
        echo "core.excludesFile is explicitly empty"
    else
        # Relative core.excludesFile paths are interpreted relative
        # to the directory from which Git is run.
        if [[ "$effective_exclude" != /* ]]; then
            effective_exclude="$top/$effective_exclude"
        fi

        show_file_status "$effective_exclude"
    fi
else
    default_exclude="${XDG_CONFIG_HOME:-$HOME/.config}/git/ignore"
    echo "core.excludesFile is not explicitly configured"
    echo "Using Git default:"
    show_file_status "$default_exclude"
fi

echo
echo "===== TRANSIENT COMMAND-LINE RULES ====="
echo "Command-line --exclude, --exclude-from and -e rules"
echo "cannot be discovered after the command finishes."
