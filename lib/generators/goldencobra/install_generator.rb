require 'securerandom'

module Goldencobra
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc "Creates active_admin initializer, routes and copy locale files to your application."
      class_option :orm

      def install_local_rvm
        if yes?("Would you like to configure rvm?")
          @ruby_version = ask("What is your current ruby version (bsp: 1.9.3-p194)")
          template '../templates/rvmrc.erb', '.rvmrc'
          system("/bin/bash -ce '[[ -s \"$HOME/.rvm/scripts/rvm\" ]] && source \"$HOME/.rvm/scripts/rvm\" && rvm use #{@ruby_version}@#{Rails.application.class.parent_name} --create'")
        end
      end

      def install_gems
        gem('acts-as-taggable-on', git: 'git://github.com/mbleigh/acts-as-taggable-on')
        gem('meta-tags', :git => 'git://github.com/jazzgumpy/meta-tags.git')
        gem('compass-960-plugin')
        gem('progress_bar')
        gem('compass-rails')
        gem('activerecord-mysql2-adapter')
        system("bundle install")
      end

      def copy_initializer
        @underscored_user_name = "user".underscore
        template '../templates/active_admin.rb.erb', 'config/initializers/active_admin.rb'
      end

      def install_assets
        require 'rails'
        require 'active_admin'
        template '../templates/active_admin.js', 'app/assets/javascripts/active_admin.js'
        template '../templates/active_admin.css.scss', 'app/assets/stylesheets/active_admin.css.scss'
        template '../templates/extend_goldencobra_articles_controller.rb', 'app/controllers/extend_goldencobra_articles_controller.rb'
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

      # def create_migrations
        #rake("goldencobra:install:migrations")
        ##oder
        # generate("model", "#{name} #{model_attributes.join(' ')} article_id:integer")
        # Dir["#{self.class.source_root}/migrations/*.rb"].sort.each do |filepath|
        #   name = File.basename(filepath)
        #   template "migrations/#{name}", "db/migrate/#{name}"
        #   sleep 1
        # end
      # end

      def install_optional_assets
        if yes?("Would you like to install Better Errors?")
          gem("better_errors", :group => "development")
          gem("binding_of_caller", :group => "development")
          system("bundle install")
        end
      end

      def install_newrelic
        if yes?("Would you like to install NewRelic? (www.newrelic.com)")
          gem("newrelic_rpm")
          @license_key = ask("What is your NewRelic license key? (bsp: b199ad3e4e0d728b1aac69aec4870af7ef9478bb)")
          template '../templates/newrelic.yml.erb', 'config/newrelic.yml'
          system("bundle install")
        end
      end

      def create_admin_user_password
        admin_password = ask("What is your password for your local installation (user: admin@goldencobra.de):")
        admin = User.find_by_email("admin@goldencobra.de")
        if admin
          admin.password = admin_password
          admin.password_confirmation = admin_password
          admin.save
        end
      end


      def install_capistrano
        @use_git = false
        if yes?("Would you like to configure git?")
          @use_git = true
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
          if @use_git
            git :add => "."
            git :commit => "-m 'Deploy files added'"
            git :push => "origin master"
          end
        end
        if yes?("Would you like to configure your server and deploy to it?")
          #rvm gemset create 'installtestapp'
          #config/templates/create_database.mysql.erb
          copy_file '../templates/create_database.mysql.erb', 'config/templates/create_database.mysql.erb'
          copy_file '../templates/database.yml.erb', 'config/templates/database.yml.erb'
          template '../templates/apache.tmpl.erb', "config/templates/#{@app_name}"
          system("bundle install")
          if @use_git
            git :add => "."
            git :commit => "-m 'Server configuration files added'"
            git :push => "origin master"
          end
          system("cap deploy:create_gemset")
          system("cap deploy:setup")
          if yes?("Would you like to create remote database?")
            system("cap deploy:db:setup")
          end
          system("cap deploy")
          if yes?("Would you like to configure apache?")
            system("cap deploy:apache_setup")
          end
        end
      end

    end
  end
end
