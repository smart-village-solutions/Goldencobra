ActiveAdmin.register Goldencobra::Article, :as => "SEO-Article" do

  menu false
  controller.authorize_resource :class => Goldencobra::Article

  scope "Alle", :scoped, :default => true
  scope "online", :active
  scope "offline", :inactive

  Goldencobra::Article.article_types_for_select.each do |article_type|
    next if article_type.include?("index")
    scope(I18n.t(article_type.split(' ').first.to_s.strip, :scope => [:goldencobra, :article_types], :default => article_type.split(' ').first)){ |t| t.where("article_type LIKE '%#{article_type.split(' ').first}%'") }
  end

  index do
    selectable_column
    column I18n.t("name", :scope => [:goldencobra, :menue]), :sortable => :url_name do |article|
      content_tag("span", link_to(truncate(article.title, :length => 40), edit_admin_article_path(article.id), :class => "member_link edit_link"), :class => article.startpage ? "startpage" : "")
    end
    column I18n.t("name", :scope => [:goldencobra, :menue]), :sortable => :url_name do |article|
      content_tag("span", link_to(truncate(article.url_name, :length => 40), edit_admin_article_path(article.id), :class => "member_link edit_link"), :class => article.startpage ? "startpage" : "")
    end
    column "Title-Tag" do |article|
      article.metatags.find_by_name("Title Tag").try(:value)
    end
    column "Meta Description" do |article|
      article.metatags.find_by_name("Meta Description").try(:value)
    end
    column "Suchmaschinen gesperrt", :robots_no_index do |article|
      article.robots_no_index ? "Ja" : "Nein"
    end
    column :active, :sortable => :active do |article|
      link_to(article.active ? "online" : "offline", set_page_online_offline_admin_article_path(article),:confirm => t("online", :scope => [:goldencobra, :flash_notice]), :class => "member_link edit_link #{article.active ? 'online' : 'offline'}")
    end


    column "" do |article|
      result = ""
      result += link_to(t(:view), article.public_url, :class => "member_link edit_link view", :title => "Vorschau")
      result += link_to(t(:edit), edit_admin_article_path(article.id), :class => "member_link edit_link edit", :title => "bearbeiten")
      result += link_to(t(:new_subarticle), new_admin_article_path(:parent => article), :class => "member_link edit_link new_subarticle", :title => "Neuer Unterartikel")
      result += link_to(t(:delete), admin_article_path(article.id), :method => :DELETE, :confirm => t("delete_article", :scope => [:goldencobra, :flash_notice]), :class => "member_link delete_link delete", :title => "loeschen")
      raw(result)
    end
  end

  actions :index

end
