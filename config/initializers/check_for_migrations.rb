unless ::Rails.root.to_s.include?("/test/dummy")
  all_files_exists = true
  Dir.foreach(File.join(Goldencobra::Engine.root,"db", "migrate")) do |f|
     all_files_exists = false if !File.exists?(File.join(::Rails.root,"db","migrate",f.split("_")[1..-1].join("_")))
  end
  if all_files_exists == false
    raise "There are new migrations to install: rake goldencobra:install:migrations"
  end
end
