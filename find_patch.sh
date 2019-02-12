
filename="$1"

git blame -e $filename |awk '/nvidia/ { print $1 }' | sort -u | grep -vP "$(git blame -e v4.4.165_b -- $filename |awk '/nvidia/ { print $1 }' | sort -u | tr '\n' '|' | sed -e 's/.$//')" >/tmp/patch.lst

git show $(cat /tmp/patch.lst) --pretty="format:%at %ai %aE %H" --no-patch | sort | awk '{ print $NF }'




