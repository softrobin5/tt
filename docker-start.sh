MAXCONN=1000
HACONFIGSERVERS=/tmp/HACONFIGSERVERS
HACONFIG=/etc/haproxy/haproxy.cfg
TMPHACONFIG=/tmp/testconfig

echo "" > $HACONFIGSERVERS

max=`nproc`
for i in `seq $max`
do
    echo "Docker start No. $i"
        docker run -d -p 808$i:3000 software /bin/bash /var/www/app/start.sh
	echo  "     server   ttserver$i localhost:808$i maxconn $MAXCONN" >> $HACONFIGSERVERS
	echo "" >> $HACONFIGSERVERS
done


if [ `cat $HACONFIGSERVERS | wc -l` -gt 0 ]; 
then
       echo "Writing HA Proxy Config File..."
       SUBSERVER=`cat $HACONFIGSERVERS | sort -u | sed '/^$/d' | sed -e 's/[\/&]/\\&/g'`
       cat $HACONFIG | sed -e "/#SERVERBEGIN/,/#SERVEREND/c\\\t\#SERVERBEGIN\n\tSERVERPLACEHOLDER\n\t\#SERVEREND" | perl -p -e "s/SERVERPLACEHOLDER/${SUBSERVER}/g" > $TMPHACONFIG
       cat $TMPHACONFIG > $HACONFIG

       echo "Reloading HAProxy..."
       /etc/init.d/haproxy reload
fi
