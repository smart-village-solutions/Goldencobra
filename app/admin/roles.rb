ActiveAdmin.register Goldencobra::Role, :as => "Role" do
    menu :parent => "Einstellungen", :label => "Rollenverwaltung", :if => proc{can?(:read, Goldencobra::Role)}
    controller.authorize_resource :class => Goldencobra::Role
        
end