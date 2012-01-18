ActiveAdmin.register Article do
  
  form do |f|
    f.inputs "Allgemein" do
      f.input :title
      f.input :url_name
    end
    
    f.inputs "Inhalt" do
      f.input :teaser
      f.input :content
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
    article = Article.find(params[:id])
    article.mark_as_startpage!
    redirect_to :action => :show, :notice => "This Article is the Startpage!"
  end
    
end
