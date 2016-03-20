FROM node
RUN npm install -g gulp-cli \
    && apt-get update \
    && apt-get install -y ruby \
    && gem install sass
WORKDIR /api/public
