Rails.application.config.to_prepare do
  Goldencobra::Setting.import_default_settings(Goldencobra::Engine.root + "config/settings.yml")
end

