ActiveAdmin.register Goldencobra::Tracking, :as => "Analytic" do
  menu :parent => "Einstellungen", :if => proc{can?(:update, Goldencobra::Tracking)}
  controller.authorize_resource :class => Goldencobra::Tracking

  filter :ip
  filter :session_id
  filter :referer
  filter :url
  filter :language
  filter :user_agent
  filter :created_at

  index do
    column :ip
    column :session_id
    column :referer
    column :url
    column :language
    default_actions
  end

end