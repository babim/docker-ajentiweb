FROM babim/debianbase

MAINTAINER Babim "ducanh.babim@yahoo.com"

#Ajenti
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq  wget unzip && \
    echo 'deb http://packages.dotdeb.org jessie all' >> /etc/apt/sources.list.d/dotweb.list && \
    echo 'deb-src http://packages.dotdeb.org jessie all' >> /etc/apt/sources.list.d/dotweb.list && \
    wget http://www.dotdeb.org/dotdeb.gpg -O- |apt-key add – && \
    rm /etc/apt/apt.conf.d/docker-gzip-indexes && \
    wget -O- https://raw.github.com/ajenti/ajenti/1.x/scripts/install-debian.sh | sudo sh && \
    apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq ajenti-v ajenti-v-nginx ajenti-v-mysql ajenti-v-php-fpm php5-mysql ajenti-v-mail ajenti-v-nodejs ajenti-v-python-gunicorn ajenti-v-ruby-puma ajenti-v-ruby-unicorn 

#phpMyAdmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.5.2/phpMyAdmin-4.5.2-all-languages.zip && \
    unzip phpMyAdmin-4.5.2-all-languages.zip && \
    rm -f phpMyAdmin-4.5.2-all-languages.zip && \
    mv phpMyAdmin-4.5.2-all-languages /opt/phpMyAdmin && \
ADD vh.json /etc/ajenti/vh.json

#Backups
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq backupninja duplicity
ADD backup /etc/backup.d/
RUN chmod 0600 /etc/backup.* -R

#Entrypoint
ADD entrypoint.sh /usr/sbin/entrypoint.sh
RUN chmod +x /usr/sbin/entrypoint.sh

#SFTP

RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq openssh-server 

RUN grep -v "Subsystem sftp /usr/lib/openssh/sftp-server" /etc/ssh/sshd_config > /etc/ssh/sshd_config2 && mv /etc/ssh/sshd_config2 /etc/ssh/sshd_config
RUN echo "Subsystem sftp internal-sftp" >> /etc/ssh/sshd_config
RUN echo "Match group www-data" >> /etc/ssh/sshd_config
RUN echo "ChrootDirectory /var/www/" >> /etc/ssh/sshd_config
RUN echo "X11Forwarding no" >> /etc/ssh/sshd_config
RUN echo "AllowTcpForwarding no" >> /etc/ssh/sshd_config
RUN echo "ForceCommand internal-sftp" >> /etc/ssh/sshd_config

RUN useradd -m -g www-data sftpuser

RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y

#RUN chown root:www-data /srv/
#RUN chmod 775 /srv/

ENV LC_ALL C.UTF-8
EXPOSE 80 8000 443 3306 22

CMD ["/usr/sbin/entrypoint.sh"]
