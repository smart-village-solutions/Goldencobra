# encoding: utf-8

require 'securerandom'

module Goldencobra
  module Generators
    class ServerGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc "configure your remote server"
      class_option :orm


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
