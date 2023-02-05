#!/bin/bash
#23.02.05
#/usr/bin/rclone mount collect:/Rclone/backup /usr/rclone \
echo "记得手动修改 name loc loc_remote loc_config 挂载需要的几个参数"
name="cooo_backup" #name 手动配置修改
loc="/usr/cooo_backup" #本地挂载路径
loc_remote="/" #远程挂载路径 /为根目录 根据实际需求写路径
loc_config="/root/.config/rclone/rclone.conf" #配置文件路径
mkdir -p $loc /var/ds #创建挂载目录 日志目录

if [[ $1 = nohup ]]; then
	fusermount -qzu $loc #先卸载再挂载
	lj=`pwd`  #获取当前路径
	echo $lj
	nohup $lj/rclone_mount.sh start >/var/ds/rclone_mount.log 2>&1 &
	echo "检查df -h 输出命令看有无rclone挂载的盘"
	df -h
	
elif [[ $1 = install ]]; then
	apt-get update #更新版本号
	curl https://rclone.org/install.sh | sudo bash #安装Rclone
	echo "已安装Rclone"
	echo "手动上传rclone.conf、rclone_mount.sh配置文件到当前目录建议Root目录下"
	echo "配置文件可能失效，配置完后可挂载测试看报错情况"

elif [[ $1 = start ]]; then
    echo "挂载中ing 检查输出日志"
	fusermount -qzu $loc #先卸载再挂载
	rclone mount $name:$loc_remote $loc \
		--umask 0000 \
		--default-permissions \
		--allow-non-empty \
			--allow-other \
			--transfers 4 \
			--buffer-size 32M \
			--low-level-retries 200 \
				--vfs-cache-mode writes
	df -h

elif [[ $1 = rm ]]; then #删除配置文件 为了安全
	echo "删除Rclone配置文件中ing 检查输出日志"
	fusermount -qzu $loc #先卸载再挂载
	rm -rf $loc_config #删除配置文件
	df -h
	cd /root/.config/rclone/
	ls
	echo "检查df -h 输出命令看有无rclone挂载的盘"

else
	echo "缺第一启动参数"
	echo "install安装Rclone"
	echo "start运行Rclone 调试用"
	echo "nohup后台运行Rclone"
	echo "rm删除Rclone配置文件"
fi