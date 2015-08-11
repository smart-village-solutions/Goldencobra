# unless ::Rails.root.to_s.include?("/test/dummy")
#   if File.exists?(File.join(::Rails.root,"db","migrate"))
#     all_files_exists = []
#     Dir.foreach(File.join(Goldencobra::Engine.root,"db", "migrate")) do |f|
#       file_to_search = f.to_s.split(".")[0].to_s.split("_")[1..-1].to_a.join("_")
#       single_all_files_exists = []
#       Dir.foreach(File.join(::Rails.root,"db", "migrate")) do |g|
#         compare_with = g.to_s.split(".")[0].to_s.split("_")[1..-1].to_a.join("_")
#         if compare_with == file_to_search
#           single_all_files_exists << true
#         else
#           single_all_files_exists << false
#         end
#       end
#       all_files_exists << single_all_files_exists.include?(true)
#     end
#     if all_files_exists.include?(false)
#       raise "There are new migrations to install: rake goldencobra:install:migrations"
#     end
#   end
# end
