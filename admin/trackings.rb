ActiveAdmin.register Goldencobra::Tracking, :as => "Analytic" do
  menu :parent => "Einstellungen", :if => proc{can?(:update, Goldencobra::Tracking)}
  controller.authorize_resource :class => Goldencobra::Tracking

  filter :ip
  filter :session_id
  filter :referer
  filter :url
  filter :language
  filter :user_agent
  filter :url_paremeters
  filter :created_at

  index do
    column :ip
    column :session_id
    column :referer
    column :url
    column :language
    column :created_at
    default_actions
  end

end


#http://www.test.de/?utm_source=quelle&utm_medium=medium&utm_term=begriff&utm_content=content&utm_campaign=name