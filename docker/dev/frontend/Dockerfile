FROM node
WORKDIR /api/public
RUN apt-get update
RUN apt-get install -y ruby
RUN gem install sass
#ADD frontend/package.json /api/public/package.json
#ADD frontend/bower.json /api/public/bower.json
RUN npm install -g bower
RUN npm install -g gulp
