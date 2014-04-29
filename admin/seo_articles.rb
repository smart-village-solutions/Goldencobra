ActiveAdmin.register Goldencobra::Article, :as => "SEO-Article" do

  menu false
  controller.authorize_resource :class => Goldencobra::Article

  scope I18n.t('active_admin.seo_articles.scope1'), :scoped, :default => true
  scope I18n.t('active_admin.seo_articles.scope2'), :active
  scope I18n.t('active_admin.seo_articles.scope3'), :inactive
  scope I18n.t('active_admin.seo_articles.scope4'), :no_title_tag
  scope I18n.t('active_admin.seo_articles.scope5'), :no_meta_description

  Goldencobra::Article.article_types_for_select.each do |article_type|
    next if article_type.include?("index")
    scope(I18n.t(article_type.split(' ').first.to_s.strip, :scope => [:goldencobra, :article_types], :default => article_type.split(' ').first)){ |t| t.where("article_type LIKE '%#{article_type.split(' ').first}%'") }
  end

  index do
    selectable_column
    column I18n.t('active_admin.seo_articles.index.title_column'), :sortable => :url_name do |article|
      content_tag("span", link_to(truncate(article.title, :length => 40), edit_admin_article_path(article.id), :class => "member_link edit_link"), :class => article.startpage ? "startpage" : "")
    end
    column I18n.t("name", :scope => [:goldencobra, :menue]), :sortable => :url_name do |article|
      content_tag("span", link_to(truncate(article.url_name, :length => 40), edit_admin_article_path(article.id), :class => "member_link edit_link"), :class => article.startpage ? "startpage" : "")
    end
    column I18n.t('active_admin.seo_articles.index-tag_column') do |article|
      article.metatags.find_by_name("Title Tag").try(:value)
    end
    column I18n.t('active_admin.seo_articles.index.meta_column') do |article|
      article.metatags.find_by_name("Meta Description").try(:value)
    end
    column I18n.t('active_admin.seo_articles.index.search_column'), :robots_no_index do |article|
      article.robots_no_index ? I18n.t('active_admin.seo_articles.index.search_column_yes') : I18n.t('active_admin.seo_articles.index.search_column_no')
    end
    column I18n.t('active_admin.seo_articles.index.links_column') do |article|
      if article.link_checker.present?
        "#{article.link_checker.count} / E:#{article.link_checker.count - article.link_checker.select{|key,value| value['response_code'] == "200"}.count}"
      end
    end
    column :active, :sortable => :active do |article|
      link_to(article.active ? I18n.t('active_admin.seo_articles.index.active_online') : I18n.t('active_admin.seo_articles.index.active_offline'), set_page_online_offline_admin_article_path(article),:confirm => t("online", :scope => [:goldencobra, :flash_notice]), :class => "member_link edit_link #{article.active ? 'online' : 'offline'}")
    end


    column "" do |article|
      result = ""
      result += link_to(t(:view), article.public_url, :class => "member_link edit_link view", :title => I18n.t('active_admin.seo_articles.column.title1'))
      result += link_to(t(:edit), edit_admin_article_path(article.id), :class => "member_link edit_link edit", :title => I18n.t('active_admin.seo_articles.column.title2'))
      result += link_to(t(:new_subarticle), new_admin_article_path(:parent => article), :class => "member_link edit_link new_subarticle", :title => I18n.t('active_admin.seo_articles.column.title3')))
      result += link_to(t(:delete), admin_article_path(article.id), :method => :DELETE, :confirm => t("delete_article", :scope => [:goldencobra, :flash_notice]), :class => "member_link delete_link delete", :title => I18n.t('active_admin.seo_articles.column.title4'))
      raw(result)
    end
  end

  actions :index

  collection_action :run_all_link_checker do
    system("cd #{::Rails.root} && RAILS_ENV=#{::Rails.env} bundle exec rake link_checker:all &")
    flash[:notice] = I18n.t('active_admin.seo_articles.collection_flash')
    redirect_to :action => :index
  end

  action_item :only => [:index] do
    link_to(I18n.t('active_admin.seo_articles.action_link'), admin_link_checkers_path())
  end

  action_item :only => :index do
    link_to(I18n.t('active_admin.seo_articles.action_link1'), run_all_link_checker_admin_seo_articles_path())
  end

  controller do
    def scoped_collection
      end_of_association_chain.includes(:metatags)
    end
  end

end
