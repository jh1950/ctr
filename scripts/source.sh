#!/bin/bash

# 모든 스크립트 파일의 공통 부분

if [ "$(id -u)" -ne 1000 ] || [ "$(id -g)" -ne 1000 ]; then
	echo "Permission denied"
	exit 1
fi

cd "$(dirname "$0")"
export SCRIPTS_ROOT="$PWD"
export REPO_ROOT="$(dirname "$SCRIPTS_ROOT")"
export OPENCTI_ROOT="$HOME/opencti"
if [ -f "$OPENCTI_ROOT/.env" ]; then
	# .env 파일의 수정된 내용을 즉시 적용
	export $(cat "$OPENCTI_ROOT/.env" | grep -v "#" | xargs)
fi



# Beautiful Logs

RESET=0
# BLACK=30
RED=31
GREEN=32
YELLOW=33
# BLUE=34
MAGENTA=35
CYAN=36
WHITE=37

BOLD=true
BLIGHT=false
NEWLINE=true

ERROR() {
	LOG "$*" "$RED"
}

WARNING() {
	LOG "$*" "$YELLOW"
}

SUCCESS() {
	LOG "$*" "$GREEN"
}

IMPORTANT() {
	LOG "$*" "$MAGENTA"
}

INFO() {
	local BOLD=false
	LOG "$*" "$WHITE"
}

ACTION() {
	LOG "### $* ###" "$CYAN"
}

LOG() {
	local MSG="$1"
	local COLOR="$2"
	local NL=""

	if [ -z "$COLOR" ]; then
		INFO "$MSG"
		return
	fi
	test "$BLIGHT" = true && ((COLOR+=60))
	test "$BOLD" = true && COLOR="1;$COLOR"
	test "$NEWLINE" = true && NL="\n"

	echo -en "\e[${COLOR}m${MSG}\e[${RESET}m${NL}"
}

LOG_WITHOUT_NEWLINE() {
	local NEWLINE=false
	"$@"
}

IS_DEBIAN() {
	which apt-get > /dev/null
	return $?
}

RANDOM_UUID() {
	cat /proc/sys/kernel/random/uuid
}
