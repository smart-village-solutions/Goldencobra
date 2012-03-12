ActiveAdmin.register User, :as => "User" do
  menu :parent => "Benutzerverwaltung", :label => "Benutzer"
  
  filter :firstname
  filter :lastname
  filter :email

  form :html => { :enctype => "multipart/form-data" }  do |f|
    f.inputs "Allgemein" do
      f.input :title
      f.input :firstname
      f.input :lastname
      f.input :email
      if current_user.has_role?('admin')
        f.input :roles, :as => :check_boxes, :collection => Goldencobra::Role.all
      end
      f.input :function
      f.input :phone
      f.input :fax
      f.input :facebook
      f.input :twitter
      f.input :linkedin
      f.input :xing
      f.input :googleplus
    end
    f.buttons
  end
 

  index do
    column :firstname
    column :lastname
    column :email
    column "Roles" do |u|
      u.roles.each.map{|r| r.name.capitalize}
    end
    default_actions
  end

  show :title => :lastname do
    panel "User" do
      attributes_table_for user do
        [:firstname, :lastname, :title, :email, :gender, :function, :phone, :fax, :facebook, :twitter, :linkedin, :xing, :googleplus, :created_at, :updated_at].each do |aa|
          row aa
        end
      end
    end #end panel applicant
  end
end
