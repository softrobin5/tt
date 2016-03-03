echo deb http://archive.ubuntu.com/ubuntu trusty-backports main universe | \
     sudo  tee /etc/apt/sources.list.d/backports.list
sudo apt-get update
sudo apt-get install -y libssl-dev libpcre3
sudo apt-get install haproxy -t trusty-backports

sudo cp haproxy.cfg /etc/haproxy/haproxy.cfg 

sudo service haproxy restart

