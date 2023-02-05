#!/bin/bash
#23.02.05
#chmod u+x * update_sh.sh
cd /usr/sju/sh
rm -rf 	Re_Linux_Air* bk_Air* *html
url="https://raw.githubusercontent.com/hui99995/sh/main/"	
wget $url"Re_Linux_Air.sh" && chmod +x Re_Linux_Air.sh
wget $url"bk_Air.sh" && chmod +x bk_Air.sh

rm -rf 	*html *html*
chmod u+x *  /usr/sju/Temp/*

 