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
- initialise Database: rake db:create, rake db:migrate, you can create seeds if you need (rake db:seed)

Testing:
- ActionMailer setted to send the confirmation e-mail via SMTP to localhost:1025.
- Before the testing you must install and start mailcatcher (for testing authentication). See https://mailcatcher.me/