Goldencobra::Setting.import_default_settings(Goldencobra::Engine.root + "config/settings.yml")

::ApplicationHelper.module_eval do
  
  def s(name)
    if name.present?
      Goldencobra::Setting.for_key(name)
    end
  end
  
end


::ActionController::Base.module_eval do
  
  def s(name)
    if name.present?
      Goldencobra::Setting.for_key(name)
    end
  end
  
end
