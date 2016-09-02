FROM phusion/passenger-ruby23

RUN mkdir /home/app/webapp
RUN mkdir /home/app/logs
WORKDIR /home/app/webapp

# nginx setup
RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default
RUN rm /etc/nginx/nginx.conf
ADD ./docker/prod/static/nginx.conf /etc/nginx/nginx.conf
ADD ./docker/prod/static/webapp.conf /etc/nginx/sites-enabled/webapp.conf
ADD ./docker/prod/static/upload.conf /etc/nginx/sites-enabled/upload.conf
ADD ./docker/prod/static/webapp-env.conf /etc/nginx/main.d/webapp-env.conf

# ending
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# scripts
RUN usermod -u 1000 app

CMD ["/sbin/my_init"]

