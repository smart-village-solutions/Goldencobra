# encoding: utf-8

ActiveAdmin.register Goldencobra::Author, :as => "Author" do
  menu :parent => I18n.t("settings", :scope => ["active_admin", "menue"]), :label => I18n.t('active_admin.authors.as'), :if => proc{ can?(:update, Goldencobra::Author) }

  index :download_links => proc{ Goldencobra::Setting.for_key("goldencobra.backend.index.download_links") == "true" }.call do
  	selectable_column
    column :id
    column :firstname
    column :lastname
    column :email
    column :googleplus
    actions
  end

  form html: { enctype: "multipart/form-data" }  do |f|
    f.actions
      f.inputs do
        f.input :firstname
        f.input :lastname
        f.input :email
        f.input :googleplus
      end
    f.actions
  end

end