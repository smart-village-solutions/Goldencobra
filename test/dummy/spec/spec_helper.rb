# encoding: utf-8

require 'simplecov'
SimpleCov.root(File.expand_path("../../", __FILE__))
SimpleCov.start :rails do
  filters.clear # This will remove the :root_filter and :bundler_filter that come via simplecov's defaults
  add_filter do |src|
    !(src.filename =~ /^#{SimpleCov.root}/) unless (src.filename =~ /app/ || src.filename =~ /config\/initializers/)
  end
  add_filter ".bundle"
  add_filter ".rbenv"
  add_filter "/spec/"
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'
require 'database_cleaner'
require "factory_girl_rails"
require 'test_helpers.rb'
require 'shoulda-matchers'
#require 'database_cleaner/cucumber'
DatabaseCleaner.strategy = :transaction

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  #config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
  config.include FactoryGirl::Syntax::Methods
  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  #config.infer_base_class_for_anonymous_controllers = false

  # Add this line if you use Devise for authentication:
  config.include Devise::TestHelpers, :type => :controller
  config.include Capybara::DSL
end
