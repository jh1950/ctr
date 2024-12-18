#!/bin/bash

# 서버 구성에 사용되는 모든 도커 이미지 pull
# 이 과정 없이 바로 컨테이너 실행해도 됨

source "./source.sh"

mkdir -p "$OPENCTI_ROOT" && cd "$OPENCTI_ROOT"
if [ ! -f "docker-compose.yml" ]; then
	ERROR "Not found file: docker-compose.yml"
	exit 1
fi

set -e



docker compose pull
