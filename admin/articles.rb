ActiveAdmin.register Goldencobra::Article, as: "Article" do
  menu :priority => 1, :parent => I18n.t("active_admin.articles.parent"), :label => I18n.t("active_admin.articles.as"), :if => proc{can?(:update, Goldencobra::Article)}

  controller.authorize_resource :class => Goldencobra::Article

  #Alle Filteroptionen in der rechten Seitenleiste
  filter :parent_ids_in, :as => :select, :collection => proc { Goldencobra::Article.order("title") }, :label => I18n.t("filter_parent", :scope => [:goldencobra, :filter], :default => I18n.t('active_admin.articles.filter.default1'))
  filter :article_type, :as => :select, :collection => Goldencobra::Article.article_types_for_select.map{|at| [I18n.t(at.parameterize.underscore.downcase, scope: [:goldencobra, :article_types], default: at), at]}.sort, :label => I18n.t("filter_type", :scope => [:goldencobra, :filter], :default => I18n.t('active_admin.articles.filter.default2'))
  filter :title, :label => I18n.t("filter_titel", :scope => [:goldencobra, :filter], :default => I18n.t('active_admin.articles.filter.default3'))
  filter :frontend_tag_name, :as => :string, :label => I18n.t("frontend_tags", :scope => [:goldencobra, :filter], :default => I18n.t('active_admin.articles.filter.default4'))
  filter :tag_name, :as => :string, :label => I18n.t("tags", :scope => [:goldencobra, :filter], :default => I18n.t('active_admin.articles.filter.default5'))
  #filter :subtitle, :label =>  I18n.t("filter_subtitel", :scope => [:goldencobra, :filter], :default => "Unteritel")
  #filter :breadcrumb, :label =>  I18n.t("filter_breadcrumb", :scope => [:goldencobra, :filter], :default => "Brotkruemel")
  filter :url_name, :label =>  I18n.t("filter_url", :scope => [:goldencobra, :filter], :default => I18n.t('active_admin.articles.filter.default6'))
  #filter :template_file, :label =>  I18n.t("filter_template", :scope => [:goldencobra, :filter], :default => "Template Datei")
  filter :fulltext, :as => :string
  filter :created_at, :label =>  I18n.t("filter_created", :scope => [:goldencobra, :filter], :default => I18n.t('active_admin.articles.filter.default7'))
  filter :updated_at, :label =>  I18n.t("filter_updated", :scope => [:goldencobra, :filter], :default => I18n.t('active_admin.articles.filter.default8'))

  scope I18n.t('active_admin.articles.scope1'), :scoped, :default => true, :show_count => false
  scope I18n.t('active_admin.articles.scope2'), :active, :show_count => false
  scope I18n.t('active_admin.articles.scope3'), :inactive, :show_count => false

  Goldencobra::Article.article_types_for_select.each do |article_type|
    next if article_type.include?("index")
    scope(I18n.t(article_type.split(' ').first.to_s.strip, :scope => [:goldencobra, :article_types], :default => article_type.split(' ').first), :show_count => false){ |t| t.where("article_type LIKE '%#{article_type.split(' ').first}%'") }
  end

  form :html => { :enctype => "multipart/form-data" }  do |f|
    if f.object.new_record?
      render :partial => "/goldencobra/admin/articles/select_article_type", :locals => {:f => f}
    else
      f.actions

      #Render alle Feldgruppen und Felder mit Position "first"
      if f.object.articletype.present?
        f.object.articletype.fieldgroups.where(:position => "first_block").each do |atg|
          f.inputs atg.title, :class => "#{atg.foldable ? 'foldable' : ''} #{atg.expert ? 'expert' : ''} #{atg.closed ? 'closed' : ''} inputs" do
            atg.fields.each do |atgf|
              render(:inline => Goldencobra::Articletype::ArticleFieldOptions[atgf.fieldname.to_sym], :locals => { :f => f })
            end
            f.input :id, :as => :hidden
          end
        end
      end

      #render Show Options if articletype == Show
      if f.object.article_type.present? && f.object.kind_of_article_type.downcase == "show"

        #render Article_type Options
        if File.exists?("#{::Rails.root}/app/views/articletypes/#{f.object.article_type_form_file.underscore.parameterize.downcase}/_edit_show.html.erb")
          render :partial => "articletypes/#{f.object.article_type_form_file.underscore.parameterize.downcase}/edit_show", :locals => {:f => f}
        else
          f.inputs "ERROR: Partial missing! #{::Rails.root}/app/views/articletypes/#{f.object.article_type_form_file.underscore.parameterize.downcase}/edit_show" do
          end
        end

        #render goldencobra_module options
        Rails::Application::Railties.engines.select{|a| a.engine_name.include?("goldencobra")}.each do |engine|
          if File.exists?("#{engine.root}/app/views/layouts/#{engine.engine_name}/_edit_show.html.erb")
            render :partial => "layouts/#{engine.engine_name}/edit_show", :locals => {:f => f, :engine => engine}
          end
        end

      #render Index Options if articletype == Index
      elsif f.object.kind_of_article_type.downcase == "index"

        render :partial => "goldencobra/admin/articles/articles_index", :locals => {:f => f}
        if File.exists?("#{::Rails.root}/app/views/articletypes/#{f.object.article_type_form_file.underscore.parameterize.downcase}/_edit_index.html.erb")
          render :partial => "articletypes/#{f.object.article_type_form_file.underscore.parameterize.downcase}/edit_index", :locals => {:f => f}
        else
          f.inputs "ERROR: Partial missing! #{::Rails.root}/app/views/articletypes/#{f.object.article_type_form_file.underscore.parameterize.downcase}/edit_index" do
          end
        end

        Rails::Application::Railties.engines.select{|a| a.engine_name.include?("goldencobra")}.each do |engine|
          if File.exists?("#{engine.root}/app/views/layouts/#{engine.engine_name}/_edit_index.html.erb")
            render :partial => "layouts/#{engine.engine_name}/edit_index ", :locals => {:f => f, :engine => engine}
          end
        end
        #render :partial => "goldencobra/admin/articles/sort_articles_index", :locals => {:f => f}

      else

        #error

      end

      #Render alle Feldgruppen und Felder mit Position "last"
      if f.object.articletype.present?
        f.object.articletype.fieldgroups.where(:position => "last_block").each do |atg|
          f.inputs atg.title, :class => "#{atg.foldable ? 'foldable' : ''} #{atg.expert ? 'expert' : ''} #{atg.closed ? 'closed' : ''} inputs" do
            atg.fields.each do |atgf|
              render(:inline => Goldencobra::Articletype::ArticleFieldOptions[atgf.fieldname.to_sym], :locals => { :f => f })
            end
            f.input :id, :as => :hidden
          end
        end
      end
    end

    f.inputs I18n.t('active_admin.articles.form.JS_scripts'), :style => "display:none"  do
      if current_user && current_user.enable_expert_mode == true
        render partial: '/goldencobra/admin/articles/toggle_expert_mode'
      end
    end
    f.actions
  end

  index do
    selectable_column
    column I18n.t('active_admin.articles.index.website_title'), :sortable => :url_name do |article|
      content_tag("span", link_to(truncate(article.url_name, :length => 40), edit_admin_article_path(article.id), :class => "member_link edit_link"), :class => article.startpage ? "startpage" : "")
    end
    column I18n.t('active_admin.articles.index.website_url'), :url do |article|
      article.public_url
    end
    column I18n.t('active_admin.articles.index.active'), :active, :sortable => :active do |article|
      link_to(article.active ? "online" : "offline", set_page_online_offline_admin_article_path(article), :title => "#{article.active ? 'Artikel offline stellen' : 'Artikel online stellen'}", :confirm => I18n.t("online", :scope => [:goldencobra, :flash_notice]), :class => "member_link edit_link #{article.active ? 'online' : 'offline'}")
    end
    column I18n.t('active_admin.articles.index.article_type'), :article_type, sortable: :article_type do |article|
      article.article_type.blank? ? I18n.t('active_admin.articles.index.default') : I18n.t(article.article_type.parameterize.underscore.downcase, scope: [:goldencobra, :article_types])
    end
    column I18n.t('active_admin.articles.index.permission') do |article|
      Goldencobra::Permission.restricted?(article) ? raw(I18n.t('active_admin.articles.index.restricted')) : ""
    end
    #column :created_at, sortable: :created_at do |article|
    #  l(article.created_at)
    #end
    #column :updated_at, sortable: :updated_at do |article|
    #  l(article.updated_at)
    #end
    column I18n.t("menue", :scope => [:goldencobra, :menue]) do |article|
      if article.linked_menues.count > 0
        link_to(I18n.t("list", :scope => [:goldencobra, :menue]), admin_menues_path("q[target_contains]" => article.public_url), :class => "list", :title => I18n.t('active_admin.articles.index.list_menu'))
      else
        link_to(I18n.t("create", :scope => [:goldencobra, :menue]), new_admin_menue_path(:menue => {:title => article.parsed_title, :target => article.public_url}), :class => "create", :title => I18n.t('active_admin.articles.index.create_menu'))
      end
    end
    column "" do |article|
      result = ""
      result += link_to(t(:view), article.public_url, :class => "member_link edit_link view", :title => I18n.t('active_admin.articles.index.article_preview'))
      result += link_to(t(:edit), edit_admin_article_path(article.id), :class => "member_link edit_link edit", :title => I18n.t('active_admin.articles.index.article_edit'))
      result += link_to(t(:new_subarticle), new_admin_article_path(:parent => article), :class => "member_link edit_link new_subarticle", :title => I18n.t('active_admin.articles.index.create_subarticle'))
      result += link_to(t(:delete), admin_article_path(article.id), :method => :DELETE, :confirm => t("delete_article", :scope => [:goldencobra, :flash_notice]), :class => "member_link delete_link delete", :title => I18n.t('active_admin.articles.index.delete_article'))
      raw(result)
    end
  end

  action_item :only => [:index] do
    link_to(I18n.t('active_admin.articles.sidebar.seo_link'), admin_seo_articles_path())
  end

  action_item :only => [:edit] do
    link_to I18n.t('active_admin.articles.sidebar.new_sub_article'), new_admin_article_path(:parent => resource), :class => "new_link"
  end

  sidebar :overview, only: [:index] do
    render :partial => "/goldencobra/admin/shared/overview", :object => Goldencobra::Article.order(:url_name).roots, :locals => {:link_name => "url_name", :url_path => "article", :order_by => "url_name" }
  end

  sidebar :widgets_options, only: [:edit] do
    render "/goldencobra/admin/articles/widgets_sidebar", :locals => { :current_article => resource }
  end

  sidebar :startpage_options, :only => [:show, :edit] do
    if resource.startpage
      t("startpage", :scope => [:goldencobra, :flash_notice])
    else
      link_to t("action_Startpage", :scope => [:goldencobra, :flash_notice]) , mark_as_startpage_admin_article_path(resource.id), :confirm => t("name_of_flashnotice", :scope => [:goldencobra, :flash_notice])
    end
  end

  sidebar "layout", only: [:edit] do
    render "/goldencobra/admin/articles/layout_sidebar", :locals => { :current_article => resource }
  end

  sidebar :image_module, :only => [:edit] do
    render "/goldencobra/admin/articles/image_module_sidebar"
  end

  sidebar :link_checker, :only => [:edit] do
    render "/goldencobra/admin/articles/link_checker", :locals => { :current_article => resource }
  end

  sidebar :menue_options, :only => [:show, :edit] do
    if resource.linked_menues.count > 0
      h5 I18n.t('active_admin.articles.sidebar.h5')
      div link_to(I18n.t('active_admin.articles.sidebar.div_link'), admin_menues_path("q[target_contains]" => resource.public_url))
      div "oder"
      div link_to(I18n.t('active_admin.articles.sidebar.div_link1'), new_admin_menue_path(:menue => {:title => resource.title, :target => resource.public_url}))
    else
      h5 I18n.t('active_admin.articles.sidebar.h5_1')
      div link_to(I18n.t('active_admin.articles.sidebar.div_link2'), new_admin_menue_path(:menue => {:title => resource.title, :target => resource.public_url}))
    end

    articles = Goldencobra::Article.active.where(:url_name => resource.url_name)
    if articles.count > 1
      results = articles.select{|a| a.public_url == resource.public_url}.flatten.compact.uniq
    end

    if results && results.count > 1
      h5 "#{I18n.t('active_admin.articles.sidebar.h5_achtung')} #{pluralize(results.count - 1 , I18n.t('active_admin.articles.sidebar.h5_achtung2'), I18n.t('active_admin.articles.sidebar.h5_achtung3'))  } #{I18n.t('active_admin.articles.sidebar.h5_achtung4')}", :class => "warning"
      ul do
        results.each do |r|
          next if r == resource
          li link_to "#{r.title}", admin_article_path(r)
        end
      end
    end
  end

  #sidebar :help, only: [:edit, :show] do
  #  render "/goldencobra/admin/shared/help"
  #end

  member_action :change_articletype, :method => :post do
    article = Goldencobra::Article.find(params[:id])
    article.article_type = params[:new_article_type]
    if article.article_type.include?("Show")
      unless article.article_type.include?("Default")
        article_model = article.article_type_form_file.constantize
        related_article_object = article_model.where(:article_id => article.id).first
        if related_article_object
          article.send("#{article.article_type_form_file.underscore.parameterize.downcase}=", related_article_object)
        else
          article.send("#{article.article_type_form_file.underscore.parameterize.downcase}=", article_model.new(:article_id => article.id))
        end
        article.save
      end
    end
    article.save
    redirect_to :action => :edit
  end

  member_action :mark_as_startpage do
    article = Goldencobra::Article.find(params[:id])
    article.mark_as_startpage!
    flash[:notice] = I18n.t(:startpage, scope: [:goldencobra, :flash_notice]) #"Dieser Artikel ist nun der Startartikel"
    redirect_to :action => :show
  end

  member_action :set_page_online_offline do
    article = Goldencobra::Article.find(params[:id])
    if article.active
      article.active = false
      flash[:notice] = I18n.t('active_admin.articles.member_action.flash.article_offline')
    else
      article.active = true
      flash[:notice] = I18n.t('active_admin.articles.member_action.flash.article_online')
    end
    article.save

    redirect_to :action => :index
  end

  member_action :update_widgets, :method => :post do
    article = Goldencobra::Article.find(params[:id])
    article.update_attributes(:widget_ids => params[:widget_ids])
    redirect_to :action => :edit, :notice => I18n.t('active_admin.articles.member_action.flash.widgets')
  end

  member_action :run_link_checker do
    article = Goldencobra::Article.find(params[:id])
    system("cd #{::Rails.root} && RAILS_ENV=#{::Rails.env} bundle exec rake link_checker:article ID=#{article.id} &")
    flash[:notice] = I18n.t('active_admin.articles.member_action.flash.link_checker')
    redirect_to :action => :edit
  end

  batch_action :reset_cache, :confirm => I18n.t('active_admin.articles.batch_action.cache') do |selection|
    Goldencobra::Article.find(selection).each do |article|
      article.updated_at = Time.now
      article.without_versioning :save
    end
    flash[:notice] = I18n.t('active_admin.articles.batch_action.flash.cache')
    redirect_to :action => :index
  end

  batch_action :set_article_online, :confirm => I18n.t('active_admin.articles.batch_action.confirm_online') do |selection|
    Goldencobra::Article.find(selection).each do |article|
      article.active = true
      article.save
    end
    flash[:notice] = I18n.t('active_admin.articles.batch_action.flash.set_article_online')
    redirect_to :action => :index
  end

  batch_action :set_article_offline, :confirm => I18n.t('active_admin.articles.batch_action.confirm_offline')  do |selection|
    Goldencobra::Article.find(selection).each do |article|
      article.active = false
      article.save
    end
    flash[:notice] = I18n.t('active_admin.articles.batch_action.flash.set_article_offline')
    redirect_to :action => :index
  end

  batch_action :destroy, false

  collection_action :load_overviewtree do
    render "/goldencobra/admin/shared/load_overviewtree",
      locals: { :object_id => params[:object_id],
                :object_class => params[:object_class],
                :link_name => params[:link_name],
                :url_path => params[:url_path],
                :order_by => params[:order_by]  },
      :layout => false
  end

  controller do

    def show
      show! do |format|
         format.html { redirect_to edit_admin_article_path(@article.id), :flash => flash }
      end
    end

    def new
      @article = Goldencobra::Article.new(params[:article])
      if params[:parent] && params[:parent].present?
        @parent = Goldencobra::Article.find(params[:parent])
        @article.parent_id = @parent.id
      end
    end

    def update
      update! do |format|
        if @article.errors.present? && @article.errors.messages.any?
          flash[:error] = "<h3>Fehler beim Speichern</h3><ul>"
          @article.errors.messages.each do |key, value|
            flash[:error] += "<li><span>#{t(key, :scope => [:activerecord, :attributes, :profile])}</span>: #{value.join(', ')}</li>"
          end
          flash[:error] += "</ul>"
        end
         format.html { redirect_to edit_admin_article_path(@article.id) }
      end
    end

  end

  member_action :toggle_expert_mode do
    current_user.enable_expert_mode = !current_user.enable_expert_mode
    current_user.save
    render template: '/goldencobra/admin/articles/toggle_expert_mode', format: 'js', locals: { enabled: current_user.enable_expert_mode }
  end

  member_action :revert do
    @version = PaperTrail::Version.find(params[:id])
    if @version.reify
      @version.reify.save!
    else
      @version.item.destroy
    end
    redirect_to :back, :notice => "#{I18n.t('active_admin.settings.notice.undid_event')} #{@version.event}"
  end

  action_item only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/prev_item'
  end

  action_item :only => :edit do
    link_to(I18n.t('active_admin.articles.action_item.link_to.article_preview'), resource.public_url, :target => "_blank")
  end

  action_item :only => :edit, :inner_html => {:class => "expert"} do
    link_to("#{I18n.t('active_admin.articles.action_item.link_to.expert_modus')} #{current_user.enable_expert_mode ? I18n.t('active_admin.articles.action_item.link_to.deactivate') : I18n.t('active_admin.articles.action_item.link_to.activate')}", toggle_expert_mode_admin_article_path, remote: true, id: "expert-mode")
  end

  #action_item :only => :index do
    #link_to(I18n.t('active_admin.articles.action_item.link_to.import'), new_admin_import_path(:target_model => "Goldencobra::Article"), :class => "importer")
  #end

  action_item :only => :edit do
    if resource.versions.last
      link_to(I18n.t('active_admin.articles.action_item.link_to.undo'), revert_admin_article_path(:id => resource.versions.last), :class => "undo")
    end
  end

  action_item only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/next_item'
  end
end
