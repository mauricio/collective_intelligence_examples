# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require 'spec'
require 'spec/rails'

module DefaultHelper
  
end

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = "#{File.dirname(__FILE__)}/../fixtures"
  config.include DefaultHelper
end
