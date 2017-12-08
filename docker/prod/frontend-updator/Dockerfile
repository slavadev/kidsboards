FROM node
WORKDIR /home/app/static
RUN apt-get update
RUN apt-get install -y ruby ruby-dev
RUN gem install sass
RUN npm install -g bower
RUN npm install -g gulp
