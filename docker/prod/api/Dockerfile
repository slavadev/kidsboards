FROM phusion/passenger-ruby23

RUN apt-get update
RUN apt-get install -y imagemagick

# bundler
USER app
RUN mkdir /home/app/webapp
WORKDIR /home/app/webapp
ADD api/Gemfile /home/app/webapp
ADD api/Gemfile.lock /home/app/webapp
RUN bundle install
ADD api /home/app/webapp

# back to root
USER root

# Loggly setup
RUN mkdir /home/app/logs
RUN apt-get install -y rsyslog telnet wget
ADD ./docker/prod/api/loggly/configure-linux.sh /configure-linux.sh
ADD ./docker/prod/api/loggly/21-nginx-loggly.conf /etc/rsyslog.d/21-nginx-loggly.conf
ADD ./docker/prod/api/loggly/21-rails-loggly.conf /etc/rsyslog.d/21-rails-loggly.conf

# nginx setup
RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default
RUN rm /etc/nginx/nginx.conf
ADD ./docker/prod/api/nginx/nginx.conf /etc/nginx/nginx.conf
ADD ./docker/prod/api/nginx/webapp.conf /etc/nginx/sites-enabled/webapp.conf
ADD ./docker/prod/api/nginx/webapp-env.conf /etc/nginx/main.d/webapp-env.conf

# ending
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# scripts
RUN usermod -u 1000 app
RUN mkdir -p /etc/my_init.d
ADD ./docker/prod/api/run/curl_to_warmup.sh /etc/my_init.d/curl_to_warmup.sh
ADD ./docker/prod/api/run/prepare_loggly.sh /etc/my_init.d/prepare_loggly.sh
ADD ./docker/prod/api/run/run_unicorn.sh /etc/my_init.d/run_puma.sh

CMD ["/sbin/my_init"]

