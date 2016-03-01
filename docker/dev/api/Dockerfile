FROM ruby
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN mkdir /api
WORKDIR /api
ADD api/Gemfile /api/Gemfile
ADD api/Gemfile.lock /api/Gemfile.lock
RUN bundle install
ADD api /api
ADD docker/dev /docker
ADD .git /.git