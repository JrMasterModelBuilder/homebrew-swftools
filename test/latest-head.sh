#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

tmpclone='/tmp/matthiaskramm-swftools-latest-check'
rm -rf "${tmpclone}"
git clone --depth 1 'https://github.com/matthiaskramm/swftools.git' "${tmpclone}" 2> /dev/null
pushd "${tmpclone}" > /dev/null
commit="$(git rev-parse HEAD)"
popd > /dev/null
rm -rf "${tmpclone}"

expected='c6a18ab0658286f98d6ed2b3d0419058e86a14a0'

if [[ "${commit}" == "${expected}" ]]; then
	echo 'HEAD commit on master unchanged'
else
	echo "HEAD commit on master changed: ${commit}"
	exit 1
fi
