#!/bin/bash
#23.02.05
#read age
#chmod u+x * status-psutil.sh
lj="/usr/sju/py"
#创建日志目录
if [[ ! -d "/var/ds/" ]];then
    mkdir -p /var/ds
else
    echo "/var/ds/文件夹已经存在"
fi
sleep 1s

if [[ $1 = install ]]; then
	apt-get update #更新版本号
	sudo apt-get install python3-pip -y #安装pip
	python3 -m pip install --upgrade pip #升级pip
	pip3 install psutil #安装探针需要的库
	echo "已安装探针库"

elif [[ $1 = start ]]; then
	ID=`ps -aux|grep /usr/sju/py/status-psutil.py | awk '{printf $2 " "}'`
	echo $ID
	echo "---------------"
	for id in $ID
	do
	kill -9 $id
	echo "killed $id"
	done
	echo "-------done--------"
    echo "已停止"

	python3 $lj/status-psutil.py
    echo "已启动"

elif [[ $1 = nohup ]]; then
	nohup python3 $lj/status-psutil.py >/var/ds/status-psutil.py 2>&1 &
    echo "已启动"

else
	echo "install安装探针需要的库"
	echo "start运行探针 调试用"
	echo "nohup后台运行探针"
fi