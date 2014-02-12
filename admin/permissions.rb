#encoding: utf-8

ActiveAdmin.register Goldencobra::Permission, :as => "Permission", :sort_order => :sorter_id do
    menu :parent => I18n.t("settings", :scope => ["active_admin","menue"]), :if => proc{can?(:update, Goldencobra::Permission)}
    controller.authorize_resource :class => Goldencobra::Permission

    scope "Alle", :scoped, :default => true
    if ActiveRecord::Base.connection.table_exists?("goldencobra_roles") && Goldencobra::Role.all.count > 0
      Goldencobra::Role.all.each do |role|
          scope(role.name){ |t| t.where(:role_id => role.id) }
      end
    end

    index do
      selectable_column
      column "Role", sortable: :role do |permission|
        permission.role.present? ? permission.role.name : ''
      end
      column :action
      column :subject_class
      column :subject_id
      column :sorter_id
      column :operator_id
      column "" do |permission|
        result = ""
        result += link_to(t(:edit), edit_admin_permission_path(permission.id), :class => "member_link edit_link edit", :title => "bearbeiten")
        result += link_to(t(:delete), admin_permission_path(permission.id), :method => :DELETE, :confirm => "Kommentar löschen?", :class => "member_link delete_link delete", :title => "loeschen")
        raw(result)
      end
    end

    form html: {enctype: "multipart/form-data"} do |f|
      f.actions
      f.inputs do
        f.input :role_id, as: :select, collection: Goldencobra::Role.all.map{|role| [role.name.capitalize, role.id]}, include_blank: 'Alle'
        f.input :action, :as => :select, :collection => Goldencobra::Permission::PossibleActions, :include_blank => false
        f.input :subject_class, as: :select, collection: [":all"] + ActiveRecord::Base.descendants.map(&:name), include_blank: false
        f.input :subject_id
        f.input :operator_id
        f.input :sorter_id
      end
      f.actions
    end

    sidebar "Sortierung / Gewichtung", :only => [:index] do
      raw("je Höher die Zahl desto wichtiger ist das Zugriffsrecht: <b>10 ist wichtiger als 1</b>. <br/>
          Ist zu einer Rolle ein Model nicht definiert, so beitzt diese Rolle standardmäßig alle Rechte an diesem Model")
    end

  action_item only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/prev_item'
  end

  action_item only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/next_item'
  end

end
