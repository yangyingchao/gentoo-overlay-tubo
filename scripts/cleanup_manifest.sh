#!/bin/bash
#
# Author: Yang,Ying-chao <yangyingchao@g-data.com>, 2017-05-09
#
top=$(git rev-parse --show-toplevel)

cd $top
for fn in $(find $top -name "*.ebuild"); do
    echo "Processing $fn"
    dname=$(dirname $fn)
    bname=$(basename $fn)
    cd $dname
    # sed -i "s/KEYWORDS=.*$/KEYWORDS=\"amd64 x86 amd-linux x86-linux x64-macos\"/g" $bname
    ebuild $bname digest
done
