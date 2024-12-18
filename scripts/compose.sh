#!/bin/bash

# .env 내용 수정 시 해당 내용을 적용하려면 별도의 과정이 필요함
# 이 파일을 통해 컨테이너를 실행하면 바로 적용됨

source "./source.sh"

action="${1:-"up"}"
file="${2:-"docker-compose.yml"}"

cd "$OPENCTI_DIR"
case "${action,,}" in
	"up")
		docker compose -f "$file" up -d
		;;
	"down")
		docker compose -f "$file" down
		;;
	*)
		INFO "Using: $0 [up|down]"
		;;
esac
