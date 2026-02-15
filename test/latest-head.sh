#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

expected="${SWFTOOLS_HEAD}"

tmpclone='/tmp/matthiaskramm-swftools-latest-check'
rm -rf "${tmpclone}"
git clone --depth 1 'https://github.com/matthiaskramm/swftools.git' "${tmpclone}" 2> /dev/null
pushd "${tmpclone}" > /dev/null
commit="$(git rev-parse HEAD)"
popd > /dev/null
rm -rf "${tmpclone}"

if [[ "${commit}" == "${expected}" ]]; then
	echo 'HEAD commit on master unchanged'
else
	echo "HEAD commit on master changed: ${commit}"
	exit 1
fi
