# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

General instruction:
- clone this repository (git clone ...)
- install redis-server, sidekiq and other gems, what app need
- initialise Database: rake db:create, rake db:migrate, you can create seeds if you need (rake db:seed)
- run 'redis-server'
- run 'sidekiq -q high' 	# inportant! must be '-q high'
	('-q high' is for setting name of queue. On this auction name of queue is "high". If you start sidekiq without configs - will be started with queue name as "default")
- run 'rails-server'
- enjoy :)