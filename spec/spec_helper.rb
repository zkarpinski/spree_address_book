# Configure Rails Environment
ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'rspec/rails'
require 'database_cleaner'
require 'ffaker'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each {|f| require f }

# Requires factories defined in spree_core
require 'spree/core/testing_support/factories'
require 'spree/core/testing_support/controller_requests'
require 'spree/core/testing_support/authorization_helpers'
require 'spree/core/testing_support/preferences'
require 'spree/core/testing_support/flash'
require 'spree/core/url_helpers'


RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = false
  config.include Spree::Core::UrlHelpers
  config.include Devise::TestHelpers, :type => :controller

  config.before(:each) do
    if example.metadata[:js]
      DatabaseCleaner.strategy = :truncation, {
        :except => [
          'spree_countries',
          'spree_zones',
          'spree_zone_members',
          'spree_states',
          'spree_roles'
        ]
      }
    else
      DatabaseCleaner.strategy = :transaction
    end
  end

  config.before(:each) do
    DatabaseCleaner.start
    reset_spree_preferences

    # not sure exactly what is happening here, but i think it takes an iteration for the country data to load
    Spree::Config[:default_country_id] = Spree::Country.find_by_iso3('USA').id if Spree::Country.count > 0
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
