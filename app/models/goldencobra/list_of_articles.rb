module Goldencobra
  class ListOfArticles
    include Enumerable
  
    def initialize(article, current_operator=nil, user_frontend_tags=nil)
      @article = article
      @current_operator = current_operator
      @list_of_articles = []

      #Index aller Artikel anzeigen, die Kinder sind von einem Bestimmten artikel
      parent_article = Goldencobra::Article.find_by_id(@article.article_for_index_id)
      if parent_article
        @list_of_articles = children_with_same_type(parent_article, @article.article_type)
      else
        @list_of_articles = Goldencobra::ArticleType.for_index(@article)
      end

      include_related_models

      consider_tagging(user_frontend_tags)

      filter_with_permissions

      sort_list
  
      return @list_of_articles
    end

    def each(&block)
      @list_of_articles.each(&block)
    end
  
    def to_s
      @list_of_articles
    end
  
    private

    def include_related_models
      @list_of_articles = @list_of_articles.includes("#{@article.article_type_form_file.downcase}") if @article.respond_to?(@article.article_type_form_file.downcase)
    end

    def consider_tagging(user_frontend_tags)
      #get articles with tag
      if @article.index_of_articles_tagged_with.present?
        @list_of_articles = @list_of_articles.tagged_with(@article.index_of_articles_tagged_with.split(",").map{|t| t.strip}, on: :tags, any: true)
      end
      #get articles without tag
      if @article.not_tagged_with.present?
        @list_of_articles = @list_of_articles.tagged_with(@article.not_tagged_with.split(",").map{|t| t.strip}, :exclude => true, on: :tags)
      end
      #get_articles_by_frontend_tags
      if user_frontend_tags.present?
        @list_of_articles = @list_of_articles.tagged_with(user_frontend_tags, on: :frontend_tags, any: true)
      end
    end

    def current_operator_can_preview_all_articles
      @current_operator && @current_operator.respond_to?(:has_role?) &&
       @current_operator.has_role?(Goldencobra::Setting.for_key("goldencobra.article.preview.roles").split(",").map{|a| a.strip})
    end
    # Methode filtert die @list_of_articles.
    # Rückgabewert: Ein Array all der Artikel, die der operator lesen darf.
    def filter_with_permissions
      unless current_operator_can_preview_all_articles
        a = Ability.new(@current_operator)
        new_list = []
        @list_of_articles.each do |article|
          if a.can?(:read, article)
            new_list << article.id
          end
        end
        @list_of_articles =  @list_of_articles.where('goldencobra_articles.id in (?)', new_list)
      end
    end
  
    def children_with_same_type(parent_article, type)
      parent_article.descendants.active.where(article_type: type)
    end

    def sort_list
      if @article.sort_order.present?
        if @article.sort_order.include?(".")
          sort_by_related_object_attribute
        else
          begin
            @list_of_articles = "Goldencobra::ListSorter::#{@article.sort_order.classify}".constantize.new(@list_of_articles)
          rescue NameError
            sort_by_article_attribute
          end
        end
        if @article.reverse_sort
          @list_of_articles = @list_of_articles.reverse
        end
      end

      if @article.sorter_limit && @article.sorter_limit > 0
        @list_of_articles = @list_of_articles[0...@article.sorter_limit]
      end
    end
    
    def sort_by_article_attribute
      if @article.respond_to?(@article.sort_order)
        sort_order = @article.sort_order.downcase
        @list_of_articles = @list_of_articles.flatten.sort_by{|art| art.respond_to?(sort_order) ? art.send(sort_order) : art }
      end
    end

    def sort_by_related_object_attribute
      @unsortable = @list_of_articles.flatten.select{|a| !a.respond_to_all?(@article.sort_order) }
      @list_of_articles = @list_of_articles.flatten.delete_if{|a| !a.respond_to_all?(@article.sort_order) }
      @list_of_articles = @list_of_articles.sort_by{|a| eval("a.#{@article.sort_order}") }
      if @unsortable.any?
        @list_of_articles = @unsortable + @list_of_articles
        @list_of_articles = @list_of_articles.flatten
      end
    end
  end
end
