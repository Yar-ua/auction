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
- ActionMailer must be initialised for test auth comfirmation by email. API configured to send the confirmation e-mail via SMTP to localhost:1025, mailcatcher will catch email in development and test mode. Before the testing you must install and start mailcatcher (for testing authentication). See https://mailcatcher.me/



///
When you send reauest for creeting lot or other you must set header Content-type: application/json