# Rails Heroku Mailgun

General purpose Rails API mailer on Heroku for sending email via mailgun.

## Installation 

```bash
$ git clone https://github.com/kgish/rails-heroku-mailgun.git
$ cd rails-heroku-mailgun
$ bundle install
```

## Dockerfile

```
FROM ruby:2.6.4

RUN apt-get update -qq && apt-get install -y build-essential

# for postgres
RUN apt-get install -y libpq-dev

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

ENV APP_HOME /myapp
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install
```
In order to build it:

```bash
$ docker build .
```

## Docker-compose.yml

```.yaml
version: '2'
services:
  db:
    image: postgres:9.4.1
    ports:
      - "5432:5432"

  web:
    build: .
    command: bin/rails server --port 3000 --binding 0.0.0.0
    ports:
      - "3001:3000"
    links:
      - db
    volumes:
      - .:/myapp
```

```bash
$ docker-compose build
$ docker-compose run web rake db:create db:setup
$ docker-compose up
```

## Interact via a Rails console

Running a Rails console is as simple as:

```bash
$ docker-compose run web rails console
```

## Run specs

```bash
$ docker-compose run web rake
```
