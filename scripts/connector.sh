#!/bin/bash

# Connector Auto Setup

source "./source.sh"

if [ "$#" -eq 0 ]; then
	INFO "Using: $0 <CONNECTOR_NAME>"
	INFO "CONNECTOR_NAME: $OPENCTI_ROOT/connectors/*/CONNECTOR_NAME"
	exit
fi

CONNECTOR_NAME="${1//[_ ]/-}"
cd "$OPENCTI_ROOT/connectors"

if ! YAML="$(ls */"${CONNECTOR_NAME,,}"/docker-compose.yml 2> /dev/null)"; then
	ERROR "Not found connector: $1"
	exit
fi
if [ "$(echo "$YAML" | wc -l)" -ne 1 ]; then
	select s in $(echo "$YAML" | awk -F "/" '{print $1}'); do
		test -n "$s" && break
	done
	YAML="$(echo "$YAML" | grep "^$s\/")"
fi



CONNECTOR_NAME="${CONNECTOR_NAME//\-/_}"
declare -A SET_ENV
SET_ENV["OPENCTI_URL"]="http://opencti:8080"
SET_ENV["OPENCTI_TOKEN"]="\${OPENCTI_ADMIN_TOKEN}"
SET_ENV["CONNECTOR_ID"]="\${CONNECTOR_${CONNECTOR_NAME^^}_ID}"
mapfile -t DEFAULT_KEYS <<< "${!SET_ENV[@]}"

CONTENTS="$(sed -n '/^services:/,/^[^ ]/{/^ /p}' "$YAML")"
mapfile -t ENV_LIST < <(echo "$CONTENTS" | grep -i "changeme" | awk -F "[[:blank:]]?+|-|=" '{print $4}')

for ENV_NAME in "${ENV_LIST[@]}"; do
	if [[ " ${DEFAULT_KEYS[@]} " == *" ${ENV_NAME} "* ]]; then
		continue
	fi
	SET_ENV["__$ENV_NAME"]="\${$ENV_NAME}"
done

BEFORE="$(cat "$OPENCTI_ROOT/.env")"
for KEY in "${!SET_ENV[@]}"; do
	VAL="${SET_ENV["$KEY"]}"
	CONTENTS="$(echo "$CONTENTS" | sed -E "s|(${KEY#__})=.*|\1=$VAL|g")"
	if [[ "$VAL" =~ ^\$\{.*\}$ ]]; then
		x="$(echo "$VAL" | awk -F "{|}" '{print $2}')"
		if ! grep -Eq "^$x=" "$OPENCTI_ROOT/.env"; then
			echo "$x=$(RANDOM_UUID)  # auto setup" >> "$OPENCTI_ROOT/.env"
		fi
	fi
done
AFTER="$(cat "$OPENCTI_ROOT/.env")"

TMP="$(echo "$CONTENTS" | head -1 | awk -F "[[:blank:]]?+|:" '{print $2}')"
if ! grep -Eq "^[[:blank:]]?+${TMP}:" "$OPENCTI_ROOT/docker-compose.yml"; then
cat >> "$OPENCTI_ROOT/docker-compose.yml" << EOF
$CONTENTS
    depends_on:
      opencti:
	condition: service_healthy
EOF
fi

if [ "$BEFORE" != "$AFTER" ]; then
	IMPORTANT "Changed: $OPENCTI_ROOT/.env"
fi
