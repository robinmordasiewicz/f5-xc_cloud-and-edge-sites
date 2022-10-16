#!/bin/bash
#

git remote get-url upstream 2>&1 >/dev/null

if [[ $? == 0 ]]; then
  echo "upstream"
else
  echo "remote"
fi

exit

gitremoteupstream=`git remote get-url upstream`
githuborgname=`git remote get-url upstream | cut -f 4 -d "/"`
githubrepo=`git remote get-url upstream | cut -f 5 -d "/" | cut -f 1 -d "."`


