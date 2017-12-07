# Kids Boards

[![Maintainability](https://api.codeclimate.com/v1/badges/c8ef4b9ea9f1da15cdb1/maintainability)](https://codeclimate.com/github/korolvs/kidsboards/maintainability)
[![Build Status](https://travis-ci.org/korolvs/kidsboards.svg)](https://travis-ci.org/korolvs/kidsboards)
[![Documentation](http://img.shields.io/badge/docs-rdoc.info-blue.svg)](http://www.rubydoc.info/github/korolvs/kidsboards/frames)

## About

Kids Boards helps you to transforms your kid's goals into a game with four small steps:

 - Add a goal which your child wants to achieve
 - Set how many "points" are needed to reach the goal
 - Add points or remove them depends on results
 - Celebrate when the goal is achieved!

## Used tools

### Backend
 - [Ruby on Rails](http://rubyonrails.org/)
 - [Unicorn](https://unicorn.bogomips.org/)
 - [Nginx](http://nginx.org/)
 - [HAProxy](http://www.haproxy.org/)
 - [PostgreSQL](http://www.postgresql.org/)
 - [Minitest](https://github.com/seattlerb/minitest)
 - [YARD](http://yardoc.org/)
 - [Docker](https://www.docker.com/)

### Frontend
 - [AngularJS](https://angularjs.org/)
 - [SASS](http://sass-lang.com/)
 - [Gulp](http://gulpjs.com/)

## Documentation
 - API Reference ([RubyDoc](http://www.rubydoc.info/github/korolvs/kidsboards/file/api/API.md), [GitHub](https://github.com/korolvs/kidsboards/blob/master/api/API.md))
 - [Docs on rubydoc.info](http://www.rubydoc.info/github/korolvs/kidsboards/frames)

## Prerequisites
 - [Install Docker](http://docs.docker.com/linux/started/)
 - [Install Docker Compose](http://docs.docker.com/compose/install/)

## Usage

### Development

Build

```
docker-compose -f dev.yml build
docker-compose -f dev.yml run dbcreator
docker-compose -f dev.yml run migrator
```

Test

```
docker-compose -f dev.yml run tester
```

Run

```
docker-compose -f dev.yml up
```

### Production

Build

```
docker-compose build
```

Run

```
docker-compose up
```
