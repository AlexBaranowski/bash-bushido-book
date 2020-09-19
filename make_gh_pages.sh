#!/usr/bin/env bash

BASE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE2="${BASE}-tmp"
BB_TMP_DIR=/tmp/bash-bushido-tmp-aaaa
cleanup(){
    rm -rf "$BB_TMP_DIR"
}

trap cleanup EXIT

set -euo pipefail
rm -rf "$BASE2"
# Copy whole repo and change dir  to tmp repo
cp -r "$BASE" "$BASE2"
pushd "$BASE2"

make html
mv build/html "$BB_TMP_DIR"
git checkout gh-pages
rm -rv $BASE2/*
mv -v $BB_TMP_DIR/* .
mv book.html index.html
git add .
echo -e "New GH-pages version is here:\n $BASE2 \nyou can commit and push it"
