namespace :db do
  desc 'Dump DB to backup.sql'
  task :dump => :environment do
    server_config = ActiveRecord::Base.configurations["production"]
    remote_db = server_config["database"]
    user_name = server_config["username"]
    password = server_config["password"]
    system("mysqldump --opt --add-drop-table -hlocalhost -u#{user_name} -p#{password} #{remote_db} > backup.sql")
  end


  desc 'Import Production Database to local Database'
  task :import => :environment do
    local_config = ActiveRecord::Base.configurations["development"]
    if defined?(Capistrano) == "constant"
      puts "Accassing remote configuration?"
      config = Capistrano::Configuration.new
      config.load("Capfile")
      config.logger.level = 1
      ssh_user = config[:user]
      ssh_server = config[:ip_address]
      puts "Connecting to #{ssh_user}@#{ssh_server}"
      system("cap invoke COMMAND='bundle exec rake db:dump'")
      puts "MysqlDump created on server: backup.sql"
      system("ssh -C #{ssh_user}@#{ssh_server} less backup.sql |mysql -u#{local_config['username']} -p#{local_config['password']} #{local_config['database']}")
      puts "Dumpfile copied and transfered to local DB: #{local_config['database']}"
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

  end
end