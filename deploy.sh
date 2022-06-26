#!/bin/bash

## 변수 설정
EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2
PROJECT_NAME=subway

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

## 저장소 pull
function pull() {
  echo -e ""
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e ">> Git pull start.. 🏃"
  git pull origin "$BRANCH"
  echo -e "✅ Git pull finished!!"
  echo -e "${txtylw}=======================================${txtrst}"
}

## gradle build
function build() {
  echo -e ""
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e ">> Gradle clean build start.. 🏃"
  ./gradlew clean build
  echo -e "✅ Gradle build finished!!"
  echo -e "${txtylw}=======================================${txtrst}"
}

## 프로세스 pid 를 찾는 명령어
function find_pid() {
  echo -e ""
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e ">> 실행 중인 pid 조회.. 🏃"
  PID=$(pgrep -f "$PROJECT_NAME")
}

## 프로세스를 종료하는 명령어
function kill_process() {
  echo -e ""
  find_pid

  if [ -z "$PID" ]
  then
     echo "✅ 실행 중인 pid 가 없음"
  else
     kill -2 "$PID"
     echo "✅ 실행 중인 pid 종료"
  fi

  echo -e "${txtylw}=======================================${txtrst}"
}

## 어플리케이션 실행
function run() {
  echo -e ""
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e ">> 어플리케이션 실행.. 🏃"

  JAR_FILE=$(find "$EXECUTION_PATH" -name "$PROJECT_NAME*.jar")
  nohup java -jar -Dspring.profiles.active="$PROFILE" "$JAR_FILE" &

  echo "🎉 배포 완료 🎉"
  echo -e "${txtylw}=======================================${txtrst}"
}

function check_diff() {
  git fetch
  master=$(git rev-parse "$BRANCH")
  remote=$(git rev-parse origin/"$BRANCH")

  if [[ $master == $remote ]];
  then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  else
    deploy
  fi
}

function deploy() {
  pull
  build
  kill_process
  run
}

check_diff

# ./deploy step3 prod
