ActiveAdmin.register User, :as => "User" do
  menu :parent => "Einstellungen", :label => "Benutzerverwaltung", :if => proc{can?(:update, User)}
  controller.authorize_resource :class => User
  
  filter :firstname
  filter :lastname
  filter :email
  actions :all, :except => [:new]

  form :html => { :enctype => "multipart/form-data" }  do |f|
    f.inputs "" do
      f.actions 
    end
    f.inputs "Allgemein" do
      f.input :title
      f.input :firstname
      f.input :lastname
      f.input :email
      if current_user.has_role?('admin')
        f.input :roles, :as => :check_boxes, :collection => Goldencobra::Role.all
      end
      f.input :password, hint: "Freilassen, wenn das Passwort nicht geaendert werden soll."
      f.input :password_confirmation, hint: "Passwort bei Aenderung hier erneut eingeben"
      f.input :function
      f.input :phone
      f.input :fax
      f.input :facebook
      f.input :twitter
      f.input :linkedin
      f.input :xing
      f.input :googleplus
    end
    f.inputs "" do
      f.actions 
    end
  end
 

  index do
    selectable_column
    column :firstname
    column :lastname
    column :email
    column "Roles" do |u|
      u.roles.map{|r| r.name.capitalize}.join(", ")
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
  
  batch_action :destroy, false
  
  
  controller do
    def update
      @user = User.find(params[:id])
      if params[:user] && params[:user][:password] && params[:user][:password_confirmation]
        unless params[:user][:password].length > 0 && params[:user][:password_confirmation].length > 0
          @user.update_without_password(params[:user])
        end
      end
      @user.update_attributes(params[:user])
      render action: :edit
    end
  end
  
  
  
end
