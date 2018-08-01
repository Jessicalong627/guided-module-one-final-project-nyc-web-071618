require 'bundler'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'

require_relative 'key'
ActiveRecord::Base.logger = nil
#puts API_KEY
#API_KEY = YAML::load( File.open('config/application.yml') )
