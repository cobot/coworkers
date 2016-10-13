## Running in development


* create an app on Cobot where the app url is http://localhost:3001
* copy the .env.example and fill in the variables
* start with `rails s -p 3001`
* go to http://localhost:3001

## How to update cobot_assets (bump version)

### In cobot_assets:

* Make changes in cobot_assets
* Bump version in version.rb (+1 for minor changes)
* save and commit
* In command line: gem build cobot_assets.gemspec
* copy cobot_assets-VERSION.gem to coworkers repo

### In coworkers:
* In command line: gem install cobot_assets-VERSION.gem
* Open gemfile and bump version number
* In command line: bundle
* restart server
* compile css

## Maintenance 
* there is a rake task to remove inactive members if the web hook failed