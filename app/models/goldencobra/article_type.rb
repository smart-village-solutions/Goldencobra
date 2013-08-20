module Goldencobra
  class ArticleType
    def initialize(article)
      @article = article
    end
  
    def kind
      @article.article_type.present? ? @article.article_type.split(" ").last : ""
    end

    def form_file
      @article.article_type.split(" ").first if @article.article_type.present?
    end

    def for_search
      if @article.article_type.present?
        @article.article_type.split(" ").first
      else
        "Article"
      end
    end

    def self.for_index(article)
      if article.display_index_types == "show"
        Goldencobra::Article.active.articletype("#{article.article_type_form_file} Show")
      elsif article.display_index_types == "index"
        Goldencobra::Article.active.articletype("#{article.article_type_form_file} Index")
      else
        Goldencobra::Article.active.where("article_type = '#{article.article_type_form_file} Show' OR article_type = '#{article.article_type_form_file} Index'")
      end
    end

    def self.article_types_for_select
      results = []
      path_to_articletypes = File.join(::Rails.root, "app", "views", "articletypes")
      if Dir.exist?(path_to_articletypes)
        Dir.foreach(path_to_articletypes) do |name|
          file_name_path = File.join(path_to_articletypes,name)
          if File.directory?(file_name_path)
            Dir.foreach(file_name_path) do |sub_name|
                file_name = "#{name}#{sub_name}" if File.exist?(File.join(file_name_path,sub_name)) && (sub_name =~ /^_(?!edit).*/) == 0
                results << file_name.split(".").first.to_s.titleize if file_name.present?
            end
          end
        end
      end
      return results
    end


  end
end
