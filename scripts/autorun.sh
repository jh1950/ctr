#!/bin/bash

# 모든 스크립트 자동 실행

source "./source.sh"

if id -Gn | grep -q docker; then
	pull=true
fi

set -e



cd "$(dirname "$0")"

./00-packages.sh
./01-opencti.sh
./01-docker.sh
./03-run.sh norun

if [ "$pull" != true ]; then
	INFO "and run this file one more time (Optional)"
	exit
fi

./02-images-pull.sh
./03-run.sh
