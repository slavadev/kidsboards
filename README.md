# Thatsaboy (WORK IN PROGRESS)

[![Code Climate](https://codeclimate.com/github/korolvs/thatsaboy/badges/gpa.svg)](https://codeclimate.com/github/korolvs/thatsaboy) 
[![Test Coverage](https://codeclimate.com/github/korolvs/thatsaboy/badges/coverage.svg)](https://codeclimate.com/github/korolvs/thatsaboy/coverage) 
[![Build Status](https://travis-ci.org/korolvs/thatsaboy.svg)](https://travis-ci.org/korolvs/thatsaboy)
[![Documentation](http://img.shields.io/badge/docs-rdoc.info-blue.svg)](http://www.rubydoc.info/github/korolvs/thatsaboy/frames)

## About
**Make your kid manageable**

Thatsaboy is a website which helps you to manage your children.

**How it works?** 

 - Create a purpose for the kid, e.g. toy or trip
 - Establish how much points is needed to reach the goal
 - Add points for good acts and remove for bad
 - Watch how your kid is getting better

With bright illustrations **Thatsaboy** makes this process more interesting for children.

## Progress

Backend - 95%

Frontend - 10%

## Used tools

### Backend
 - [Ruby on Rails](http://rubyonrails.org/)
 - [Phusion Passenger](https://www.phusionpassenger.com/)
 - [Nginx](http://nginx.org/)
 - [PostgreSQL](http://www.postgresql.org/)
 - [Minitest](https://github.com/seattlerb/minitest)
 - [YARD](http://yardoc.org/)
 - [Docker](https://www.docker.com/)

### Frontend 
 - [AngularJS](https://angularjs.org/)
 - [PostCSS](https://github.com/postcss/postcss)
 - [Gulp](http://gulpjs.com/)

## Documentation
 - API Reference ([RubyDoc](http://www.rubydoc.info/github/korolvs/thatsaboy/file/api/API.md), [GitHub](https://github.com/korolvs/thatsaboy/blob/master/api/API.md))
 - [Docs on rubydoc.info](http://www.rubydoc.info/github/korolvs/thatsaboy/frames)
 
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
docker-compose -f dev.yml run api
```

### Production

Build 

```
docker-compose -f prod.yml build
``` 

Run

```
docker-compose -f prod.yml up
```