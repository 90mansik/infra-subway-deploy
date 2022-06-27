<p align="center">
    <img width="200px;" src="https://raw.githubusercontent.com/woowacourse/atdd-subway-admin-frontend/master/images/main_logo.png"/>
</p>
<p align="center">
  <img alt="npm" src="https://img.shields.io/badge/npm-%3E%3D%205.5.0-blue">
  <img alt="node" src="https://img.shields.io/badge/node-%3E%3D%209.3.0-blue">
  <a href="https://edu.nextstep.camp/c/R89PYi5H" alt="nextstep atdd">
    <img alt="Website" src="https://img.shields.io/website?url=https%3A%2F%2Fedu.nextstep.camp%2Fc%2FR89PYi5H">
  </a>
  <img alt="GitHub" src="https://img.shields.io/github/license/next-step/atdd-subway-service">
</p>

<br>

# 인프라공방 샘플 서비스 - 지하철 노선도

<br>

## 🚀 Getting Started

### Install
#### npm 설치
```
cd frontend
npm install
```
> `frontend` 디렉토리에서 수행해야 합니다.

### Usage
#### webpack server 구동
```
npm run dev
```
#### application 구동
```
./gradlew clean build
```
<br>

## 미션

* 미션 진행 후에 아래 질문의 답을 README.md 파일에 작성하여 PR을 보내주세요.

### 0단계 - pem 키 생성하기

1. 서버에 접속을 위한 pem키를 [구글드라이브](https://drive.google.com/drive/folders/1dZiCUwNeH1LMglp8dyTqqsL1b2yBnzd1?usp=sharing)에 업로드해주세요

2. 업로드한 pem키는 무엇인가요.
- https://drive.google.com/file/d/1714XT0lweMxY_v_bPJNw4J-mqRP9s-HV/view?usp=sharing

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : 
  - public-a : 192.168.52.0/26
  - public-c : 192.168.52.64/26	
  - internal-a : 192.168.52.128/27
  - bastion-a : 192.168.52.160/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : http://infra.koo.gg:8080/



---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://infra.koo.gg

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.

```shell
#!/bin/bash

PROJECT_PATH=$1
BRANCH=$2
PROFILE=$3

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

# Profile 검증
valid_profile() {
  if [ "$1" != "prod" -a "$1" != "dev" ]
  then
    echo -e "${txtred} PROFILE 값이 잘못 되었습니다..${txtrst}"
    exit 1
  fi
}

# Check Github Data
check_df() {
  git checkout $BRANCH
  git fetch
  local_branch=$(git rev-parse HEAD)
  remote=$(git rev-parse --verify origin/$BRANCH)

  if [ "$local_branch" = "$remote" ]
  then
    echo -e "${txtpur}[$(date)] 변동 사항 없음.${txtrst}"
    exit 0
  else
    git pull
  fi
}

# app 종료
app_stop() {
  echo -e "${txtpur}[$(date)] APP 종료.${txtrst}"
  sudo fuser -n tcp -k 8080
}

# app 빌드
app_build() {
  echo -e "${txtpur}[$(date)] APP 빌드.${txtrst}"
  ./gradlew clean build

  jar_path="$(find ./build/libs/* -name "*jar")"
  if [ -n "$jar_path" ]
  then
    echo -e "${txtpur}[$(date)] APP 빌드 완료.${txtrst}"
  else
    echo -e "${txtred}[$(date)] APP 빌드 실패.${txtrst}"
    exit 1
  fi
}

# app 시작
app_start() {
  echo -e "${txtpur}[$(date)] APP 시작.${txtrst}"
  nohup java -jar -Dspring.profiles.active=$PROFILE $PROJECT_PATH/build/libs/subway-0.0.1-SNAPSHOT.jar > ../log/application.log 2>&1 &

  java_pid="$(pgrep -f java)"
  if [ -z "$java_pid" ]
  then
    echo -e "${txtred}[$(date)] APP 시작 실패.${txtrst}"
    exit 1
  fi
}

## 조건 설정
if [ $# -eq 3 ]
then
  valid_profile "$PROFILE"
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
  echo -e ""
  echo -e "${txtgrn} 프로젝트 경로 : $1${txtrst}"
  echo -e "${txtgrn} 브랜치이름 : $2${txtrst}"
  echo -e "${txtgrn} Profile : $3 ${txtred}{ prod | dev }${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"

  cd $PROJECT_PATH
  check_df
  app_stop
  app_build
  app_start
  echo ""
else
  echo -e "${txtred} 파라메터 개수가 잘못되었습니다.${txtrst}"
fi
```

