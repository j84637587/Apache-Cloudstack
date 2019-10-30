IP=192.168.66.139
GATEWAY=192.168.66.1
NETMASK=255.255.255.0
NET=ens33

echo 開始更新與升級
apt-get --yes update
apt-get --yes upgrade
echo 開始安裝 " net-tools " 與 " ssh "
apt-get --yes install net-tools
apt-get --yes install ssh

echo 修改 " /etc/ssh/sshd_config "
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

sed -i 's/#PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

echo 修改 " /etc/hosts "
sed -i 's/127.0.1.1/'192.168.66.139'/g' /etc/hosts

echo Host名稱 " /etc/hosts "
hostname --fqdn

echo 開始安裝 " openntpd " 與 " bridge-utils "
apt-get install -y openntpd
apt-get install -y bridge-utils

echo 修改網路介面與設定橋接
cat >/etc/network/interfaces <<EOM
auto lo
iface lo inet loopback

auto $NET
iface $NET inet manual

auto cloudbr0
iface cloudbr0 inet dhcp
    address 192.168.66.139
    netmask 255.255.255.0
    gateway 192.168.66.1
    dns-nameservers 192.168.66.1 8.8.8.8 8.8.4.4
    bridge_ports $NET
    bridge_fd 5
    bridge_stp off
    bridge_maxwait 1

auto cloudbr1
iface cloudbr1 inet manual
    bridge_ports none
    bridge_fd 5
    bridge_stp off
    bridge_maxwait 1
EOM

reboot