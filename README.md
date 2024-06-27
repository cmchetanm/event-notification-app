# README

This README would normally document whatever steps are necessary to get the
application up and running.

## Requirements
  - Ruby 2.7.3
  - Libraries: bundler, postgres
## Dependencies
  - `bundle install`
## Configuration and setup
  - Set database username and password in 'credentials.yml.enc'
  - Add Itetable api-key in 'credentials.yml.enc'
    `EDITOR='code --wait' bin/rails credentials:edit`
  - Create and setup the database:
    `bundle exec rake db:create`
    `bundle exec rake db:setup`
## Run
  - Start server
    `bundle exec rails s`
  - And now you can visit the site with the URL http://localhost:3000
## Test
  - For runing test cases of the app
    `bundle exec rspec`
