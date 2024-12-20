# OpenCTI with Docker

[Docker](https://www.docker.com/)
기반의
[OpenCTI](https://github.com/OpenCTI-Platform/opencti)
서버를 구성하기 위한 Bash 스크립트

컨테이너가 실행 중인 상태로 시스템 재시작 시 에러가 발생할 수 있습니다. 그런 경우 컨테이너 중지 후 재시작해 주세요.



## Tested OS

- Ubuntu 22.04
- Ubuntu 24.04



## How to use

아래 표는 `scripts` 폴더 내 존재하는 각 스크립트 파일별 작업 내용입니다.

| 파일              | 내용                                                                  |
|-------------------|-----------------------------------------------------------------------|
| source.sh         | 모든 스크립트 파일에서 사용되는 공통 코드                             |
| 00-packages.sh    | 서버 구성 시 필요한 종속성 패키지 설치                                |
| 01-opencti.sh     | 도커 기반의 OpenCTI 서버 자동 구성                                    |
| 01-docker.sh      | 도커 설치 (설치 완료 후 재부팅 필요)                                  |
| 02-images-pull.sh | 컨테이너 구성 시 사용되는 모든 이미지 pull                            |
| 03-run.sh         | `compose.sh`, `connector.sh` 파일 복사 및 `compose.sh` 실행           |
| autorun.sh        | 위 스크립트 파일들을 순서대로 실행                                    |
| compose.sh        | `.env` 파일에 설정된 환경변수를 즉시 적용하여 컨테이너 실행 및 중지   |
| connector.sh      | OpenCTI와 연동 가능한 커넥터 자동 구성                                |

\+ `autorun.sh` 파일 실행 시 도커가 설치되어 있지 않다면 `02-images-pull.sh` 및 `compose.sh`는 실행되지 않음

### Installation

1. `git` 설치

    ```shell
    sudo apt-get update
    sudo apt-get install -y git
    ```

2. `git` 명령어로 저장소 clone

    ```shell
    git clone https://github.com/jh1950/ctr ~/
    ```

3. `autorun.sh` 파일 실행 및 종료 시 재부팅

    ```shell
    cd ~/ctr/scripts
    ./autorun.sh
    # reboot
    ```

4. (Optional) OpenCTI 커넥터 구성 및 필요 시 환경변수 설정

    ```shell
    cd ~/opencti
    ./connector.sh CONNECTOR_NAME
    # vi .env
    ```

5. (Optional) 컨테이너 구성에 사용되는 모든 도커 이미지 pull

    ```shell
    cd ~/opencti
    docker compose pull
    ```

6. `compose.sh` 도커 이미지 pull 및 컨테이너 실행

    ```shell
    cd ~/opencti
    ./compose.sh
    ```

7. 컨테이너 중지

    ```shell
    cd ~/opencti
    ./compose.sh down
    ```
