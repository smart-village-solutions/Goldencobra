if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

source "http://rubygems.org"
gemspec

# jquery-rails is used by the dummy application
gem "jquery-rails"

gem 'multi_json', "~> 1.3"
gem 'devise', "~> 2.2.4"#, :git => "git://github.com/plataformatec/devise.git"
gem 'activeadmin', :git => "git://github.com/ikusei/active_admin.git", :require => "activeadmin"
gem 'acts-as-taggable-on', :git => 'git://github.com/mbleigh/acts-as-taggable-on.git'
gem 'i18n-active_record', :git => 'git://github.com/svenfuchs/i18n-active_record.git', :require => 'i18n/active_record'
gem 'execjs'
gem 'therubyracer' #, '~> 0.10.2'
gem "friendly_id"
gem 'omniauth'
gem 'omniauth-openid'
gem 'oa-oauth', :require => 'omniauth/oauth'
gem 'oa-openid', :require => 'omniauth/openid'
gem 'coffee-rails', '~> 3.2.0'
gem 'uglifier', '>= 1.0.3'
gem 'meta-tags', :require => 'meta_tags', :git => "git://github.com/jazzgumpy/meta-tags.git"
# gem "cocaine", "= 0.3.2"
gem "paperclip"#, "= 3.0.4"
gem 'sass-rails'
gem 'compass-rails'
gem 'memcache-client'
gem 'nokogiri', '~> 1.5.3'
# gem 'cancan', "1.6.7"
gem 'cancan'
#gem 'cobweb' #https://github.com/stewartmckee/cobweb
#gem 'link-checker'
#gem 'linkchecker', :git => "git://github.com/seb/linkchecker.git"

gem "rspec-rails", :group => [:test, :development] # rspec in dev so the rake tasks run properly
gem "faker", :group => [:test, :development] # rspec in dev so the rake tasks run properly
gem "paper_trail"
gem 'sunspot_rails'
gem 'sunspot_solr'
gem 'sidekiq'
gem 'sinatra', :require => false
gem 'slim'
gem 'geokit'

gem 'pdfkit'
gem 'wkhtmltopdf-binary'

gem "better_errors", :group => "development"
gem "binding_of_caller", :group => "development"

group :development do
  gem 'thin'
  gem 'guard-annotate'
  gem 'pry'
  gem 'pry-nav'
  gem 'brakeman'
  gem 'hirb'
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
  #gem 'capybara-webkit', "0.14.2"
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'guard-livereload'
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'growl'
  gem 'launchy'
  gem 'faker'
  gem 'shoulda-matchers'
end
