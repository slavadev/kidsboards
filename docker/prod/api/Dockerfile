FROM phusion/passenger-ruby22

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

# back to root
USER root

# nginx setup
RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default
RUN rm /etc/nginx/nginx.conf
ADD ./docker/prod/api/nginx.conf /etc/nginx/nginx.conf
ADD ./docker/prod/api/webapp.conf /etc/nginx/sites-enabled/webapp.conf
ADD ./docker/prod/api/imageresizer.conf /etc/nginx/sites-enabled/imageresizer.conf
ADD ./docker/prod/api/upload.conf /etc/nginx/sites-enabled/upload.conf
ADD ./docker/prod/api/webapp-env.conf /etc/nginx/main.d/webapp-env.conf

# ending
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# scripts
RUN usermod -u 1000 app

CMD ["/sbin/my_init"]

