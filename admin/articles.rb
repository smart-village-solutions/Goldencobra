#Encoding: UTF-8
ActiveAdmin.register Goldencobra::Article, :as => "Article" do

  menu :priority => 1, :parent => "Content-Management", :if => proc{can?(:update, Goldencobra::Article)}
  controller.authorize_resource :class => Goldencobra::Article
  unless Rails.env == "test"
    I18n.locale = :de
    I18n.default_locale = :de
  end

  filter :parent_ids_in, :as => :select, :collection => proc { Goldencobra::Article.order("title") }, :label => I18n.t("filter_parent", :scope => [:goldencobra, :filter], :default => "Elternelement")
  filter :article_type, :as => :select, :collection => Goldencobra::Article.article_types_for_select.map{|s| [I18n.t("#{s.parameterize.downcase}", scope: [:goldencobra, :article_types], default: "#{s}"),s]}, :label => I18n.t("filter_type", :scope => [:goldencobra, :filter], :default => "Artikeltyp")
  filter :title, :label => I18n.t("filter_titel", :scope => [:goldencobra, :filter], :default => "Titel")
  filter :frontend_tag_name, :as => :string, :label => I18n.t("frontend_tags", :scope => [:goldencobra, :filter], :default => "Filterkriterium")
  filter :tag_name, :as => :string, :label => I18n.t("tags", :scope => [:goldencobra, :filter], :default => "Interne Tags")
  #filter :subtitle, :label =>  I18n.t("filter_subtitel", :scope => [:goldencobra, :filter], :default => "Unteritel")
  #filter :breadcrumb, :label =>  I18n.t("filter_breadcrumb", :scope => [:goldencobra, :filter], :default => "Brotkruemel")
  filter :url_name, :label =>  I18n.t("filter_url", :scope => [:goldencobra, :filter], :default => "URL")
  #filter :template_file, :label =>  I18n.t("filter_template", :scope => [:goldencobra, :filter], :default => "Template Datei")
  filter :created_at, :label =>  I18n.t("filter_created", :scope => [:goldencobra, :filter], :default => "erstellt")
  filter :updated_at, :label =>  I18n.t("filter_updated", :scope => [:goldencobra, :filter], :default => "bearbeitet")

  scope "Alle", :scoped, :default => true
  scope "Online", :active
  scope "Offline", :inactive

  Goldencobra::Article.article_types_for_select.each do |article_type|
    next if article_type.include?("index")
    scope(I18n.t(article_type.split(' ').first.to_s.strip, :scope => [:goldencobra, :article_types], :default => article_type.split(' ').first)){ |t| t.where("article_type LIKE '%#{article_type.split(' ').first}%'") }
  end

  form :html => { :enctype => "multipart/form-data" }  do |f|
    if f.object.new_record?
      render :partial => "/goldencobra/admin/articles/select_article_type", :locals => {:f => f}
    else
      f.actions
      f.inputs "Allgemein", :class => "foldable inputs" do
        f.input :title, :hint => "Der Titel der Seite, kann Leerzeichen und Sonderzeichen enthalten"
        f.input :content, :input_html => { :class =>"tinymce"}
        f.input :teaser, :hint => "Dieser Text wird auf &Uuml;bersichtsseiten angezeigt, um den Artikel zu bewerben", :input_html=>{ :rows=>5 }
        f.input :tag_list, :hint => "Tags sind komma-getrennte Werte, mit denen sich ein Artikel intern gruppiern l&auml;sst", :wrapper_html => {class: 'expert'}
        f.input :frontend_tag_list, hint: "Hier eingetragene Begriffe werden auf &Uuml;bersichtsseiten als Filteroption angeboten.", label: "Filterkriterium", :wrapper_html => {class: 'expert'}
        f.input :active_since, :hint => "Wenn der Artikel online ist, ab wann ist er Online? Bsp: 02.10.2011 15:35", as: :string, :input_html => { class: "", :size => "20", value: "#{f.object.active_since.strftime('%d.%m.%Y %H:%M') if f.object.active_since}" }, :wrapper_html => {class: 'expert'}
        f.input :active, :hint => "Ist dieser Artikel online zu sehen?", :wrapper_html => {class: 'expert'}
      end
      if f.object.article_type.present? && f.object.kind_of_article_type.downcase == "show"
        if File.exists?("#{::Rails.root}/app/views/articletypes/#{f.object.article_type_form_file.downcase}/_edit_show.html.erb")
          render :partial => "articletypes/#{f.object.article_type_form_file.downcase}/edit_show", :locals => {:f => f}
        else
          f.inputs "ERROR: Partial missing! #{::Rails.root}/app/views/articletypes/#{f.object.article_type_form_file.downcase}/edit_show" do
          end
        end
      elsif f.object.kind_of_article_type.downcase == "index"
          render :partial => "goldencobra/admin/articles/articles_index", :locals => {:f => f}
          if File.exists?("#{::Rails.root}/app/views/articletypes/#{f.object.article_type_form_file.downcase}/_edit_index.html.erb")
            render :partial => "articletypes/#{f.object.article_type_form_file.downcase}/edit_index", :locals => {:f => f}
          else
            f.inputs "ERROR: Partial missing! #{::Rails.root}/app/views/articletypes/#{f.object.article_type_form_file.downcase}/edit_index" do
            end
          end
          #render :partial => "goldencobra/admin/articles/sort_articles_index", :locals => {:f => f}
      else
        #error
      end
      f.inputs "Weiterer Inhalt", :class => "foldable closed inputs" do
        f.input :subtitle
        f.input :context_info, :input_html => { :class =>"tinymce"}, :hint => "Dieser Text ist f&uuml;r eine Sidebar gedacht"
        f.input :summary, hint: "Dient der Einleitung in den Text und wird hervorgehoben dargestellt", :input_html=>{ :rows=>5 }
      end
      f.inputs "Metadescriptions", :class => "foldable closed inputs expert" do
        # f.input :hint_label, :as => :text, :label => "Metatags fuer Suchmaschinenoptimierung", :input_html => {:disabled => true,
          # :resize => false,
          # :value => "<b>Metatags k&ouml;nnen genutzt werden, um den Artikel f&uuml;r Suchmaschinen besser sichtbar zu machen.</b><br />
          # Sie haben folgende Werte zur Wahl:<br />
          # <ul>
          # <li><strong>Title Tag:</strong> Der Title der Seite. Wird nicht als Titel angezeigt. Ist nur f&uuml;r Google & Co. gedacht. </li>
          # <li><strong>Metadescription:</strong> Wird als Beschreibung des Artikels angezeigt, wenn Google ihn gefunden hat. <strong>Wichtig!</strong></li>
          # <li><strong>Keywords:</strong></li>
          # <li><strong>OpenGraph Title:</strong> Title, der bei Facebook angezeigt werden soll, wenn der Artikel geteilt wird.</li>
          # <li><strong>OpenGraph Description:</strong> Description, die bei Facebook angezeigt werden soll, wenn der Artikel geteilt wird.</li>
          # <li><strong>OpenGraph Type:</strong> Sie haben die Wahl zwischen Blog, Article oder Website</li>
          # <li><strong>OpenGraph URL:</strong> Die URL der Website. Standardm&auml;&szlig; wird die URL des Artikels genutzt. Muss nur ver&auml;ndert werden, wenn dort etwas anderes stehen soll.</li>
          # <li><strong>OpenGraph Image:</strong> Muss als URL &uuml;bergeben werden (http://www.mein.de/bild.jpg). Erscheint dann bei Facebook als Bild des Artikels.</li>
          # </ul>", :class => "metadescription_hint", :id => "metadescription-tinymce"}
        f.has_many :metatags do |m|
          m.input :name, :as => :select, :collection => Goldencobra::Article::MetatagNames, :input_html => { :class => 'metatag_names'}, :hint => "Hier k&ouml;nnen Sie die verschiedenen Metatags definieren, sowie alle Einstellungen f&uuml;r den OpenGraph vonehmen."
          m.input :value, :input_html => { :class => 'metatag_values'}
          m.input :_destroy, :as => :boolean
        end
      end
      f.inputs "Einstellungen", :class => "foldable closed inputs expert" do
        f.input :breadcrumb, :hint => "Kurzer Name fuer die Brotkrumennavigation"
        f.input :url_name, :hint => "Nicht mehr als 64 Zeichen, sollte keine Umlaute, Sonderzeichen oder Leerzeichen enthalten. Wenn die Seite unter 'http://meine-seite.de/mein-artikel' erreichbar sein soll, tragen Sie hier 'mein-artikel' ein.", required: false
        f.input :parent_id, :as => :select, :collection => Goldencobra::Article.all.map{|c| ["#{c.path.map(&:title).join(" / ")}", c.id]}.sort{|a,b| a[0] <=> b[0]}, :include_blank => true, :hint => "Auswahl des Artikels, der in der Seitenstruktur _oberhalb_ liegen soll. Beispiel: http://www.meine-seite.de/der-oberartikel/mein-artikel"
        f.input :canonical_url, :hint => "Falls auf dieser Seite Inhalte erscheinen, die vorher schon auf einer anderen Seite erschienen sind, sollte hier die URL der Quellseite eingetragen werden, um von Google nicht f&uuml;r doppelten Inhalt abgestraft zu werden"
        f.input :enable_social_sharing, :label => t("Display Social Sharing actions"), :hint => "Sollen Besucher die actions angezeigt bekommen, um diesen Artikel in den Sozialen Netzwerken zu verbreiten?"
        f.input :robots_no_index, :hint => "Um bei Google nicht in Konkurrenz zu anderen wichtigen Einzelseiten der eigenen Webseite zu treten, kann hier Google mitgeteilt werden, diese Seite nicht zu indizieren"
        f.input :cacheable, :as => :boolean, :hint => "Dieser Artikel darf im Cache liegen"
        f.input :commentable, :as => :boolean, :hint => "Kommentarfunktion für diesen Artikel aktivieren?"
        f.input :dynamic_redirection, :as => :select, :collection => Goldencobra::Article::DynamicRedirectOptions.map{|a| [a[1], a[0]]}, :include_blank => false
        f.input :external_url_redirect
        f.input :redirect_link_title
        f.input :redirection_target_in_new_window
        f.input :author, :hint => "Wer ist der Verfasser dieses Artikels"
      end
      f.inputs "Zugriffsrechte", :class => "foldable closed inputs expert" do
        f.has_many :permissions do |p|
          p.input :role, :include_blank => "Alle"
          p.input :action, :as => :select, :collection => Goldencobra::Permission::PossibleActions, :include_blank => false
          p.input :_destroy, :as => :boolean
        end
      end
      f.inputs "Medien", :class => "foldable closed inputs"  do
        f.has_many :article_images do |ai|
          ai.input :image, :as => :select, :collection => Goldencobra::Upload.all.map{|c| [c.complete_list_name, c.id]}, :input_html => { :class => 'article_image_file chzn-select'}, :label => "Bild ausw&auml;hlen"
          ai.input :position, :as => :select, :collection => Goldencobra::Setting.for_key("goldencobra.article.image_positions").split(",").map(&:strip), :include_blank => false
          ai.input :_destroy, :as => :boolean
        end
       end
    end
    f.inputs "JS-Scripts", :style => "display:none"  do
      if current_user && current_user.enable_expert_mode == true
        render partial: '/goldencobra/admin/articles/toggle_expert_mode'
      end
    end
    f.actions
  end


  index do
    selectable_column
    column I18n.t("name", :scope => [:goldencobra, :menue]), :sortable => :url_name do |article|
      content_tag("span", link_to(truncate(article.url_name, :length => 40), edit_admin_article_path(article.id), :class => "member_link edit_link"), :class => article.startpage ? "startpage" : "")
    end
    column :url  do |article|
      article.public_url
    end
    column :active, :sortable => :active do |article|
      link_to(article.active ? "online" : "offline", set_page_online_offline_admin_article_path(article),:confirm => t("online", :scope => [:goldencobra, :flash_notice]), :class => "member_link edit_link #{article.active ? 'online' : 'offline'}")
    end
    column "Zugriff" do |article|
      Goldencobra::Permission.restricted?(article) ? raw("<span class='secured'>beschränkt</span>") : ""
    end
    column :article_type, sortable: :article_type do |article|
      article.article_type.blank? ? "Standard" : article.article_type
    end
    #column :created_at, sortable: :created_at do |article|
    #  l(article.created_at)
    #end
    #column :updated_at, sortable: :updated_at do |article|
    #  l(article.updated_at)
    #end
    column I18n.t("menue", :scope => [:goldencobra, :menue]) do |article|
      if article.linked_menues.count > 0
        link_to(I18n.t("list", :scope => [:goldencobra, :menue]), admin_menues_path("q[target_contains]" => article.public_url), :class => "list", :title => "Menüpunkte auflisten")
      else
        link_to(I18n.t("create", :scope => [:goldencobra, :menue]), new_admin_menue_path(:menue => {:title => article.parsed_title, :target => article.public_url}), :class => "create", :title => "Menüpunkt erzeugen")
      end
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

  action_item :only => [:index] do
    link_to('SEO-Ansicht', admin_seo_articles_path())
  end

  sidebar :overview, label: "Ueberblick", only: [:index] do
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


  sidebar :layout, only: [:edit] do
    render "/goldencobra/admin/articles/layout_sidebar", :locals => { :current_article => resource }
  end


  sidebar :image_module, :only => [:edit] do
    render "/goldencobra/admin/articles/image_module_sidebar"
  end

  sidebar :menue_options, :only => [:show, :edit] do
    ul do
      if resource.linked_menues.count > 0
        li link_to("Es existieren bereits passende Menüpunkte, Sie können diese hier auflisten", admin_menues_path("q[target_contains]" => resource.public_url))
        li link_to("Einen weiteren Menüpunkt erstellen?", new_admin_menue_path(:menue => {:title => resource.title, :target => resource.public_url}))
      else
        li link_to("Es existiert noch kein Menüpunkt! Wollen Sie diesen erstellen?", new_admin_menue_path(:menue => {:title => resource.title, :target => resource.public_url}))
      end
    end
    articles = Goldencobra::Article.active.where(:url_name => resource.url_name)
    if articles.count > 1
      results = articles.select{|a| a.public_url == resource.public_url}.flatten.compact.uniq
    end
    if results && results.count > 1
      h4 "ACHTUNG!!! Es gibt #{pluralize(results.count - 1 , "anderen Artikel", "andere Artikel")  } mit dieser URL:", :class => "warning"
      ul do
        results.each do |r|
          next if r == resource
          li link_to "#{r.title}", admin_article_path(r)
        end
      end
    end
  end

  member_action :mark_as_startpage do
    article = Goldencobra::Article.find(params[:id])
    article.mark_as_startpage!
    flash[:notice] = I18n.t(:startpage, scope: [:flash_notice, :goldencobra]) #"Dieser Artikel ist nun der Startartikel"
    redirect_to :action => :show
  end

  member_action :set_page_online_offline do
    article = Goldencobra::Article.find(params[:id])
    if article.active
      article.active = false
      flash[:notice] = "Dieser Artikel ist nun online"
    else
      article.active = true
      flash[:notice] = "Dieser Artikel ist nun offline"
    end
    article.save

    redirect_to :action => :index
  end

  member_action :update_widgets, :method => :post do
    article = Goldencobra::Article.find(params[:id])
    article.update_attributes(:widget_ids => params[:widget_ids])
    redirect_to :action => :edit, :notice => "Widgets added"
  end

  batch_action :reset_cache, :confirm => "Cache leeren: sind Sie sicher?" do |selection|
    Goldencobra::Article.find(selection).each do |article|
      article.updated_at = Time.now
      article.save
    end
    flash[:notice] = "Cache wurde erneuert"
    redirect_to :action => :index
  end

  batch_action :set_article_online, :confirm => "Artikel online stellen: sind Sie sicher?" do |selection|
    Goldencobra::Article.find(selection).each do |article|
      article.active = true
      article.save
    end
    flash[:notice] = "Artikel wurden online gestellt"
    redirect_to :action => :index
  end

  batch_action :set_article_offline, :confirm => "Artikel offline stellen: sind Sie sicher?" do |selection|
    Goldencobra::Article.find(selection).each do |article|
      article.active = false
      article.save
    end
    flash[:notice] = "Artikel wurden offline gestellt"
    redirect_to :action => :index
  end


  batch_action :destroy, false

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
  end

  member_action :toggle_expert_mode do
    current_user.enable_expert_mode = !current_user.enable_expert_mode
    current_user.save
    render template: '/goldencobra/admin/articles/toggle_expert_mode', format: 'js', locals: { enabled: current_user.enable_expert_mode }
  end

  member_action :revert do
    @version = Version.find(params[:id])
    if @version.reify
      @version.reify.save!
    else
      @version.item.destroy
    end
    redirect_to :back, :notice => "Undid #{@version.event}"
  end


  action_item only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/prev_item'
  end

  action_item :only => :edit do
    link_to('Vorschau zu diesem Artikel anzeigen', resource.public_url, :target => "_blank")
  end

  action_item :only => :edit, :inner_html => {:class => "expert"} do
    link_to("Expert-Modus #{current_user.enable_expert_mode ? 'deaktivieren' : 'aktivieren'}", toggle_expert_mode_admin_article_path, remote: true, id: "expert-mode")
  end

  action_item :only => :index do
    link_to("Import", new_admin_import_path(:target_model => "Goldencobra::Article"), :class => "importer")
  end

  action_item :only => :edit do
    if resource.versions.last
      link_to("Undo", revert_admin_article_path(:id => resource.versions.last), :class => "undo")
    end
  end

  action_item only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/next_item'
  end
end
