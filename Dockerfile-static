FROM phusion/passenger-nodejs

RUN mkdir /home/app/webapp
RUN mkdir /home/app/logs

# nginx setup
RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default
RUN rm /etc/nginx/nginx.conf
ADD ./docker/prod/static/nginx.conf /etc/nginx/nginx.conf
ADD ./docker/prod/static/webapp.conf /etc/nginx/sites-enabled/webapp.conf
ADD ./docker/prod/static/webapp-env.conf /etc/nginx/main.d/webapp-env.conf

# npm
RUN mkdir /home/app/static
RUN mkdir /home/app/static-build
WORKDIR /home/app/static-build
RUN apt-get update
RUN apt-get install -y npm
RUN apt-get install -y ruby
RUN gem install sass
RUN npm install -g bower
RUN npm install -g gulp
ADD ./frontend/package.json /home/app/static-build
RUN npm install
ADD ./frontend/bower.json /home/app/static-build
RUN bower install --allow-root
ADD ./frontend /home/app/static-build
RUN gulp build

ADD ./docker/prod/static/copy_files.sh /etc/my_init.d/copy_files.sh

# ending
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/sbin/my_init"]
