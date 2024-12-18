#!/bin/bash

# OpenCTI 구성

source "./source.sh"

set -e



# OpenCTI 저장소 clone
mkdir -p "$OPENCTI_ROOT" && cd "$OPENCTI_ROOT"
if [ ! -d ".git" ]; then
	git init
	git remote add origin https://github.com/OpenCTI-Platform/docker
	git fetch origin master
	git pull origin master
fi
if [ ! -d "connectors" ]; then
	git clone https://github.com/OpenCTI-Platform/connectors
fi

# 도커 볼륨이 아닌 디렉토리 사용
mkdir -p {es,s3,redis,amqp}data
sed -Ei "s/^([[:blank:]]+)- (es|s3|redis|amqp)(data)/\1- \.\/\2\3/g; /^volumes:/,\$d" docker-compose.yml

# 환경변수 설정, 모든 uuid는 랜덤
if [ !  -f ".env" ]; then
cat > .env << EOF
OPENCTI_ADMIN_EMAIL=$USER@example.com
OPENCTI_ADMIN_PASSWORD=password
OPENCTI_ADMIN_TOKEN=$(RANDOM_UUID)
OPENCTI_BASE_URL=http://localhost:8080
OPENCTI_HEALTHCHECK_ACCESS_KEY=$(RANDOM_UUID)
MINIO_ROOT_USER=$(RANDOM_UUID)
MINIO_ROOT_PASSWORD=$(RANDOM_UUID)
RABBITMQ_DEFAULT_USER=guest
RABBITMQ_DEFAULT_PASS=guest
CONNECTOR_HISTORY_ID=$(RANDOM_UUID)
CONNECTOR_EXPORT_FILE_STIX_ID=$(RANDOM_UUID)
CONNECTOR_EXPORT_FILE_CSV_ID=$(RANDOM_UUID)
CONNECTOR_IMPORT_FILE_STIX_ID=$(RANDOM_UUID)
CONNECTOR_EXPORT_FILE_TXT_ID=$(RANDOM_UUID)
CONNECTOR_IMPORT_DOCUMENT_ID=$(RANDOM_UUID)
CONNECTOR_ANALYSIS_ID=$(RANDOM_UUID)
SMTP_HOSTNAME=localhost
ELASTIC_MEMORY_SIZE=4G
EOF
fi

### 대용량 데이터 처리를 위한 메모리 설정
sudo sysctl -w vm.max_map_count=1048575  # 일시적 적용
grep -q "^vm\.max_map_count=" /etc/sysctl.conf || echo "vm.max_map_count=1048575" | sudo tee -a /etc/sysctl.conf > /dev/null  # 재부팅 후 영구 적용
