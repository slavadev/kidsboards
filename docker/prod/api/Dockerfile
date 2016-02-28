FROM phusion/passenger-ruby22

# nginx setup
RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default
ADD ./docker/prod/api/webapp.conf /etc/nginx/sites-enabled/webapp.conf
ADD ./docker/prod/api/webapp-env.conf /etc/nginx/main.d/webapp-env.conf

# bundler
RUN mkdir /home/app/webapp
WORKDIR /home/app/webapp
ADD api/Gemfile /home/app/webapp
ADD api/Gemfile.lock /home/app/webapp
RUN bundle install --path /home/app/bundle

# user setup
USER app
ENV HOME /home/app
RUN bundle install --path /home/app/bundle

# ending
USER root
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# scripts
#RUN mkdir -p /etc/my_init.d
#ADD ./docker/prod/api/add_rights.sh /etc/my_init.d/add_rights.sh
RUN usermod -u 1000 app

CMD ["/sbin/my_init"]

