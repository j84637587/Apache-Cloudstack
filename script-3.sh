IP=192.168.66.139
SYSPATH=http://cloudstack.apt-get.eu/systemvm/4.11/systemvmtemplate-4.11.3-kvm.qcow2.bz2

rpcinfo -u $IP mount
showmount -e $IP
mount /mnt/primary
mount /mnt/secondary

/usr/share/cloudstack-common/scripts/storage/secondary/cloud-install-sys-tmplt \
    -m /mnt/secondary -u $SYSPATH -h kvm -F