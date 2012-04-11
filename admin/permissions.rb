ActiveAdmin.register Goldencobra::Permission, :as => "Permission" do
    menu :parent => "Einstellungen", :label => "Rechteverwaltung", :if => proc{can?(:update, Goldencobra::Permission)}
    controller.authorize_resource :class => Goldencobra::Permission
    
    index do
      selectable_column
      column "Role" do |permission|
        permission.role.name
      end
      column :action
      column :subject_class
      column :subject_id
      default_actions
    end
    
end