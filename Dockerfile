FROM 32bit/ubuntu:14.04

RUN apt-get update -y && \
    apt-get install -y \
    nginx openssh-server supervisor vim \
    php5-common php5-cli php5-fpm curl openssl

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=bin

#config ssh
RUN mkdir -p /var/log/supervisor /var/run/sshd
RUN echo 'root:root' |chpasswd
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ADD config/nginx.conf /opt/etc/nginx.conf
ADD config/laravel /etc/nginx/sites-available/laravel
RUN ln -s /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/laravel && \
    rm /etc/nginx/sites-enabled/default

ADD config/nginx-start.sh /opt/bin/nginx-start.sh
RUN chmod u=rwx /opt/bin/nginx-start.sh

RUN mkdir -p /data
VOLUME ["/data"]


EXPOSE 22 80 443
CMD ["/usr/bin/supervisord"]