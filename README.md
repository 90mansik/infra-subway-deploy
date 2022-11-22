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
  - sonyoon7-wootechcamp.pem

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 :
    - VPC Ipv4 CIDR: 192.168.25.0/24
    - 외부망1: 192.168.25.0/26
    - 외부망2: 192.168.25.64/26
    - 관리망: 192.168.25.128/27
    - 내부망: 192.168.25.160/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL :   
  - http://infra.wootechcamp-sonyoon7.p-e.kr:8080/  
  - http://3.38.98.126:8080/



---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://infra.wootechcamp-sonyoon7.p-e.kr/

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.
```
#!/bin/bash

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

REPOSITORY=/home/ubuntu/
PROJECT_NAME=infra-subway-deploy
BRANCH=step2


echo  "${txtylw}====================================================${txtrst}"
echo  "${txtgrn}                 << DEPLOY SCRIPT >>                   ${txtrst}"
echo  "${txtylw}====================================================${txtrst}"



cd $REPOSITORY/$PROJECT_NAME/


echo "> Git Pull"

git pull

echo "> Project Build"

./gradlew clean build -x test


echo "> Move To Directory"

cd $REPOSITORY


echo "> COPY Build file"

cp $REPOSITORY/$PROJECT_NAME/build/libs/*.jar $REPOSITORY/

JAR_NAME=$(ls -tr $REPOSITORY/ | grep jar | tail -n 1)

echo "> JAR Name: $JAR_NAME"


echo "> Check Running pid "

CURRENT_PID=$(pgrep -f  *.jar)

echo "pid: $CURRENT_PID"

if [ -z "$CURRENT_PID" ]; then
        echo "> Nothing to kill ."
else
        echo "> kill -15 $CURRENT_PID"
        kill -15 $CURRENT_PID
        sleep 5
fi

echo "> Deploy New "

nohup java -Djava.security.egd=file:/dev/./urandom -Dspring.profiles.active=prod -jar $REPOSITORY/$JAR_NAME &


```

