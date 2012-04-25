source "http://rubygems.org"
gemspec

# jquery-rails is used by the dummy application
gem "jquery-rails"

#gem 'sass-rails', "~> 3.2.1"
gem 'activeadmin', :git => "git://github.com/ikusei/active_admin.git", :require => "activeadmin"
gem 'execjs'
gem 'therubyracer'
gem "friendly_id", "~> 4.0.0.beta14", :require => "friendly_id"
gem 'omniauth'
gem 'omniauth-openid'
gem 'oa-oauth', :require => 'omniauth/oauth'
gem 'oa-openid', :require => 'omniauth/openid'
gem 'coffee-rails', '~> 3.2.0'
gem 'uglifier', '>= 1.0.3'
gem 'meta-tags', :require => 'meta_tags'
gem "paperclip"#, '~> 2.7'#, :git => "git://github.com/thoughtbot/paperclip.git", :require => 'paperclip'
gem 'sass-rails'
gem 'compass-rails'
gem 'memcache-client'
# gem 'nokogiri', '~> 1.5.2'

gem "rspec-rails", :group => [:test, :development] # rspec in dev so the rake tasks run properly
gem "faker", :group => [:test, :development] # rspec in dev so the rake tasks run properly

group :development do
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
  gem 'guard-annotate'
  gem 'pry'
  gem 'git-pivotal'#, '~> 0.8.2'
end

group :test do
  gem 'sqlite3'
  gem 'cucumber'
  gem 'cucumber-rails', '~>1.3.0'
  gem 'factory_girl', '~> 3.1.0'
  gem "factory_girl_rails", "~> 3.1.0"
  gem 'database_cleaner'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'guard-livereload'
  gem 'rb-fsevent', :git => 'git://github.com/ttilley/rb-fsevent.git', :branch => 'pre-compiled-gem-one-off'
  gem 'growl'
  gem 'launchy'
  gem 'faker'
end
