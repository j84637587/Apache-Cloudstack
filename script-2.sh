IP=192.168.66.139
DBPASSWORD=j75873648
PASSWORD=j75873648

cat >/etc/apt/sources.list.d/cloudstack.list <<EOM
deb http://cloudstack.apt-get.eu/ubuntu trusty 4.12
EOM
wget -O - http://cloudstack.apt-get.eu/release.asc|apt-key add -
apt-get update

while [ "$(dpkg -l |grep cloudstack-management |wc -l)" = "0" ]
do
		echo 安裝 " cloudstack-management "
        apt-get --yes install cloudstack-management
done

echo 安裝 " mysql-server "
apt-get --yes install mysql-server

echo 設定 " /etc/mysql/conf.d/cloudstack.cnf "
cat >>/etc/mysql/conf.d/cloudstack.cnf <<EOM
[mysqld]
innodb_rollback_on_timeout=1
innodb_lock_wait_timeout=600
max_connections=350
server-id=master-01
log-bin=mysql-bin
binlog-format = 'ROW'
EOM

service mysql restart

cloudstack-setup-databases cloud:$DBPASSWORD@localhost \
                --deploy-as=root:$PASSWORD \
                -e file \
                -m $PASSWORD \
                -k $PASSWORD
				
echo 建立 " /export/primary /export/secondary 資料夾"
mkdir -p /export/primary /export/secondary
apt-get --yes install nfs-kernel-server

echo 修改 " /etc/exports "
cat >>/etc/exports <<EOM
/export  *(rw,async,no_root_squash,no_subtree_check)
EOM

echo 確認 " /etc/exports "
exportfs -a

echo 安裝 " nfs-common "
apt-get --yes install nfs-common

echo 設定 " /etc/default/nfs-common "
sed -i '$aNEED_STATD=yes' /etc/default/nfs-common
sed -i 's/STATDOPTS=/STATDOPTS="--port 662 --outgoing-port 2020"/g' /etc/default/nfs-common

service nfs-kernel-server restart
showmount -e 127.0.0.1

echo 建立 " /mnt/primary /mnt/secondary 資料夾"
mkdir -p /mnt/primary /mnt/secondary

echo 設定 " /etc/fstab "
cat >>/etc/fstab <<EOM
$IP:/export/primary   /mnt/primary    nfs rsize=8192,wsize=8192,timeo=14,intr,vers=3,noauto  0   2
$IP:/export/secondary /mnt/secondary  nfs rsize=8192,wsize=8192,timeo=14,intr,vers=3,noauto  0   2
EOM
mount /mnt/primary
mount /mnt/secondary

while [ "$(dpkg -l |grep cloudstack-agent |wc -l)" = "0" ]
do
		echo 安裝 " cloudstack-agent "
        apt-get --yes install cloudstack-agent
done

sed -i 's/#listen_tls = 0/listen_tls = 0/g' /etc/libvirt/libvirtd.conf
sed -i 's/#listen_tcp = 1/listen_tcp = 1/g' /etc/libvirt/libvirtd.conf
sed -i 's/#tcp_port = "16509"/tcp_port = "16509"/g' /etc/libvirt/libvirtd.conf
sed -i 's/#auth_tcp = "sasl"/auth_tcp = "none"/g' /etc/libvirt/libvirtd.conf

sed -i 's/libvirtd_opts="-d"/libvirtd_opts="-d -l"/g' /etc/default/libvirt-bin
service libvirt-bin restart

sed -i 's/#vnc_listen = "0.0.0.0"/vnc_listen = "0.0.0.0"/g' /etc/libvirt/qemu.conf
service libvirt-bin restart

ln -s /etc/apparmor.d/usr.sbin.libvirtd /etc/apparmor.d/disable/
ln -s /etc/apparmor.d/usr.lib.libvirt.virt-aa-helper /etc/apparmor.d/disable/
apparmor_parser -R /etc/apparmor.d/usr.sbin.libvirtd
apparmor_parser -R /etc/apparmor.d/usr.lib.libvirt.virt-aa-helper

service libvirt-bin restart

echo 設定防火牆
ufw allow proto tcp from any to any port 22
ufw allow proto tcp from any to any port 1798
ufw allow proto tcp from any to any port 16509
ufw allow proto tcp from any to any port 5900:6100
ufw allow proto tcp from any to any port 49152:49216

reboot
