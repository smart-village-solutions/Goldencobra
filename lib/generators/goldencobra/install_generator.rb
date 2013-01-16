require 'securerandom'

module Goldencobra
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc "Creates active_admin initializer, routes and copy locale files to your application."
      class_option :orm

      def install_gems
        gem('acts-as-taggable-on', git: 'git://github.com/mbleigh/acts-as-taggable-on')
        gem('meta-tags', :git => 'git://github.com/jazzgumpy/meta-tags.git')
        gem('compass-960-plugin')
        gem('progress_bar')
        gem('compass-rails')
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
        end
      end

      def install_newrelic
        if yes?("Would you like to install NewRelic? (www.newrelic.com)")
          gem("newrelic_rpm")
          @license_key = ask("What is your NewRelic license key? (bsp: b199ad3e4e0d728b1aac69aec4870af7ef9478bb)")
          template '../templates/newrelic.yml.erb', 'config/newrelic.yml'
        end
      end

      def create_admin_user_password
        admin_password = ask("What is your password for admin@goldencobra.de:")
        admin = User.find_by_email("admin@goldencobra.de")
        if admin
          admin.password = admin_password
          admin.password_confirmation = admin_password
          admin.save
        end
      end

      def install_capistrano
        if yes?("Would you like to configure capistrano?")
          capify!
          @ip_address = ask("To which IP do you want to deploy? (bsp: Taurus 178.23.121.27)")
          @git_url = ask("What is your git url? (bsp: ssh://git@git.ikusei.de:7999/KLIMA/website.git)")
          @app_name = Rails.application.class.parent_name.parameterize.underscore
          template '../templates/deploy.rb.erb', 'config/deploy.rb'
        end
        if yes?("Would you like to configure your server and deploy to it?")
          system("cap deploy:setup")
          system("cap deploy:setup:db")
          system("cap deploy")
        end
      end

    end
  end
end
