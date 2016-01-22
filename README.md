# Thatsaboy (WORK IN PROGRESS)

[![Code Climate](https://codeclimate.com/github/korolvs/thatsaboy/badges/gpa.svg)](https://codeclimate.com/github/korolvs/thatsaboy) 
[![Test Coverage](https://codeclimate.com/github/korolvs/thatsaboy/badges/coverage.svg)](https://codeclimate.com/github/korolvs/thatsaboy/coverage) 
[![Build Status](https://travis-ci.org/korolvs/thatsaboy.svg)](https://travis-ci.org/korolvs/thatsaboy)
[![Documentation](http://img.shields.io/badge/docs-rdoc.info-blue.svg)](http://www.rubydoc.info/github/korolvs/thatsaboy/frames)

## About
**Make your kid manageable**

Thatsaboy is a website which helps you to manage your children.

**How it works?** 

 - Create the purpose for the kid, e.g. toy or trip
 - Establish how much points is needed to reach the aim
 - Assign points for good acts and withdraw for bad
 - Watch how your kid is getting better

With bright illustrations **Thatsaboy** makes this process more interesting for children.

## Progress

Backend - 80%

Frontend - 0%

## Used tools

### Backend
 - [Ruby on Rails](http://rubyonrails.org/)
 - [PostgreSQL](http://www.postgresql.org/)
 - [Minitest](https://github.com/seattlerb/minitest) for testing
 - [YARD](http://yardoc.org/) for documentation
 - [Docker](https://www.docker.com/) for easy setup and great portability

### Frontend 
 - [AngularJS](https://angularjs.org/)
 - [PostCSS](https://github.com/postcss/postcss)
 - [Gulp](http://gulpjs.com/) for automatization

## Documentation
[Docs on rubydoc.info](http://www.rubydoc.info/github/korolvs/thatsaboy/frames)
 
## Prerequisites
 - [Install Docker](http://docs.docker.com/linux/started/)
 - [Install Docker Compose](http://docs.docker.com/compose/install/)
 
## Usage
Build 

```
docker-compose build
``` 

and run 

```
docker-compose up
```

## Backend Tests
Build 

```
docker-compose build
```

and run 

```
docker-compose run api bundle exec rake test
```
