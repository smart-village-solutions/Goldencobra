# encoding: utf-8

ActiveAdmin.register User, :as => "User" do
  menu :parent => I18n.t("settings", :scope => ["active_admin","menue"]), :label => I18n.t('active_admin.users.as'), :if => proc{can?(:update, User)}

  controller.authorize_resource :class => User

  filter :firstname
  filter :lastname
  filter :email

  #TODO: Gab es hierfür eienn Grund?
  #actions :all, :except => [:new]

  form :html => { :enctype => "multipart/form-data" }  do |f|
    f.actions
    f.inputs I18n.t('active_admin.users.general') do
      f.input :title
      f.input :firstname
      f.input :lastname
      f.input :email
      if current_user.has_role?('admin')
        f.input :roles, :as => :check_boxes, :collection => Goldencobra::Role.all
      end
      f.input :password, hint: I18n.t('active_admin.users.hint1')
      f.input :password_confirmation, hint: I18n.t('active_admin.users.hint2')
      f.input :enable_expert_mode
      f.input :function
      f.input :phone
      f.input :fax
      f.input :facebook
      f.input :twitter
      f.input :linkedin
      f.input :xing
      f.input :googleplus
    end
    f.inputs I18n.t('active_admin.users.history') do
      f.has_many :vita_steps do |step|
        if step.object.new_record?
          step.input :description, as: :string, label: I18n.t('active_admin.users.label1')
          step.input :title, label: I18n.t('active_admin.users.label2'), hint: I18n.t('active_admin.users.hint3')
        else
          render :partial => "/goldencobra/admin/users/vita_steps", :locals => {:step => step}
        end
      end
    end

    f.actions
  end


  index do
    selectable_column
    column :firstname
    column :lastname
    column :email
    column :roles do |u|
      u.roles.map{|r| r.name.capitalize}.join(", ")
    end
    default_actions
  end

  show :title => :lastname do
    panel I18n.t('active_admin.users.user') do
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

  action_item only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/prev_item'
  end

  action_item only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/next_item'
  end
end
