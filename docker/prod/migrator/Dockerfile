FROM ruby

# bundler
RUN mkdir /home/app
RUN mkdir /home/app/webapp
WORKDIR /home/app/webapp
ADD api/Gemfile /home/app/webapp
ADD api/Gemfile.lock /home/app/webapp
RUN bundle install
ADD api /home/app/webapp

# logs
RUN mkdir /home/app/logs
