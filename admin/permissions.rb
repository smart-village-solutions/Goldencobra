#encoding: utf-8

ActiveAdmin.register Goldencobra::Permission, :as => "Permission", :sort_order => :sorter_id do
    menu :parent => "Einstellungen", :if => proc{can?(:update, Goldencobra::Permission)}
    controller.authorize_resource :class => Goldencobra::Permission

    scope "Alle", :scoped, :default => true
    Goldencobra::Role.all.each do |role|
        scope(role.name){ |t| t.where(:role_id => role.id) }
    end

    index do
      selectable_column
      column "Role", sortable: :role do |permission|
        permission.role.name
      end
      column :action
      column :subject_class
      column :subject_id
      column :sorter_id
      default_actions
    end

    form html: {enctype: "multipart/form-data"} do |f|
      f.actions
      f.inputs do
        f.input :role_id, as: :select, collection: Goldencobra::Role.all.map{|role| [role.name.capitalize, role.id]}, include_blank: false
        f.input :action, :as => :select, :collection => Goldencobra::Permission::PossibleActions, :include_blank => false
        f.input :subject_class, as: :select, collection: Goldencobra::Permission::PossibleSubjectClasses, include_blank: false
        f.input :subject_id
        f.input :sorter_id
      end
      f.actions
    end

    sidebar "Sortierung / Gewichtung", :only => [:index] do
      raw("je Höher die Zahl desto wichtiger ist das Zugriffsrecht: <b>10 ist wichtiger als 1</b>. <br/>
          Ist zu einer Rolle ein Model nicht definiert, so beitzt diese Rolle standardmäßig alle Rechte an diesem Model")
    end

end
