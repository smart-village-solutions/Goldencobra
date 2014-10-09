class SetDbAndTablesToUtf8 < ActiveRecord::Migration
  def up
    db_config = ActiveRecord::Base.connection.instance_values["config"]
    db_name = db_config[:database]
    
    puts "ALTER DATABASE #{db_name} TO utf8..."
    execute("ALTER DATABASE #{db_name} CHARACTER SET utf8 COLLATE utf8_general_ci;")
    puts "done"
    
    ActiveRecord::Base.connection.tables.each do |table|
      puts "ALTER TABLE #{table} TO utf8..."
      execute("ALTER TABLE #{table} CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;")
    end
    puts "done"
  end

  def down
    puts "Nothing to revert..."
  end
end
