ActiveAdmin.register Goldencobra::Domain, :as => "Domain" do
  menu :parent => "Einstellungen", :label => "Domains", :if => proc{can?(:update, Goldencobra::Domain)}

  index do
  	selectable_column
    column :id
    column :title
    column :hostname
    column :client
    default_actions
  end

  form html: { enctype: "multipart/form-data" }  do |f|
    f.actions
      f.inputs do
        f.input :title
        f.input :hostname
        f.input :client
      end
    f.actions
  end

end