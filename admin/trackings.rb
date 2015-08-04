# encoding: utf-8

ActiveAdmin.register Goldencobra::Tracking, :as => "Analytic" do
  menu :parent => I18n.t("settings", :scope => ["active_admin","menue"]), :if => proc{can?(:update, Goldencobra::Tracking)}

  filter :ip
  filter :session_id
  filter :referer
  filter :url
  filter :language
  filter :user_agent
  filter :url_paremeters
  filter :utm_source
  filter :utm_medium
  filter :utm_term
  filter :utm_content
  filter :utm_campaign
  filter :location
  filter :created_at

  index :download_links => proc{ Goldencobra::Setting.for_key("goldencobra.backend.index.download_links") == "true" }.call do
    column :utm_campaign
    column :session_id
    column :referer, :sortable => :referer do |tracking|
      truncate(tracking.referer, :length => 50)
    end
    column :url, :sortable => :url do |tracking|
      truncate(tracking.url, :length => 50)
    end
    column :language
    column :location
    column :created_at, :sortable => :created_at do |tracking|
      raw(tracking.created_at.strftime("%d.%m.%y&nbsp;%H:%M"))
    end
    actions
  end

end


#http://www.test.de/?utm_source=quelle&utm_medium=medium&utm_term=begriff&utm_content=content&utm_campaign=name