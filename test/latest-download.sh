#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

pagehash="$(curl -f -L -s 'http://www.swftools.org/download.html' | shasum -b | cut -d' ' -f1)"
expected='d092ddf300e7d5a0bdc663bcd7d849e428c08876'

if [[ "${pagehash}" == "${expected}" ]]; then
	echo 'Download page not changed'
else
	echo 'Download page has changed'
	exit 1
fi
