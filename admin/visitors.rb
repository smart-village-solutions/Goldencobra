ActiveAdmin.register Visitor do
  #controller.authorize_resource :class => Visitor

  filter :firstname
  filter :lastname
  filter :email

  index do
    selectable_column
    column :first_name
    column :last_name
    column :username
    column :email
    column :last_sign_in_at
    column :created_at
    column :sign_in_count
    column :agb, sortable: :agb do |v|
      v.agb ? 'Ja' : 'Nein'
    end
    column :newsletter, sortable: :newsletter do |v|
      v.newsletter ? 'Ja' : 'Nein'
    end
    default_actions
  end

  form :html => { :enctype => "multipart/form-data" }  do |f|
    f.actions
    f.inputs "Allgemein" do
      f.input :first_name
      f.input :last_name
      f.input :username
      f.input :email
      f.input :password, hint: "Freilassen, wenn das Passwort nicht geaendert werden soll."
      f.input :password_confirmation, hint: "Passwort bei Aenderung hier erneut eingeben"
      f.input :provider
      f.input :uid
      f.input :agb
      f.input :newsletter
    end
    f.actions
  end

  controller do
    def update
      @visitor = Visitor.find(params[:id])
      if params[:visitor] && params[:visitor][:password].present? && params[:visitor][:password_confirmation].present?
        @visitor.update_attributes(params[:visitor])
      else
        @visitor.update_without_password(params[:visitor]) if params[:visitor].present?
      end
      render action: :edit
    end
  end

end