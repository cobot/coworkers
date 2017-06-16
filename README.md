## Running in development

* create an app on Cobot where the app url is http://localhost:3001
* copy the .env.example and fill in the variables
* start with `rails s -p 3001`
* go to http://localhost:3001

## How to update cobot_assets (bump version)

* Download latest cobot_assets gem from https://github.com/upstream/cobot_assets/releases to coworkers repo
* In command line: `gem install cobot_assets-VERSION.gem`
* Open Gemfile and bump version number
* In command line: bundle
* restart server
* compile CSS

## Maintenance
* there is a rake task to remove inactive members if the web hook failed
