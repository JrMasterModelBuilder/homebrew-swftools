#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

commit="$(curl -f -L -s 'https://github.com/matthiaskramm/swftools/commits/master' | egrep -o '/matthiaskramm/swftools/commit/[0-9a-f]+' | head -n 1 | grep -o '[^/]*$')"
expected='772e55a271f66818b06c6e8c9b839befa51248f4'

if [[ "${commit}" == "${expected}" ]]; then
	echo 'HEAD commit on master not changed'
else
	echo 'HEAD commit on master has changed'
	exit 1
fi
