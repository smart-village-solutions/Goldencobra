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

  action_item only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/prev_item'
  end

  action_item only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/next_item'
  end

end