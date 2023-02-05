#!/bin/bash
#23.01.08
apt-get update #更新版本号
sed -i 's/#Port\ 22/Port\ 2969/' /etc/ssh/sshd_config && systemctl reload ssh #修改端口为2969
apt install net-tools -y #安装一些常用缺失的库

#Cron
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime #恢复Cron时区为UTC+8
cp /usr/sju/Conf_File/crontab /var/spool/cron/crontabs/root #恢复定时任务文件
service rsyslog restart
sleep 1s
/etc/init.d/cron restart #重启cron任务

#创建日志目录
if [ ! -d "/var/ds/" ];then
    mkdir -p /var/ds
else
    echo "文件夹已经存在"
fi
sleep 1s

#恢复rc.local开机自启动文件
cp /usr/sju/Conf_File/rc.local /etc/rc.local

#python
sudo apt-get install python3-pip -y #安装pip
python3 -m pip install --upgrade pip #升级pip
pip3 install aliyun-python-sdk-alidns pyaml #安装ali ddns需要的库
pip3 install psutil #安装探针需要的库

sleep 1s
systemctl restart rc-local #重新启动开机自启动服务
echo "已部署完成 使用reboot命令重启机器 检查crontab日志 看定时任务是否正常"

#git clone https://github.com/hui99995/sh.git
#chmod u+x * sh

#可能遇到的错误
#DDNS报错 AttributeError: module 'lib' has no attribute 'X509_V_FLAG_CB_ISSUER_CHECK
#pip uninstall pyOpenSSL #先卸载
#pip install pyOpenSSL #再安装
