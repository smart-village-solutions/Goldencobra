# encoding: utf-8

module Goldencobra
  class Article < ActiveRecord::Base

    #scope for index articles, display show articles, index articless or both articles of an current type
    def self.articletype_for_index(current_article)
      if current_article.display_index_types == "show"
        articletype("#{current_article.article_type_form_file} Show")
      elsif current_article.display_index_types == "index"
        articletype("#{current_article.article_type_form_file} Index")
      else
        where("article_type = '#{current_article.article_type_form_file} Show' OR article_type = '#{current_article.article_type_form_file} Index'")
      end
    end

    def render_html(layoutfile="application", localparams={})
      av = ActionView::Base.new(ActionController::Base.view_paths + ["#{::Goldencobra::Engine.root}/app/views/goldencobra/articles/"])
      av.request = ActionDispatch::Request.new(Rack::MockRequest.env_for(self.public_url))
      av.request["format"] = "text/html"
      av.controller = Goldencobra::ArticlesController.new
      av.controller.request = av.request
      if localparams.present? && localparams[:params].present?
        av.params.merge!(localparams[:params])
      end
      av.assign({:article => self})
      html_to_render = av.render(template: "/goldencobra/articles/show.html.erb", :layout => "layouts/#{layoutfile}", :locals => localparams, :content_type => "text/html" )
      return html_to_render
    end

    def comments_of_subarticles
      Goldencobra::Comment.where("article_id in (?)", self.subtree_ids)
    end

    def find_related_subarticle
      if self.dynamic_redirection == "latest"
        self.descendants.order("id DESC").first
      else
        self.descendants.order("id ASC").first
      end
    end


    def index_articles(current_operator=nil, user_frontend_tags=nil)
      if self.article_for_index_id.blank?
        #Index aller Artikel anzeigen
        @list_of_articles = Goldencobra::Article.active.articletype_for_index(self)
      else
        #Index aller Artikel anzeigen, die Kinder sind von einem Bestimmten artikel
        parent_article = Goldencobra::Article.find_by_id(self.article_for_index_id)
        if parent_article
          @list_of_articles = parent_article.descendants.active.articletype_for_index(self)
        else
          @list_of_articles = Goldencobra::Article.active.articletype_for_index(self)
        end
      end
      #include related models
      @list_of_articles = @list_of_articles.includes("#{self.article_type_form_file.underscore.parameterize.downcase}") if self.respond_to?(self.article_type_form_file.underscore.parameterize.downcase)
      #get articles with tag
      if self.index_of_articles_tagged_with.present?
        @list_of_articles = @list_of_articles.tagged_with(self.index_of_articles_tagged_with.split(",").map{|t| t.strip}, on: :tags, any: true)
      end
      #get articles without tag
      if self.not_tagged_with.present?
        @list_of_articles = @list_of_articles.tagged_with(self.not_tagged_with.split(",").map{|t| t.strip}, :exclude => true, on: :tags)
      end
      #get_articles_by_frontend_tags
      if user_frontend_tags.present?
        @list_of_articles = @list_of_articles.tagged_with(user_frontend_tags, on: :frontend_tags, any: true)
      end
      #filter with permissions
      @list_of_articles = filter_with_permissions(@list_of_articles,current_operator)

      #sort list of articles
      if self.sort_order.present?
        if self.sort_order == "Random"
          @list_of_articles = @list_of_articles.flatten.shuffle
        elsif self.sort_order == "Alphabetical"
          @list_of_articles = @list_of_articles.flatten.sort_by{|article| article.title }
        elsif self.respond_to?(self.sort_order.downcase)
          sort_order = self.sort_order.downcase
          @list_of_articles = @list_of_articles.flatten.sort_by{|article| article.respond_to?(sort_order) ? article.send(sort_order) : article }
        elsif self.sort_order.include?(".")
          sort_order = self.sort_order.downcase.split(".")
          @unsortable = @list_of_articles.flatten.select{|a| !a.respond_to_all?(self.sort_order) }
          @list_of_articles = @list_of_articles.flatten.delete_if{|a| !a.respond_to_all?(self.sort_order) }
          @list_of_articles = @list_of_articles.sort_by{|a| eval("a.#{self.sort_order}") }
          if @unsortable.count > 0
            @list_of_articles = @unsortable + @list_of_articles
            @list_of_articles = @list_of_articles.flatten
          end
        end
        if self.reverse_sort
          @list_of_articles = @list_of_articles.reverse
        end
      end
      if self.sorter_limit && self.sorter_limit > 0
        @list_of_articles = @list_of_articles[0..self.sorter_limit-1]
      end

      return @list_of_articles
    end

  end
end