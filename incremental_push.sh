rp="$1"

git log --pretty=oneline --reverse | awk '{print $1}' > commits.txt

i=1
tot_commits=`wc -l commits.txt | cut -d' ' -f1`
branchname=$(git branch |awk '/\*/ {print $2}')

cmd="git push --set-upstream $rp $branchname"
echo "$cmd"

while [ $i -le $tot_commits ]
do
    commit=`sed -n "$i"p commits.txt`
    echo
    echo --------- Pushing commit: $commit index: $i total commits: $tot_commits ---------
    cmd="git reset --hard $commit"
    echo "$cmd"
    eval "$cmd"
    cmd="git push --set-upstream $rp $branchname"
    echo "$cmd"
    eval "$cmd"
    if [ $? -ne 0 ]; then
        exit
    fi
    i=$(expr $i + 10000)
    echo "next $i"
done

commit=`sed -n "$tot_commits"p commits.txt`
echo --------- Pushing final commit: $commit total commits: $tot_commits ---------
git reset --hard $commit
cmd="git push --set-upstream $rp $branchname"
eval "$cmd"

rm commits.txt
