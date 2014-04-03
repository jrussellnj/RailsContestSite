# RTO+P Rails Contest Site Boilerplate
This project is a fast-start boilerplate for creating a contest Ruby on Rails site with entries and prizes. It's designed to be highly compatible with the common development practices at [Red Tettemer O'Connell + Partners](http://rtop.com) in Philadelphia. 

## What's included
- A boilerplate Gemfile with our most commonly used gems.
- HTML5 Boilerplate (with normalize.css, modernizr, and log() js function for IE-friendly console.loggin'.) 
- SCSS-ified application.css
- A basic index action in a home controller.
- A good boilerplate .gitignore.
- AppEnv module for easier local dev/test config var access.
- App pre-configured to use the Unicorn HTTP server on Heroku with 3 workers per dyno.

## Contest-related inclusions
- An Entry model for holding entries with name, email address, and media (i.e., photo or video)
- A Prize model for holding contest prizes, including a name and media (i.e. photo of the prize)
- ActiveAdmin for viewing and modifying entries and prizes
- The Zencoder gem for encoding videos submitted with entries
- The Sendgrid gem for sending confirmation, etc, emails
