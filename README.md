mina-stack
===========

A compilation of several deploy scripts that I use for my rails apps. The stack I use is pretty standart,
but it may not suit your needs, so its not for everybody.
Current stack includes Nginx, Postgres, rbenv, Redis, Unicorn, Puma,
Sidekiq, Memcached, Imagemagick, ElasticSearch, Bower and Monit.

## Installation

You will need mina installed, then
just clone this repo in your lib directory as a submodule with
```
git submodule add git://github.com/div/mina-stack.git lib/mina-stack
```

and add

```
require 'mina-stack/mina-stack'
```

to deploy.rb

## Configuration

In your config/deploy.rb you can configure your stack - you may want to exclude something you may not need e.g. Private Pub,
and choose app server - unicorn and puma are supported. It is done by setting server_stack array, example config can be found in examples/deploy.rb.

All the default settings can be fond in lib/mina-stack/defaults.rb and can be overriden in deploy.rb

## Servers

Servers configs live in config/servers - example config is in examples/production.rb

## Monitoring

You can also set with services of your stack will be monitored by Monit - just use monitored array.

## Deploy

1. Create user on server and path to the app e.g. ~/apps/mycoolApp
2. Add server settings to servers/production.rb and paths to shared_paths array
3. run mina install - to install all the stack to the server
4. run mina initial_setup to create folder structure
5. run mina deploy

