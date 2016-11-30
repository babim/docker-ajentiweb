[![](https://images.microbadger.com/badges/image/babim/ajentiweb.svg)](https://microbadger.com/images/babim/ajentiweb "Get your own image badge on microbadger.com")[![](https://images.microbadger.com/badges/version/babim/ajentiweb.svg)](https://microbadger.com/images/babim/ajentiweb "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/babim/ajentiweb:ssh.svg)](https://microbadger.com/images/babim/ajentiweb:ssh "Get your own image badge on microbadger.com")[![](https://images.microbadger.com/badges/version/babim/ajentiweb:ssh.svg)](https://microbadger.com/images/babim/ajentiweb:ssh "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/babim/ajentiweb:centos.svg)](https://microbadger.com/images/babim/ajentiweb:centos "Get your own image badge on microbadger.com")[![](https://images.microbadger.com/badges/version/babim/ajentiweb:centos.svg)](https://microbadger.com/images/babim/ajentiweb:centos "Get your own version badge on microbadger.com")

Just Test - fail when create new website and apply

#=RUN
```
docker run -p2222:22 -p 8000:8000 -p 80:80 -p 443:443 -p 3306:3306 -v /opt/ajentiserver/www:/var/www/ -v /opt/ajentiserver/data:/data -v /opt/ajentiserver/backup:/backup -v /opt/ajentiserver/mysql:/var/lib/mysql -e MYSQL_ADMIN_PASSWORD= -d babim/ajentiweb
```
