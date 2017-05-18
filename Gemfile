if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

source "https://rubygems.org"
gemspec

# gem version to fix "NoMethodError: undefined method `set_table_name" for #<Class:..."
gem "i18n-active_record", git: "http://github.com/svenfuchs/i18n-active_record.git",
                          require: "i18n/active_record"

group :development, :test do
  gem "byebug"
  gem "rspec-rails" # rspec in dev so the rake tasks run properly
  gem "faker" # rspec in dev so the rake tasks run properly
  gem "newrelic_rpm", "~> 3.18.1.330"
  gem "yarjuf"
  gem "spring" # Spring speeds up development by keeping your application running in the background.
               # Read more: https://github.com/rails/spring
end

group :development do
  gem "brakeman"
  gem "hirb"
  gem "powder"
  gem "listen", "3.0.5"  # Fix auf diese Version, weil danach ruby 2.2.3 vorrausgesetzt wird
  gem "pre-commit"
  gem "web-console", "2.3.0"
  gem "benchmark-ips"
end

group :test do
  gem "cucumber"
  gem "cucumber-rails", git: "https://github.com/cucumber/cucumber-rails.git", require: false
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
  gem "rb-fsevent"
  gem "growl"
  gem "launchy"
  gem "shoulda-matchers"
  gem "simplecov", require: false
end
