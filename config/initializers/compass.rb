# require 'compass'
# require 'compass/app_integration/rails'

Sass::Engine::DEFAULT_OPTIONS[:load_paths].tap do |load_paths|
  load_paths << "#{Rails.root}/app/assets/stylesheets"
  load_paths << "#{Goldencobra::Engine.root}/app/assets/stylesheets"
  load_paths << "#{Gem.loaded_specs['compass'].full_gem_path}/frameworks/compass/stylesheets"
end

#configuration = StringIO.new(<<-CONFIG)
#  project_type = :rails 
#  project_path = Goldencobra::Engine.root 
#  http_path = "/" 
#  css_dir = File.join(Rails.root, 'public', 'stylesheets', 'compiled') 
#  sass_dir = "app/assets/stylesheets" 
#  environment = Compass::AppIntegration::Rails.env 
#  preferred_syntax = :sass 
#CONFIG
#
#Compass.add_configuration(configuration, 'Goldencobra')
#Compass.discover_extensions! 
#Compass.configure_sass_plugin! 
#Compass.handle_configuration_change!
#
