echo deb http://archive.ubuntu.com/ubuntu trusty-backports main universe | \
     sudo  tee /etc/apt/sources.list.d/backports.list
sudo apt-get update
sudo apt-get install -y libssl-dev libpcre3
sudo apt-get install haproxy -t trusty-backports

sudo service haproxy restart

# cat /etc/haproxy/haproxy.cfg
global
  log 127.0.0.1:514 local0

defaults
  mode http
  log global
  option httplog
  option  http-server-close
  option  dontlognull
  option  redispatch
  option  contstats
  retries 3
  backlog 10000
  timeout client          25s
  timeout connect          5s
  timeout server          25s
  timeout tunnel        3600s
  timeout http-keep-alive  1000s
  timeout http-request    15s
  timeout queue           30s
  timeout tarpit          60s
  default-server inter 3s rise 2 fall 3
  option forwardfor

frontend http_in
  bind *:80 
  maxconn 1000
  default_backend storify_editor_backend

backend storify_editor_backend
  timeout check 5000
  #option httpchk GET /ha-stats?all=1
  balance source
  
	#SERVERBEGIN
		server server1 172.31.26.117:3000 maxconn 1000
 		# server server2 172.31.26.116:3000 maxconn 1000 weight 10 cookie websrv1 check inter 10000 rise 1 fall 3
      	#SERVEREND
