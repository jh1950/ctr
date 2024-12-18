#!/bin/bash

# 필요 패키지 설치

source "./source.sh"

if ! IS_DEBIAN; then
	ERROR "Not supported OS: $(cat /etc/issue.net)"
	exit 1
fi

set -e

sudo apt-get update
sudo apt-get install -y vim git jq curl ca-certificates python3 python3-pip
sudo pip install -U pip python-dotenv pycti
