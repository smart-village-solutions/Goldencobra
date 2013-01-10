require 'securerandom'

module Goldencobra
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc "Creates active_admin initializer, routes and copy locale files to your application."
      class_option :orm

      def install_gems
        gem('activeadmin', :git => 'git://github.com/ikusei/active_admin.git', :require => 'activeadmin')
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


    end
  end
end
