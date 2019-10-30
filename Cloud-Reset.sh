DBPASSWORD = j75873648
PASSWORD = j75873648

if ["$EUID" -ne 0];then
echo 請登入root使用者
else

echo 開始重置雲端

service cloudstack-management stop
service cloudstack-agent stop

mysql -pj75873648 -e 'drop database cloud'
mysql -pj75873648 -e 'drop database cloud_usage'

cloudstack-setup-databases cloud:$DBPASSWORD@localhost \
                --deploy-as=root:$PASSWORD \
                -e file \
                -m $PASSWORD \
                -k $PASSWORD
echo 0
service cloudstack-management start
service cloudstack-agent start
fi
