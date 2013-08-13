#!/bin/sh
PATH=${PATH}:/usr/local/bin:/usr/bin:/bin
PLATFORM=QQ
SERVER_QQ=124.248.34.67
SERVER_SINA=124.248.34.66

commit() {
    ./compile_client.sh
    ./commit.sh
}

merge() {
    ./merge.sh stable-1.0
}

deploy() {
  case $PLATFORM in
    sina)
      ssh -p22022 $SERVER_SINA "svn up /usr/deploy/orange"
      ;;
    QQ)
      ssh -p22022 $SERVER_QQ "svn up /usr/deploy/orange"
      ;;
    *)
      ;;
   esac
}

up_sina() {
    PLATFORM=sina
    echo $PLATFORM
}

up_qq() {
    PLATFORM=QQ
    echo $PLATFORM
}

division() {
    echo  -e "\e[40;34;1m ============================================================ \e[0m"
    #echo  -e "\e[40;34;1m---------------------------------------------------------------\e[0m"
}

welcome() {
    division
    echo  -e "\e[40;34;1m Welcome To Orange Deployment Center! \e[0m"
    echo -e "\e[40;31;2m CAUTION: YOUR OPERATION CAN AFFECT THE PRODUCTION SERVER! \e[0m" 
    echo  -e "\e[40;34;1m sina \e[0m: sina server"
    echo  -e "\e[40;34;1m QQ \e[0m: QQ server"
    echo  -e "\e[40;34;1m q \e[0m: exit"
}

memu() {
    division
    echo -e "\e[40;31;2m current platform >> ${PLATFORM}! \e[0m" 
    echo  -e "\e[40;34;1m commit \e[0m: commit code"
    echo  -e "\e[40;34;1m merge \e[0m: merge code"
    echo  -e "\e[40;34;1m deploy \e[0m: deploy project"
    echo  -e "\e[40;34;1m load \e[0m: load server data"
    echo  -e "\e[40;34;1m sw \e[0m: switch the other platform"
    echo  -e "\e[40;34;1m h: \e[0m: help"
    echo  -e "\e[40;34;1m q: \e[0m: quit"
}


load() {
   php /usr/deploy/orange/scripts/rexcel.php json  
   case $PLATFORM in
    sina)
      ssh -p22022 $SERVER_SINA "svn up /usr/deploy/orange/configs; php /usr/deploy/orange/scripts/load.php all"
      ;;
    QQ)
      ssh -p22022 $SERVER_QQ "svn up /usr/deploy/orange/configs; php /usr/deploy/orange/scripts/load.php all"
      ;;
    *)
      ;;
   esac
}

operation() {
  memu
  while :
  do
   echo -n "Please make a choice : "
   read DEPART

   case $DEPART in
    commit)
      commit;;
    merge)
      merge;;
    deploy)
      deploy;;
    load)
      load;;
    sw)
      main;;
    h)
      memu;;
    q|quit)
      quit;;
    *)
    ;;
   esac
  done
}

quit() {
    echo "bye!"
    exit 0
}

main() {
   echo -n "Please choose a platform : "
   read PLATFORM 
   case $PLATFORM in
    sina|QQ)
      operation $PLATFORM
      ;;
    q|quit)
      quit
      ;;
    *)
      main
      ;;
   esac

   division
}

welcome
main

