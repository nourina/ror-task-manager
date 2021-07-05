# README


Getting started

* Ruby version : 3.0.1
* Rails Version: 6.1.4

To get the Rails server running locally:

Clone this repo:
bundle install  - to install all req'd dependencies
rake db:migrate  - to make all database migrations
rails s   -  to start the local server

Code Overview:

Dependencies:
Devise - For implementing authentication

Folders:

app/models - Contains the database models for the application where we can define methods, validations, queries, and relations to other models.
app/views - Contains templates for generating the HTML,JSON output for the API
app/controllers - Contains the controllers where requests are routed to their actions, where we find and manipulate our models and return them for the views to render.
config - Contains configuration files for our Rails application and for our database, along with an initializers folder for scripts that get run on boot.
db - Contains the migrations needed to create our database schema.



