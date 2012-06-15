require 'goldencobra/acts_as_setting'
Rails.application.config.to_prepare do
  if ActiveRecord::Base.connection.table_exists?("goldencobra_settings")
    Goldencobra::Setting.import_default_settings(Goldencobra::Engine.root + "config/settings.yml")
  end
end
