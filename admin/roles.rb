ActiveAdmin.register Goldencobra::Role, :as => "Role" do
    menu :parent => "Einstellungen", :if => proc{can?(:update, Goldencobra::Role)}
    controller.authorize_resource :class => Goldencobra::Role
        
end