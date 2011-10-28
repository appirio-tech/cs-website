# CloudSpokes (on Rails!)

This application is not a pixel-for-pixel or same-HTML remake of
Cloudspokes. This was an intentional decision as it has been built with
the same look and feel but using semantic HTML5 as well as Sprockets,
SASS, and CSS3.

The application is on a clean skeleton and is set up for RSpec testing.
To run the application, you can simply run `rails server`. It is also
complete with a Gemfile, Guardfile for test automation, and more.

Basically this is a shell application that gives you everything you need
to get up and running. It should deploy to Heroku great as-is.

## Pages

The pages that are available are:

1. Home Page (dynamic content excluded)
2. About Page ("how it works" link)
3. FAQs
4. Privacy Policy
5. Terms of Service

The application is configured to run on http://127.0.0.1:3000 if you want to use OAuth. It uses the CloudSpokes *sandbox* org and not a developer org. 

It uses a small sqlite3 database to store some values. It is primarily need to store the access_token for the public user. This will probably be changes to a different persistence mechanism; this is temp for development. 

Beware! Both the sandbox org and this site are constantly changing so check out the latest before working on any challenges with it. 

Check config/initializers/development_settings.rg for required variables and credentials.