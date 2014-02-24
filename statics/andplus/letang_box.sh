#!/bin/sh
LASTDAY=`date -d '-1 day' +%Y%m%d`
LASTYEAR=`date -d '-1 day' +%Y`
LOG_PATH=/logs/nginx/$LASTYEAR/
#不排重
vv0=`grep -v 218.104.71.178 $LOG_PATH/promote_static_$LASTDAY.log|grep "b=click_window&t=0"|wc -l`
vv10=`grep -v 218.104.71.178 $LOG_PATH/promote_static_$LASTDAY.log|grep "b=click_window&t=10"|wc -l`
vv60=`grep -v 218.104.71.178 $LOG_PATH/promote_static_$LASTDAY.log|grep "b=click_window&t=60"|wc -l`
vv110=`grep -v 218.104.71.178 $LOG_PATH/promote_static_$LASTDAY.log|grep "b=click_window&t=110"|wc -l`
vv300=`grep -v 218.104.71.178 $LOG_PATH/promote_static_$LASTDAY.log|grep "b=click_window&t=300"|wc -l`
vvobtain=`grep -v 218.104.71.178 $LOG_PATH/promote_static_$LASTDAY.log|grep "b=click_obtain"|wc -l`
vvmore=`grep -v 218.104.71.178 $LOG_PATH/promote_static_$LASTDAY.log|grep "b=click_more"|wc -l`
vvfigure=`grep -v 218.104.71.178 $LOG_PATH/promote_static_$LASTDAY.log|grep "b=click_figure"|wc -l`
vvstart=`grep -v 218.104.71.178 $LOG_PATH/promote_static_$LASTDAY.log|grep "b=game_launch"|wc -l`
#排重
v0=`grep -v 218.104.71.178 $LOG_PATH/promote_static_$LASTDAY.log|grep "b=click_window&t=0"|grep -oE "uuid=(\w|-)*"|sort -u|wc -l`
v10=`grep -v 218.104.71.178 $LOG_PATH/promote_static_$LASTDAY.log|grep "b=click_window&t=10"|grep -oE "uuid=(\w|-)*"|sort -u|wc -l`
v60=`grep -v 218.104.71.178 $LOG_PATH/promote_static_$LASTDAY.log|grep "b=click_window&t=60"|grep -oE "uuid=(\w|-)*"|sort -u|wc -l`
v110=`grep -v 218.104.71.178 $LOG_PATH/promote_static_$LASTDAY.log|grep "b=click_window&t=110"|grep -oE "uuid=(\w|-)*"|sort -u|wc -l`
v300=`grep -v 218.104.71.178 $LOG_PATH/promote_static_$LASTDAY.log|grep "b=click_window&t=300"|grep -oE "uuid=(\w|-)*"|sort -u|wc -l`
vobtain=`grep -v 218.104.71.178 $LOG_PATH/promote_static_$LASTDAY.log|grep "b=click_obtain"|grep -oE "uuid=(\w|-)*"|sort -u|wc -l`
vmore=`grep -v 218.104.71.178 $LOG_PATH/promote_static_$LASTDAY.log|grep "b=click_more"|grep -oE "uuid=(\w|-)*"|sort -u|wc -l`
vfigure=`grep -v 218.104.71.178 $LOG_PATH/promote_static_$LASTDAY.log|grep "b=click_figure"|grep -oE "uuid=(\w|-)*"|sort -u|wc -l`
vstart=`grep -v 218.104.71.178 $LOG_PATH/promote_static_$LASTDAY.log|grep "b=game_launch"|grep -oE "uuid=(\w|-)*"|sort -u|wc -l`

echo -e "-----------------------------不排重统计--------------------------------->>>>>" > $LOG_PATH/output/promote_$LASTDAY
echo -e "时间未到\t"$vv0 >> $LOG_PATH/output/promote_$LASTDAY
echo -e "10s已到\t"$vv10 >> $LOG_PATH/output/promote_$LASTDAY
echo -e "60s已到\t"$vv60 >> $LOG_PATH/output/promote_$LASTDAY
echo -e "110s已到\t"$vv110 >> $LOG_PATH/output/promote_$LASTDAY
echo -e "其他时间已到\t"$vv300 >> $LOG_PATH/output/promote_$LASTDAY
echo -e "点击获取金币\t"$vvobtain >> $LOG_PATH/output/promote_$LASTDAY
echo -e "点击moregame\t"$vvmore >> $LOG_PATH/output/promote_$LASTDAY
echo -e "点击大图跳至gp\t"$vvfigure >> $LOG_PATH/output/promote_$LASTDAY
echo -e "启动游戏\t"$vvstart >> $LOG_PATH/output/promote_$LASTDAY
echo -e "-----------------------------排重统计----------------------------------->>>>>" >> $LOG_PATH/output/promote_$LASTDAY
echo -e "时间未到\t"$v0 >> $LOG_PATH/output/promote_$LASTDAY
echo -e "10s已到\t"$v10 >> $LOG_PATH/output/promote_$LASTDAY
echo -e "60s已到\t"$v60 >> $LOG_PATH/output/promote_$LASTDAY
echo -e "110s已到\t"$v110 >> $LOG_PATH/output/promote_$LASTDAY
echo -e "其他时间已到\t"$v300 >> $LOG_PATH/output/promote_$LASTDAY
echo -e "点击获取金币\t"$vobtain >> $LOG_PATH/output/promote_$LASTDAY
echo -e "点击moregame\t"$vmore >> $LOG_PATH/output/promote_$LASTDAY
echo -e "点击大图跳至gp\t"$vfigure >> $LOG_PATH/output/promote_$LASTDAY
echo -e "启动游戏\t"$vstart >> $LOG_PATH/output/promote_$LASTDAY

#mail -s box_$LASTDAY -S sendcharsets=utf-8 ismtlee@gmail.com < $LOG_PATH/output/promote_$LASTDAY
