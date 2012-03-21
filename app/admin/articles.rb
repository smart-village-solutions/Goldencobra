ActiveAdmin.register Goldencobra::Article, :as => "Article" do
  
  menu :parent => "Content-Management", :label => "Artikel", :if => proc{can?(:read, Goldencobra::Article)}
  controller.authorize_resource :class => Goldencobra::Article
    
  filter :parent_ids_in, :as => :select, :collection => proc { Goldencobra::Article.order("title") }, :label => "Parent"
  filter :title
  filter :subtitle
  filter :breadcrumb
  filter :template_file
  filter :created_at
  filter :updated_at
    
  form :html => { :enctype => "multipart/form-data" }  do |f|
    f.inputs "Allgemein", :class => "foldable inputs" do
      f.input :title, :hint => "Der Titel der Seite, kann Leerzeichen und Sonderzeichen enthalten"
      f.input :breadcrumb, :hint => "Kurzer Name fuer die Brotkrumennavigation"
      f.input :url_name, :hint => "Nicht mehr als 64 Zeichen, sollte keine Umlaute, Sonderzeichen oder Leerzeichen enthalten."
      f.input :parent_id, :as => :select, :collection => Goldencobra::Article.all.map{|c| [c.title, c.id]}, :include_blank => true
      f.input :active, :hint => "Ist dieser Artikel online zu sehen?"
    end
    f.inputs "Metadescriptions & Settings", :class => "foldable inputs" do
      f.input :robots_no_index, :hint => "Um bei Google nicht in Konkurrenz zu anderen wichtigen Einzelseiten der eigenen Webseite zu treten, kann hier Google mitgeteilt werden, diese Seite nicht zu indizieren"
      f.input :canonical_url, :hint => "Falls auf dieser Seite Inhalte erscheinen, die vorher schon auf einer anderen Seite erschienen sind, sollte hier die URL der Quellseite eingetragen werden, um von Google nicht f&uuml;r doppelten Inhalt abgestraft zu werden"
      f.input :tag_list, :hint => "Tags sind komma-getrennte Werte, mit denen sich ein Artikel verschlagworten l&auml;sst"
      f.input :enable_social_sharing, :label => t("Display Social Sharing Buttons"), :hint => "Sollen Besucher die Buttons angezeigt bekommen, um diesen Artikel in den Sozialen Netzwerken zu verbreiten?"
      f.has_many :metatags do |m|
        m.input :name, :as => :select, :collection => Goldencobra::Article::MetatagNames, :input_html => { :class => 'metatag_names'} 
        m.input :value, :input_html => { :class => 'metatag_values'} 
        m.input :_destroy, :as => :boolean 
      end
    end
    f.inputs "Inhalt" do
      f.input :content, :hint => "Dies ist das Haupt-Textfeld", :input_html => { :class =>"tinymce"}
      f.input :summary, :hint => "Dient der Einleitung in den Text und wird hervorgehoben dargestellt"
      f.input :context_info, :input_html => { :class =>"tinymce"}, :hint => "Dieser Text ist f&uuml;r eine Sidebar gedacht"
      f.input :teaser, :hint => "Dieser Text wird auf &Uuml;bersichtsseiten angezeigt, um den Artikel zu bewerben"
    end
    f.inputs "Medien", :class => "foldable inputs"  do
      f.has_many :article_images do |ai|
        ai.input :image, :as => :select, :collection => Goldencobra::Upload.all.map{|c| [c.complete_list_name, c.id]}, :input_html => { :class => 'article_image_file'}, :label => "Bild ausw&auml;hlen" 
      end
    end
    
    f.inputs "" do
      f.actions 
    end
  end

  
  index do 
    selectable_column
    column "title", :sortable => :title do |article|
      content_tag("span", link_to(article.title, edit_admin_article_path(article), :class => "member_link edit_link"), :class => article.startpage ? "startpage" : "")
    end
    column "url"  do |article|
      article.public_url
    end
    column :url_name
    column :slug
    column :id
    column :created_at
    column :updated_at
    column "" do |article|
      result = ""
      result += link_to("New Subarticle", new_admin_article_path(:parent => article), :class => "member_link edit_link")
      #result += link_to("View", admin_article_path(article), :class => "member_link view_link")
      result += link_to("Edit", edit_admin_article_path(article), :class => "member_link edit_link")
      result += link_to("Delete", admin_article_path(article), :method => :DELETE, :confirm => "Realy want to delete this Article?", :class => "member_link delete_link")
      raw(result)
    end
  end
  
  sidebar :overview, only: [:index] do
    render :partial => "/goldencobra/admin/shared/overview", :object => Goldencobra::Article.roots, :locals => {:link_name => "title", :url_path => "article" }
  end
  
  sidebar :widgets_options, only: [:edit] do
    _article = @_assigns['article']
    render "/goldencobra/admin/articles/widgets_sidebar", :locals => { :current_article => _article }
  end
  
  sidebar :startpage_options, :only => [:show, :edit] do 
      _article = @_assigns['article']
      if _article.startpage
        "This Article is the Startpage!"
      else
        link_to "Make this article Startpage", mark_as_startpage_admin_article_path(_article.id), :confirm => "Realy want to make this article as ROOT of your website"
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
  
  member_action :mark_as_startpage do
    article = Goldencobra::Article.find(params[:id])
    article.mark_as_startpage!
    redirect_to :action => :show, :notice => "This Article is the Startpage!"
  end
  
  member_action :update_widgets, :method => :post do
    article = Goldencobra::Article.find(params[:id])
    article.update_attributes(:widget_ids => params[:widget_ids])
    redirect_to :action => :edit, :notice => "Widgets added"
  end
  
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
