source "http://rubygems.org"
gemspec

# jquery-rails is used by the dummy application
gem "jquery-rails"


gem 'devise', :git => "git://github.com/plataformatec/devise.git"
gem 'activeadmin', :git => "git://github.com/ikusei/active_admin.git", :require => "activeadmin"
gem 'sunspot_solr', :git => 'https://github.com/sunspot/sunspot'
gem 'execjs'
gem 'therubyracer'
gem "friendly_id"
gem 'omniauth'
gem 'omniauth-openid'
gem 'oa-oauth', :require => 'omniauth/oauth'
gem 'oa-openid', :require => 'omniauth/openid'
gem 'coffee-rails', '~> 3.2.0'
gem 'uglifier', '>= 1.0.3'
gem 'meta-tags', :require => 'meta_tags'
gem "paperclip"
gem 'sass-rails'
gem 'compass-rails'
gem 'memcache-client'
gem 'nokogiri', '~> 1.5.3'

gem "rspec-rails", :group => [:test, :development] # rspec in dev so the rake tasks run properly
gem "faker", :group => [:test, :development] # rspec in dev so the rake tasks run properly
gem "paper_trail"
gem 'sunspot_rails'
gem 'sunspot_solr'

group :development do
  gem 'thin'
  #gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
  gem 'guard-annotate'
  gem 'pry'
  gem 'pry-nav'
  gem 'brakeman'
  gem 'hirb'
  #gem 'git-pivotal', '~> 0.8.2'
  gem "powder"
end

group :test do
  gem 'mysql2'
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'factory_girl'
  gem "factory_girl_rails"
  gem 'database_cleaner'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'guard', '~> 1.1.1'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'guard-livereload'
  gem 'rb-fsevent', '~> 0.9.1' #:git => 'git://github.com/ttilley/rb-fsevent.git', :branch => 'pre-compiled-gem-one-off'
  gem 'growl'
  gem 'launchy'
  gem 'faker'
end
