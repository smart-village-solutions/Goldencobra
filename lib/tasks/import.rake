namespace :db do
  desc 'Import Production Database to local Database'
  task :import => :environment do
    local_db = ENV['LOCAL']
    remote_db = ENV['REMOTE']
    user_name = ENV['USER']
    password = ENV['PASSWORD']
    server = ENV['SERVER']
    if local_db.present? &&
      system("ssh -C #{server} mysqldump --opt --add-drop-table -hlocalhost -u#{user_name} -p#{password} #{remote_db} |mysql #{local_db}")
    else
      puts "Missing Attributes! e.g.:"
      puts "rake db:import SERVER=taurus LOCAL=qvnia_development REMOTE=db_qvnia USER=user_qvnia PASSWORD=yq1rx5qiHIz"
    end
  end
end