FROM babim/ubuntubase

MAINTAINER Babim "ducanh.babim@yahoo.com"

#Ajenti
RUN rm /etc/apt/apt.conf.d/docker-gzip-indexes && \
    wget -O- https://raw.github.com/ajenti/ajenti/1.x/scripts/install-debian.sh | sudo sh && \
    apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq ajenti-v ajenti-v-nginx ajenti-v-mysql ajenti-v-php-fpm \
    php5-mysql ajenti-v-mail ajenti-v-nodejs ajenti-v-python-gunicorn ajenti-v-ruby-puma ajenti-v-ruby-unicorn unzip

#phpMyAdmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.5.2/phpMyAdmin-4.5.2-all-languages.zip && \
    unzip phpMyAdmin-4.5.2-all-languages.zip && \
    rm -f phpMyAdmin-4.5.2-all-languages.zip && \
    mv phpMyAdmin-4.5.2-all-languages /opt/phpMyAdmin
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

RUN mkdir /var/run/sshd
# set password root is root
RUN echo 'root:root' | chpasswd
# allow root ssh
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN useradd -m -g www-data sftpuser

RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y

#RUN chown root:www-data /srv/
#RUN chmod 775 /srv/

# Define mountable directories.
VOLUME ["/var/www", "/data", "/etc/nginx/conf.d", "/backup", "/var/lib/mysql"]

ENV LC_ALL en_US.UTF-8
ENV TZ Asia/Ho_Chi_Minh
EXPOSE 80 8000 443 3306 22

CMD ["/usr/sbin/entrypoint.sh"]
