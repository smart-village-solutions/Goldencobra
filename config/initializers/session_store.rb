if ActiveRecord::Base.connection.table_exists?("goldencobra_settings")
  if Goldencobra::Setting.for_key("goldencobra.analytics.active") == "true"
    Rails.application.config.session_store :active_record_store
  end
end