ActiveAdmin.register Goldencobra::Article, :as => "Article" do
  
  menu :parent => "Content-Management", :if => proc{can?(:read, Goldencobra::Article)}
  controller.authorize_resource :class => Goldencobra::Article
    
  filter :parent_ids_in, :as => :select, :collection => proc { Goldencobra::Article.order("title") }, :label => "Parent"
  filter :title
  filter :subtitle
  filter :breadcrumb
  filter :template_file
  filter :created_at
  filter :updated_at
  
  scope "Alle", :scoped, :default => true
  scope "online", :active
  scope "offline", :inactive
  
  
  form :html => { :enctype => "multipart/form-data" }  do |f|  
    render :partial => "/goldencobra/admin/articles/article_type", :locals => {:f => f}
    if f.object.new_record? 
      render :partial => "/goldencobra/admin/articles/select_article_type", :locals => {:f => f}
    else
      f.inputs :class => "buttons inputs" do
        f.actions
      end
      f.inputs "Allgemein", :class => "foldable inputs" do
        f.input :title, :hint => "Der Titel der Seite, kann Leerzeichen und Sonderzeichen enthalten"
        f.input :content, :label => "Haupt-Textfeld", :input_html => { :class =>"tinymce"}
        f.input :active, :hint => "Ist dieser Artikel online zu sehen?"
      end
      if f.object.article_type.present?
        render :partial => "articletypes/#{f.object.article_type_form_file}/edit", :locals => {:f => f}
      end
      f.inputs "Metadescriptions", :class => "foldable inputs" do
        f.input :hint_label, :as => :text, :label => "Metatags fuer Suchmaschinenoptimierung", :input_html => {:disabled => true, :resize => false, :value => "<b>Metatags k&ouml;nnen genutzt werden, um den Artikel f&uuml;r Suchmaschinen besser sichtbar zu machen.</b><br />
                                                                                                               Sie haben folgende Werte zur Wahl:<br />
                                                                                                               <ul>
                                                                                                               <li><strong>Title Tag:</strong> Der Title der Seite. Wird nicht als Titel angezeigt. Ist nur f&uuml;r Google & Co. gedacht. </li>
                                                                                                               <li><strong>Metadescription:</strong> Wird als Beschreibung des Artikels angezeigt, wenn Google ihn gefunden hat. <strong>Wichtig!</strong></li>
                                                                                                               <li><strong>Keywords:</strong></li>
                                                                                                               <li><strong>OpenGraph Title:</strong> Title, der bei Facebook angezeigt werden soll, wenn der Artikel geteilt wird.</li>
                                                                                                               <li><strong>OpenGraph Type:</strong> Sie haben die Wahl zwischen Blog, Article oder Website</li>
                                                                                                               <li><strong>OpenGraph URL:</strong> Die URL der Website. Standardm&auml;&szlig; wird die URL des Artikels genutzt. Muss nur ver&auml;ndert werden, wenn dort etwas anderes stehen soll.</li>
                                                                                                               <li><strong>OpenGraph Image:</strong> Muss als URL &uuml;bergeben werden (http://www.mein.de/bild.jpg). Erscheint dann bei Facebook als Bild des Artikels.</li>
                                                                                                               </ul>", :class => "metadescription_hint", :id => "metadescription-tinymce"}
        f.has_many :metatags do |m|
          m.input :name, :as => :select, :collection => Goldencobra::Article::MetatagNames, :input_html => { :class => 'metatag_names'}, :hint => "Hier k&ouml;nnen Sie die verschiedenen Metatags definieren, sowie alle Einstellungen f&uuml;r den OpenGraph vonehmen."
          m.input :value, :input_html => { :class => 'metatag_values'} 
          m.input :_destroy, :as => :boolean 
        end
      end
      f.inputs "Einstellungen" do
        f.input :breadcrumb, :hint => "Kurzer Name fuer die Brotkrumennavigation"
        f.input :url_name, :hint => "Nicht mehr als 64 Zeichen, sollte keine Umlaute, Sonderzeichen oder Leerzeichen enthalten. Wenn die Seite unter 'http://meine-seite.de/mein-artikel' erreichbar sein soll, tragen Sie hier 'mein-artikel' ein.", :label => "Website-Adresse des Artikels", required: false
        f.input :parent_id, :as => :select, :collection => Goldencobra::Article.all.map{|c| [c.title, c.id]}, :include_blank => true, :hint => "Auswahl des Artikels, der in der Seitenstruktur _oberhalb_ liegen soll. Beispiel: http://www.meine-seite.de/der-oberartikel/mein-artikel"
        f.input :canonical_url, :hint => "Falls auf dieser Seite Inhalte erscheinen, die vorher schon auf einer anderen Seite erschienen sind, sollte hier die URL der Quellseite eingetragen werden, um von Google nicht f&uuml;r doppelten Inhalt abgestraft zu werden"
        f.input :tag_list, :hint => "Tags sind komma-getrennte Werte, mit denen sich ein Artikel verschlagworten l&auml;sst", :label => "Liste von Tags"
        f.input :enable_social_sharing, :label => t("Display Social Sharing Buttons"), :hint => "Sollen Besucher die Buttons angezeigt bekommen, um diesen Artikel in den Sozialen Netzwerken zu verbreiten?"
        f.input :robots_no_index, :hint => "Um bei Google nicht in Konkurrenz zu anderen wichtigen Einzelseiten der eigenen Webseite zu treten, kann hier Google mitgeteilt werden, diese Seite nicht zu indizieren"
        f.input :cacheable, :as => :boolean, :hint => "Dieser Artikel darf im Cache liegen"
      end
      f.inputs "Weiterer Inhalt" do
        f.input :subtitle
        f.input :context_info, :input_html => { :class =>"tinymce"}, :hint => "Dieser Text ist f&uuml;r eine Sidebar gedacht", label: "Seitenleisten Text"
        f.input :summary, :label => "Zusammenfassung", hint: "Dient der Einleitung in den Text und wird hervorgehoben dargestellt", :input_html=>{ :rows=>5 }
        f.input :teaser, :hint => "Dieser Text wird auf &Uuml;bersichtsseiten angezeigt, um den Artikel zu bewerben", label: "Teaser Text", :input_html=>{ :rows=>5 }
      end
      f.inputs "Medien", :class => "foldable inputs"  do
        f.has_many :article_images do |ai|
          ai.input :image, :as => :select, :collection => Goldencobra::Upload.all.map{|c| [c.complete_list_name, c.id]}, :input_html => { :class => 'article_image_file chzn-select'}, :label => "Bild ausw&auml;hlen" 
        end
      end
    end
    f.inputs class: "buttons inputs" do
      f.actions
    end
  end

  
  index do 
    selectable_column
    column "name", :sortable => :breadcrumb do |article|
      content_tag("span", link_to(truncate(article.breadcrumb_name, :length => 40), edit_admin_article_path(article), :class => "member_link edit_link"), :class => article.startpage ? "startpage" : "")
    end
    column :url  do |article|
      article.public_url
    end
    column :active, :sortable => :active do |article|
      link_to(article.active ? "online" : "offline", set_page_online_offline_admin_article_path(article),:confirm => "Sichtbarkeit dieses Artikels aendern?", :class => "member_link edit_link #{article.active ? 'online' : 'offline'}")
    end
    column :created_at, sortable: :created_at do |article|
      l(article.created_at)
    end
    column :updated_at, sortable: :updated_at do |article|
      l(article.updated_at)
    end
    column "" do |article|
      result = ""
      result += link_to(t(:edit), edit_admin_article_path(article), :class => "member_link edit_link")
      result += link_to(t(:new_subarticle), new_admin_article_path(:parent => article), :class => "member_link edit_link")
      result += link_to(t(:delete), admin_article_path(article), :method => :DELETE, :confirm => "Realy want to delete this Article?", :class => "member_link delete_link")
      raw(result)
    end
  end
  
  sidebar :overview, label: "Ueberblick", only: [:index] do
    render :partial => "/goldencobra/admin/shared/overview", :object => Goldencobra::Article.roots, :locals => {:link_name => "breadcrumb_name", :url_path => "article" }
  end
  
  sidebar :widgets_options, label: "Widgets", only: [:edit] do
    _article = @_assigns['article']
    render "/goldencobra/admin/articles/widgets_sidebar", :locals => { :current_article => _article }
  end
  
  sidebar :startpage_options, :only => [:show, :edit] do 
      _article = @_assigns['article']
      if _article.startpage
        "This Article is the Startpage!"
      else
        link_to "Make this article Startpage", mark_as_startpage_admin_article_path(_article.id), :confirm => "Really want to make this article as ROOT of your website"
      end
  end
  
  sidebar :layout, only: [:edit] do
      _article = @_assigns['article']
      render "/goldencobra/admin/articles/layout_sidebar", :locals => { :current_article => _article }
  end

  sidebar :index_of_articles, only: [:edit] do
    render "/goldencobra/admin/articles/index_of_articles_sidebar"
  end

  
  sidebar :image_module, :only => [:edit] do
    render "/goldencobra/admin/articles/image_module_sidebar"
  end
    
  action_item :only => :edit do
      _article = @_assigns['article']
      link_to('Vorschau zu diesem Artikel anzeigen', _article.public_url, :target => "_blank")
  end
  
  member_action :mark_as_startpage do
    article = Goldencobra::Article.find(params[:id])
    article.mark_as_startpage!
    flash[:notice] = "Dieser Artikel ist nun der Startartikel"
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
         format.html { redirect_to edit_admin_article_path(@article), :flash => flash }
      end
    end
    
    def new       
      @article = Goldencobra::Article.new
      if params[:parent] && params[:parent].present? 
        @parent = Goldencobra::Article.find(params[:parent])
        @article.parent_id = @parent.id
      end
    end 
  end
  
    
end
