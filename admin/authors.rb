ActiveAdmin.register Goldencobra::Author, :as => "Author" do
  menu :parent => "Einstellungen", :label => "Autoren"

  index do
  	selectable_column
    column :id
    column :firstname
    column :lastname
    column :email
    column :googleplus
    default_actions
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