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

expected='772e55a271f66818b06c6e8c9b839befa51248f4'

if [[ "${commit}" == "${expected}" ]]; then
	echo 'HEAD commit on master unchanged'
else
	echo 'HEAD commit on master changed'
	exit 1
fi
