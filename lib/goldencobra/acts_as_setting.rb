module Goldencobra
    module ActsAsSetting
        module Controller
          
            def s(name)
              if name.present?
                Goldencobra::Setting.for_key(name)
              end
            end
            
        end
    end
end
       
::ActionController::Base.send :include, Goldencobra::ActsAsSetting::Controller
#::ApplicationHelper.send :include, Goldencobra::ActsAsSetting::Controller