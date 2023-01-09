#!/bin/bash

set -xeuo pipefail

version=$(curl --silent "https://api.github.com/repos/ducaale/xh/releases/latest" | jq -er .tag_name)
revision=$(curl --silent "https://api.github.com/repos/ducaale/xh/commits/${version}" | jq -er .sha)
version=${version#"v"}
echo "latest stable version: ${version}, revision: ${revision}"

sed -ri \
    -e 's/^(ARG VERSION=).*/\1'"\"${version}\""'/' \
    -e 's/^(ARG REVISION=).*/\1'"\"${revision}\""'/' \
    "stable/Dockerfile"

git add stable/Dockerfile
git diff-index --quiet HEAD || git commit --message "updated stable to version ${version}, revision: ${revision}"

version="master"
revision=$(curl --silent "https://api.github.com/repos/ducaale/xh/commits/${version}" | jq -er .sha)
echo "latest edge version: ${version}, revision: ${revision}"

sed -ri \
    -e 's/^(ARG VERSION=).*/\1'"\"${version}\""'/' \
    -e 's/^(ARG REVISION=).*/\1'"\"${revision}\""'/' \
    "edge/Dockerfile"

git add edge/Dockerfile
git diff-index --quiet HEAD || git commit --message "updated edge to version ${version}, revision: ${revision}"
