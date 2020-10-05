#!/usr/bin/env bash

set -x

dest=$2
source=$1

mountpoint -q $dest

if [ $? != 0 ];then
    mkdir -p $source $dest
    echo "try mount $source to $dest ..."
    mount --bind $source $dest
else
    echo "$dest already mount, skip"
fi
