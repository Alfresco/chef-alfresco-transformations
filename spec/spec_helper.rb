require 'coveralls'
Coveralls.wear!

require 'chefspec'
require 'rspec'
require 'chefspec/berkshelf'

# Require all our libraries
Dir['libraries/*.rb'].each { |f| require File.expand_path(f) }

RSpec.configure do |config|
  config.log_level = :error
end
