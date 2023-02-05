#!/bin/bash
#23.01.08
edition=`cat /etc/issue` #获取系统版本号 18或者20
edition=${edition: 7: 2}
echo "系统版本:"$edition
sleep 3s
apt-get update #更新版本号
sed -i 's/#Port\ 22/Port\ 2969/' /etc/ssh/sshd_config && systemctl reload ssh #修改端口为2969
apt install net-tools -y #安装一些常用缺失的库

#Cron
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime #恢复Cron时区为UTC+8
cp /usr/sju/Conf_File/crontab /var/spool/cron/crontabs/root #恢复定时任务文件
service rsyslog restart
sleep 1s
/etc/init.d/cron restart #重启cron任务

#恢复SSR配置文件
cp /usr/sju/Conf_File/user-config.json /etc/shadowsocksr/user-config.json

#创建日志目录
if [ ! -d "/var/ds/" ];then
    mkdir -p /var/ds
else
    echo "/var/ds/文件夹已经存在"
fi
sleep 1s

#恢复rc.local开机自启动文件
cp /usr/sju/Conf_File/rc.local /etc/rc.local

if [[ $edition = "18" ]]; then
    #安装Apache2、PHP7.2 适用于ub18.04 lts
    sudo apt install apache2 php7.2-fpm php7.2-mysql php7.2-curl php7.2-gd php7.2-mbstring php7.2-xml php7.2-xmlrpc php7.2-zip php7.2-opcache libapache2-mod-php -y
    cp /usr/sju/Conf_File/000-default.conf /etc/apache2/sites-available/000-default.conf #恢复Apache2配置文件
    cp /usr/sju/Conf_File/certs/* /etc/apache2/certs/ #恢复Apache2证书文件
    sudo a2enmod rewrite proxy proxy_http ssl  #开启读写模块、反向代理、ssl模式、按需开启
    service php7.2-fpm restart service apache2 restart #重启PHP Apache2
    sleep 1s
	echo "已安装Apache2、PHP7.2 适用于ub18.04 lts"

elif [[ $edition = "20" ]]; then
    #安装Apache2、PHP7.4 适用于ub20.04 lts
    sudo apt install apache2 php7.4-fpm php7.4-mysql php7.4-curl php7.4-gd php7.4-mbstring php7.4-xml php7.4-xmlrpc php7.4-zip php7.4-opcache libapache2-mod-php -y
    cp /usr/sju/Conf_File/000-default.conf /etc/apache2/sites-available/000-default.conf #恢复Apache2配置文件
    cp /usr/sju/Conf_File/certs/* /etc/apache2/certs/ #恢复Apache2证书文件
    sudo a2enmod rewrite proxy proxy_http ssl  #开启读写模块、反向代理、ssl模式、按需开启
    service php7.2-fpm restart service apache2 restart #重启PHP Apache2
    sleep 1s
    echo "已安装Apache2、PHP7.4 适用于ub20.04 lts"

else
	echo "获取系统版本号错误 请检查"
    exit 1
fi

#python
sudo apt-get install python3-pip -y #安装pip
python3 -m pip install --upgrade pip #升级pip
pip3 install aliyun-python-sdk-alidns pyaml #安装ali ddns需要的库
pip3 install --upgrade pyOpenSSL -i http://pypi.douban.com/simple --trusted-host pypi.douban.com #升级openssl
pip3 install psutil #安装探针需要的库

sleep 1s
systemctl restart rc-local #重新启动开机自启动服务

#git clone https://github.com/hui99995/sh.git
#chmod u+x * sh

#可能遇到的错误
#DDNS报错 AttributeError: module 'lib' has no attribute 'X509_V_FLAG_CB_ISSUER_CHECK
#pip uninstall pyOpenSSL #先卸载
#pip install pyOpenSSL #再安装
