mina-stack
===========

A compilation of several deploy scripts that I use for my rails apps. The stack I use is pretty standart,
but it may not suit your needs, so its not for everybody.
Current stack includes Nginx, Postgres, rbenv, Redis, Unicorn, Puma,
Sidekiq, Memcached, Imagemagick, ElasticSearch, Bower and Monit.

## Installation

```
gem 'mina-stack', github: 'div/mina-stack', group: :development
```

```
rails g mina:stack:install
```
to create default deploy.rb and servers/production.rb files

## Configuration

In your config/deploy.rb you can configure your stack - you may want to exclude something you may not need e.g. Private Pub,
and choose app server - unicorn and puma are supported. It is done by setting server_stack array, example config can be found in examples/deploy.rb.

All the default settings can be fond in lib/mina-stack/defaults.rb and can be overriden in deploy.rb

## Servers

Servers configs live in config/servers - example config is in examples/production.rb

## Monitoring

You can also set with services of your stack will be monitored by Monit - just use monitored array.

## Deploy

Create user on server
```
sudo adduser deploy
sudo adduser deploy sudo
su deploy
```
then copy your ssh keys
```
ssh-copy-id deploy@IPADDRESS
```
Install all the stack to the server
```
 bundle exec mina install
```
Create folder structure and copy all configs
```
bundle exec mina setup
```
Create db and set password
```
bundle exec mina postgresql:create_db
```
Deploy
```
bundle exec mina deploy
```
