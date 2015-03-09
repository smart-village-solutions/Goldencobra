# encoding: utf-8

namespace :db do
  desc 'Dump production DB to backup.sql'
  task :dump => :environment do
    server_config = ActiveRecord::Base.configurations["production"]
    remote_db = server_config["database"]
    user_name = server_config["username"]
    password = server_config["password"]
    system("nice -n15 mysqldump --opt --add-drop-table -hlocalhost -u#{user_name} -p#{password} #{remote_db} > backup.sql")
  end


  desc 'Import remote production database to local database'
  task :import => :environment do
    puts "Your lokal database will be overwritten by server db! Are you sure? (yes)"
    input = STDIN.gets.strip
    if ["yes", "Yes", "Y", "y", "YES"].include?(input)
      local_config = ActiveRecord::Base.configurations["development"]
      if defined?(Capistrano) == "constant"
        puts "Loading remote configuration..."
        config = Capistrano::Configuration.new
        config.load("Capfile")
        config.logger.level = 1
        ssh_user = config[:user]
        ssh_server = config[:ip_address]
        deploy_to = config[:deploy_to]
        puts "Connecting to #{ssh_user}@#{ssh_server} and generating db dump..."
        system("cap invoke COMMAND='cd #{deploy_to}/current && RAILS_ENV=production bundle exec rake db:dump'")
        puts "MysqlDump created on server as 'backup.sql'. Transfering data..."
        local_db_password = ""
        if local_config['password'].present?
          local_db_password = "-p#{local_config['password']}"
        end
        system("ssh -C #{ssh_user}@#{ssh_server} less #{deploy_to}/current/backup.sql |mysql -u#{local_config['username']} #{local_db_password} #{local_config['database']}")
        puts "Dumpfile copied and transfered to local DB: #{local_config['username']}@#{local_config['database']}"
      else
        remote_db = ENV['REMOTE']
        user_name = ENV['USER']
        password = ENV['PASSWORD']
        server = ENV['SERVER']
        if server.present? &&
          system("ssh -C #{server} mysqldump --opt --add-drop-table -hlocalhost -u#{user_name} -p#{password} #{remote_db} |mysql -u#{local_config['username']} -p#{local_config['password']} #{local_config['database']}")
        else
          puts "Missing Attributes! e.g.:"
          puts "rake db:import SERVER=taurus REMOTE=db_qvnia USER=user_qvnia PASSWORD=yq1rx5qiHIz"
        end
      end
    else
      puts "Import-Task aborted"
    end
  end

  namespace :schema do
    
    desc 'Regenerates data in table schema_migrations from local files in /db/migrate'
    task :regnerate => :environment do
    end

  end


end