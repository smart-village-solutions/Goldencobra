ActiveAdmin.register Goldencobra::Article, :as => "Article" do
  
  form do |f|
    f.inputs "Allgemein" do
      f.input :title, :hint => "Der Titel der Seite, kann Leerzeichen und Sonderzeichen enthalten"
      f.input :url_name, :hint => "Nicht mehr als 64 Zeichen, sollte keine Umlaute oder Sonderzeichen enthalten. Aus 'Toller Artikel u&uml;ber mich' wird 'toller-artikel-ueber-mich'"
    end
    
    f.inputs "Inhalt" do
      f.input :teaser
      f.input :content, :hint => "Dies ist ein Textfeld"
    end
    f.buttons
  end
  
  index do 
    column "title", :title do |article|
      content_tag("span", article.title, :class => article.startpage ? "startpage" : "")
    end
    column :created_at
    column :updated_at
    default_actions
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
    
end
