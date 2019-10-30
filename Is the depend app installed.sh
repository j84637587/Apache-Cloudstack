if [ "$(dpkg -l |grep ssh |wc -l)" = "0" ];then
	echo 尚未安裝 " ssh "
else
	echo 已安裝 " ssh "
fi

if [ "$(dpkg -l |grep openntpd |wc -l)" = "0" ];then
	echo 尚未安裝 " openntpd "
else
	echo 已安裝 " openntpd "
fi

if [ "$(dpkg -l |grep bridge-utils |wc -l)" = "0" ];then
	echo 尚未安裝 " bridge-utils "
else
	echo 已安裝 " bridge-utils "
fi

if [ "$(dpkg -l |grep mysql-server |wc -l)" = "0" ];then
	echo 尚未安裝 " mysql-server "
else
	echo 已安裝 " mysql-server "
fi

if [ "$(dpkg -l |grep cloudstack-management |wc -l)" = "0" ];then
	echo 尚未安裝 " cloudstack-management "
else
	echo 已安裝 " cloudstack-management "
fi

if [ "$(dpkg -l |grep nfs-kernel-server |wc -l)" = "0" ];then
	echo 尚未安裝 " nfs-kernel-server "
else
	echo 已安裝 " nfs-kernel-server "
fi

if [ "$(dpkg -l |grep nfs-common |wc -l)" = "0" ];then
	echo 尚未安裝 " nfs-common "
else
	echo 已安裝 " nfs-common "
fi

if [ "$(dpkg -l |grep cloudstack-agent |wc -l)" = "0" ];then
	echo 尚未安裝 " cloudstack-agent "
else
	echo 已安裝 " cloudstack-agent "
fi
