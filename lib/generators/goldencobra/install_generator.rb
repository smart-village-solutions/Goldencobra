# encoding: utf-8

require 'securerandom'

module Goldencobra
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc "Creates active_admin initializer, routes and copy locale files to your application."
      class_option :orm

      def install_local_rvm
        if yes?("Would you like to configure a .rvmrc file?")
          @ruby_version = ask("What is your current ruby version (default: 1.9.3-p194)")
          @ruby_version = "1.9.3-p194" if @ruby_version.blank?
          template '../templates/rvmrc.erb', '.rvmrc'
          system("/bin/bash -ce '[[ -s \"$HOME/.rvm/scripts/rvm\" ]] && source \"$HOME/.rvm/scripts/rvm\" && rvm use #{@ruby_version}@#{Rails.application.class.parent_name} --create'")
        end
      end

      def install_test_env
        if yes?("Would you like to install a test Environment")
          gem("rspec-rails", '~> 2.12.2', :group => "test")
          gem("annotate", :group => "test")
          gem("ruby-graphviz", :group => "test")
          gem("mysql2", :group => "test")
          gem("cucumber", :group => "test")
          gem("cucumber-rails", :group => "test", :require => false)
          gem("factory_girl", :group => "test")
          gem("factory_girl_rails", :group => "test")
          gem("database_cleaner", :group => "test")
          gem("capybara", :group => "test")
          gem("capybara-webkit", :group => "test")
          gem("guard", :group => "test")
          gem("guard-rspec", :group => "test")
          gem("guard-cucumber", :group => "test")
          gem("guard-livereload", :group => "test")
          gem("rb-fsevent", '~> 0.9.1', :group => "test")
          gem("growl", :group => "test")
          gem("launchy", :group => "test")
          gem("faker", :group => "test")
          gem("email_spec", :group => "test")
          gem("shoulda-matchers", :group => "test")
          system("bundle install")
        end
      end

      def modify_production_env
        line = "config.assets.compile = false"
        gsub_file 'config/environments/production.rb', /(#{Regexp.escape(line)})/mi do |match|
          "config.assets.compile = true"
        end
      end

      def modify_application_rb
        line = "config.active_record.whitelist_attributes = true"
        gsub_file 'config/application.rb', /(#{Regexp.escape(line)})/mi do |match|
          "config.active_record.whitelist_attributes = false"
        end

        line = "class Application < Rails::Application"
        gsub_file 'config/environments/production.rb', /(#{Regexp.escape(line)})/mi do |match|
          "class Application < Rails::Application"
          "  require 'pdfkit'"
          "  config.middleware.use PDFKit::Middleware, :print_media_type => true"
        end

      end

      def install_gems
        gem('acts-as-taggable-on', :git => 'git://github.com/mbleigh/acts-as-taggable-on')
        gem('meta-tags', :git => 'git://github.com/jazzgumpy/meta-tags.git')
        #gem('compass-960-plugin')
        #gem('progress_bar')
        #gem('compass-rails')
        #gem('mysql2')
        system("bundle install")
      end

      def copy_initializer
        @underscored_user_name = "user".underscore
        template '../templates/active_admin.rb.erb', 'config/initializers/active_admin.rb'
      end

      def install_assets
        require 'rails'
        require 'active_admin'
        remove_file "app/assets/stylesheets/application.css"
        directory "../templates/assets", "app/assets"
        directory "../templates/views", "app/views"
        template '../templates/extend_goldencobra_articles_controller.rb', 'app/controllers/extend_goldencobra_articles_controller.rb'
        remove_file "public/index.html"
        copy_file '../templates/robots.txt', 'public/robots.txt'
      end

      def setup_routes
        route "mount Goldencobra::Engine => '/'"
        route "devise_for :users, ActiveAdmin::Devise.config"
        route "devise_for :visitors"
        route "ActiveAdmin.routes(self)"
      end

      def self.source_root
        File.expand_path("../templates", __FILE__)
      end

      def install_optional_assets
        gem("better_errors", :group => "development")
        gem("binding_of_caller", :group => "development")
        system("bundle install")
      end

      def install_errbit
          gem("airbrake")
          system("bundle install")
          @api_key = ask("What is your Errbit API key? (default: 1eacfe13fb5d9eca2dee5401a9b93ddb)")
          @api_key = "1eacfe13fb5d9eca2dee5401a9b93ddb" if @api_key.blank?

          @host = ask("What is your Errbit Host? (default: errors.ikusei.de)")
          @host = "errors.ikusei.de" if @host.blank?

          @port = ask("What is your Errbit Port? (bsp: 80 default | 443 secure )")
          @port = "80" if @port.blank?
          template '../templates/errbit.rb.erb', 'config/initializers/errbit.rb'
      end

      def install_newrelic
        if yes?("Would you like to install NewRelic? (www.newrelic.com)")
          gem("newrelic_rpm", "3.5.5.38")
          system("bundle install")
          @license_key = ask("What is your NewRelic license key? (default: b199ad3e4e0d728b1aac69aec4870af7ef9478bb)")
          @license_key = "b199ad3e4e0d728b1aac69aec4870af7ef9478bb" if @license_key.blank?
          template '../templates/newrelic.yml.erb', 'config/newrelic.yml'
        end
      end

      def create_admin_user_password
        @admin_email = ask("Please enter a email for your admin account (default: admin@goldencobra.de):")
        @admin_email = "admin@goldencobra.de" if @admin_email.blank?

        @admin_password = ask("Please enter a new password for admin account (user: #{@admin_email}):")
        template '../templates/seeds.rb.erb', "db/seeds.rb"
        if yes?("Would you like to create your local db?")
          system("bundle install")
          rake("db:create")
        end
        rake("goldencobra:install:migrations")
        if yes?("Would you like to migrate your local db?")
          rake("db:migrate")
        end
        if yes?("Would you like to seed your local db?")
          rake("db:seed")
        end
      end

      def install_capistrano
        if yes?("Would you like to configure git?")
          @git_url = ask("What is your git url? (bsp: ssh://git@git.ikusei.de:7999/KLIMA/website.git)")
          git :init
          git :remote => "add origin #{@git_url}"
          git :add => "."
          git :commit => "-m 'First commit'"
          git :push => "origin master"
        end
        if yes?("Would you like to configure capistrano? (a git repository is required)")
          @ip_address = ask("To which IP do you want to deploy? (bsp: Taurus 178.23.121.27)")
          if @git_url.blank?
            @git_url = ask("What is your git url? (bsp: ssh://git@git.ikusei.de:7999/KLIMA/website.git)")
          end
          @app_name = Rails.application.class.parent_name.parameterize.underscore
          capify!
          remove_file "config/deploy.rb"
          template '../templates/deploy.rb.erb', 'config/deploy.rb'

          #Add Changes to git
          git :add => "."
          git :commit => "-m 'Deploy files added'"
          git :push => "origin master"
        end
        if yes?("Would you like to configure your server and deploy to it?")
          copy_file '../templates/create_database.mysql.erb', 'config/templates/create_database.mysql.erb'
          copy_file '../templates/database.yml.erb', 'config/templates/database.yml.erb'
          template '../templates/apache.tmpl.erb', "config/templates/#{@app_name}"
          system("bundle install")

          #Add Changes to git
          git :add => "."
          git :commit => "-m 'Server configuration files added'"
          git :push => "origin master"

          system("cap deploy:create_gemset")
          system("cap deploy:setup")
          if yes?("Would you like to create remote database?")
            system("cap deploy:db:setup")
          end
          system("cap deploy")
          if yes?("Would you like to seed your remote db?")
            system("cap deploy:seed")
          end
          if yes?("Would you like to configure apache on your server?")
            system("cap deploy:apache_setup")
          end
        end
      end

    end
  end
end
