#!/bin/bash

# compose.sh 파일 설정 및 실행

source "./source.sh"

mkdir -p "$OPENCTI_ROOT" && cd "$OPENCTI_ROOT"
if ! which docker > /dev/null; then
	ERROR "Not found command: docker"
	exit 1
elif [ ! -f ".env" ]; then
	ERROR "Not found file: .env"
	exit 1
fi

set -e



for file in "compose.sh" "connector.sh"; do
	test -f "$file" && continue
	cp "$SCRIPTS_ROOT/$file" .
	sed -Ei "s|\.(/source\.sh)|$SCRIPTS_ROOT\1|g" "$file"
done
if [ "${1,,}" != "norun" ]; then
	./compose.sh
fi
