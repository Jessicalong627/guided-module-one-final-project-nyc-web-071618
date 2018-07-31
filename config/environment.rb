require 'bundler'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'
require 'yaml'

application_data = YAML::load(File.open('config/application.yml'))

Api.apikey = application_data["API_KEY"]

puts Api.apikey
