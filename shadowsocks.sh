#! /bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#===============================================================================================
#   System Required:  Centos/Debian/Ubuntu
#   Description:  Install Python-Shadowsocks
#   Author: Arno <blogfeng@blogfeng.com>
#   Intro:  http://www.blogfeng.com/
#===============================================================================================
clear
echo -n "
		Install Python-Shadowsocks
		Author:arnofeng @www.blogfeng.com
		Enter any key to continue:"
read goodmood
ssserver -c /etc/shadowsocks.json -d stop
echo -n "set your port: "  
read key1
if [ ! $key1 ]; then
	PORT='2222'
else
	PORT=$key1
fi
echo -n "set your password: " 
read key2
if [ ! $key2 ]; then
	PASS='blogfeng.com'
else
	PASS=$key2
fi
wget -N --no-check-certificate https://bootstrap.pypa.io/ez_setup.py
python ez_setup.py --insecure
easy_install pip
pip install shadowsocks
echo "
{

    \"server\": \"0.0.0.0\",

    \"port_password\": {
             \"2222\": \"blogfeng.com\"
              
     },

    \"timeout\": 300,

    \"method\": \"aes-256-cfb\"

}

" > /etc/shadowsocks.json
sed -i "s#2222#$PORT#g" /etc/shadowsocks.json
sed -i "s#blogfeng.com#$PASS#g" /etc/shadowsocks.json
cp -r -f /etc/rc.local /etc/rc.local_ssbak
AUTO='nohup /usr/local/bin/ssserver -c /etc/shadowsocks.json > /dev/null 2>&1 &'
cat /etc/rc.local|grep 'exit 0'
if [ $? -eq 0 ]; then
	sed -i 's/\"exit 0\"/\#/g' /etc/rc.local
	sed -i 's/\#exit 0/\#/g' /etc/rc.local
	sed -i "s#exit 0#$AUTO\nexit 0#" /etc/rc.local
else
	echo "$AUTO">>/etc/rc.local
fi
ssserver -c /etc/shadowsocks.json -d start
if [ $? -eq 0 ]; then
	echo "
	#Everything seems OK!
	#your port is $PORT
	#your password is $PASS
	#your  encryption is aes-256-cfb
	#Go try your ss!"
else
	echo "
	#Installing errors!
	#Reinstall OR Contact me!"
fi