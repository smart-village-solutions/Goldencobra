# encoding: utf-8

if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

source "https://rubygems.org"
gemspec

# jquery-rails is used by the dummy application
gem "jquery-rails"
gem "multi_json" # , "~> 1.3"
gem "devise", "~> 2.2.4" # , git: "https://github.com/plataformatec/devise.git"
gem "activeadmin", git: "https://github.com/ikusei/active_admin.git", require: "activeadmin"
gem "acts-as-taggable-on", "3.5.0"
gem "i18n-active_record", git: "https://github.com/svenfuchs/i18n-active_record.git", require: "i18n/active_record"
gem "execjs"

gem "friendly_id"
gem "omniauth"
gem "omniauth-openid"
gem "oa-oauth", require: "omniauth/oauth"
gem "oa-openid", require: "omniauth/openid"
gem "coffee-rails" # , "~> 3.2.0"
gem "uglifier", ">= 1.0.3"
gem "meta-tags", require: "meta_tags", git: "https://github.com/5minpause/meta-tags.git"
gem "paperclip" # , "= 3.0.4"
gem "sass-rails", "3.2.6"
gem "compass-rails"
gem "memcache-client"
gem "nokogiri" # , "~> 1.5.3"
gem "cancan"
# gem "cobweb" #https://github.com/stewartmckee/cobweb
# gem "link-checker"
# gem "linkchecker", git: "https://github.com/seb/linkchecker.git"

gem "rmagick"
gem "simple_enum"

gem "paper_trail"
gem "sunspot_rails"
gem "sunspot_solr"
gem "sidekiq", "3.2.1"
gem "sinatra", require: false
gem "slim"
gem "geokit"
gem "exifr"
gem "eventmachine", "~> 1.0.9.1"

gem "pdfkit"
gem "wkhtmltopdf-binary"

# fix this version to 3.x to avoid method missing errors with version >= 4.0.0
gem "liquid", "~> 3.0"

group :development, :test do
  gem "debugger"
  gem "rspec-rails" # rspec in dev so the rake tasks run properly
  gem "faker" # rspec in dev so the rake tasks run properly
  gem "newrelic_rpm"
  gem "yarjuf"
end

group :development do
  gem "brakeman"
  gem "hirb"
  gem "powder"
  gem "listen" # , "~> 2.0"
  gem "pre-commit"
end

group :test do
  # gem "mysql2"
  gem "cucumber"
  gem "cucumber-rails", "~> 1.4"
  gem "factory_girl"
  gem "factory_girl_rails"
  gem "database_cleaner"
  gem "capybara"
  gem "capybara-webkit"
  gem "selenium-webdriver"
  gem "rspec-core"
  gem "guard"
  gem "guard-rspec"
  gem "guard-cucumber"
  gem "guard-livereload"
  gem "rb-fsevent" # , "~> 0.9.1"
  gem "growl"
  gem "launchy"
  gem "shoulda-matchers"
  gem "simplecov", require: false
end
