#!/bin/bash
#23.01.08
#read age
#创建日志目录
if [[ ! -d "/var/ds/" ]];then
    mkdir -p /var/ds
else
    echo "文件夹已经存在"
fi
sleep 1s

if [[ $1 = install ]]; then
	apt-get update #更新版本号
	sudo apt-get install python3-pip -y #安装pip
	python3 -m pip install --upgrade pip #升级pip
	pip3 install psutil #安装探针需要的库
	echo "已安装探针库"

elif [[ $1 = start ]]; then
	lj=`pwd`  #获取当前路径
	echo $lj
	python3 $lj/status-psutil-test.py
    echo "已启动"

elif [[ $1 = nohup ]]; then
	lj=`pwd`  #获取当前路径
	echo $lj
	nohup python3 $lj/status-psutil-test.py >/var/ds/status-psutil-test.log 2>&1 &
    echo "已启动"

else
	echo "install安装探针需要的库"
	echo "start运行探针 调试用"
	echo "nohup后台运行探针"
fi