# encoding: utf-8

ActiveAdmin.register Goldencobra::Domain, :as => "Domain" do
  menu :parent => I18n.t("settings", :scope => ["active_admin","menue"]), :label => "Domains", :if => proc{can?(:update, Goldencobra::Domain)}

  index do
  	selectable_column
    column :id
    column :title
    column :hostname
    column :client
    column :url_prefix
    column :main do |d|
      d.main ? "X" : ""
    end
    default_actions
  end

  form html: { enctype: "multipart/form-data" }  do |f|
    f.actions
      f.inputs do
        f.input :title
        f.input :hostname
        f.input :client
        f.input :url_prefix
        f.input :main, :hint => I18n.t('active_admin.domains.form.hint'), :label => "Main Domain?"
      end
    f.actions
  end

end