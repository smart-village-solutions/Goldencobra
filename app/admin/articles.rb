ActiveAdmin.register Goldencobra::Article, :as => "Article" do
    
  form do |f|
    f.inputs "Allgemein" do
      f.input :title, :hint => "Der Titel der Seite, kann Leerzeichen und Sonderzeichen enthalten"
      f.input :url_name, :hint => "Nicht mehr als 64 Zeichen, sollte keine Umlaute, Sonderzeichen oder Leerzeichen enthalten."
      f.input :parent_id, :as => :select, :collection => Goldencobra::Article.all.map{|c| [c.title, c.id]}, :include_blank => true
      f.input :active, :hint => "Ist dieser Artikel online zu sehen?"
    end
    
    f.inputs "Metadescriptions" do
      f.input :robots_no_index, :hint => "Um bei Google nicht in Konkurrenz zu anderen wichtigen Einzelseiten der eigenen Webseite zu treten, kann hier Google mitgeteilt werden, diese Seite nicht zu indizieren"
      f.input :canonical_url, :hint => "Falls auf dieser Seite Inhalte erscheinen, die vorher schon auf einer anderen Seite erschienen sind, sollte hier die URL der Quellseite eingetragen werden, um von Google nicht f&uuml;r doppelten Inhalt abgestraft zu werden"
      f.has_many :metatags do |m|
        m.input :name, :as => :select, :collection => Goldencobra::Article::MetatagNames, :input_html => { :class => 'metatag_names'} 
        m.input :value, :input_html => { :class => 'metatag_values'} 
        m.input :_destroy, :as => :boolean 
      end
    end

    f.inputs "Zus&auml;tzliche Informationen" do
      f.input :teaser, :input_html => { :class =>"tinymce"}, :hint => "Dieser Text wird auf &Uuml;bersichtsseiten angezeigt, um den Artikel zu bewerben"
      f.input :context_info, :input_html => { :class =>"tinymce"}, :hint => "Dieser Text ist f&uuml;r eine Sidebar gedacht"
    end
    
    f.inputs "Inhalt" do
      f.input :summary, :input_html => { :class =>"tinymce"}, :hint => "Dient der Einleitung in den Text und wird hervorgehoben dargestellt"
      f.input :content, :hint => "Dies ist das Haupt-Textfeld", :input_html => { :class =>"tinymce"}
    end
    f.buttons
  end
  
  index do 
    column "title", :title do |article|
      content_tag("span", article.title, :class => article.startpage ? "startpage" : "")
    end
    column "url" do |article|
      link_to article.public_url, article.public_url, :target => "_blank"
    end
    column :created_at
    column :updated_at
    column "" do |article|
      result = ""
      result += link_to("New Subarticle", new_admin_article_path(:parent => article), :class => "member_link edit_link")
      result += link_to("View", admin_article_path(article), :class => "member_link view_link")
      result += link_to("Edit", edit_admin_article_path(article), :class => "member_link edit_link")
      result += link_to("Delete", admin_article_path(article), :method => :DELETE, :confirm => "Realy want to delete this Article?", :class => "member_link delete_link")
      raw(result)
    end
  end
  
  sidebar :startpage_options, :only => [:show, :edit] do 
      _article = @_assigns['article']
      if _article.startpage
        "This Article is the Startpage!"
      else
        link_to "Make this article Startpage", mark_as_startpage_admin_article_path(_article.id), :confirm => "Realy want to make this article as ROOT of your website"
      end
  end
  
  member_action :mark_as_startpage do
    article = Goldencobra::Article.find(params[:id])
    article.mark_as_startpage!
    redirect_to :action => :show, :notice => "This Article is the Startpage!"
  end
  
  controller do 
    def new 
      @article = Goldencobra::Article.new
      if params[:parent] && params[:parent].present? 
        @parent = Goldencobra::Article.find(params[:parent])
        @article.parent_id = @parent.id
      end
    end 
  end
  
    
end
