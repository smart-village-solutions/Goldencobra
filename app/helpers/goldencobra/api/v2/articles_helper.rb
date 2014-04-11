# encoding: utf-8

module Goldencobra
  module Api
    module V2
      module ArticlesHelper

        def create_article(article_param)

          return nil unless article_param

          # Create a new article
          new_article = Goldencobra::Article.new

          # Write the given attributes to the new article.
          # If some mandatory fields are missing, we do not care about here,
          # because the validation would deny to save the new article.
          new_article.title = params[:article][:title] if params[:article][:title]
          new_article.breadcrumb = params[:article][:breadcrumb] if params[:article][:breadcrumb]

          if params[:article][:article_type]
            new_article.article_type = params[:article][:article_type]
          else
            new_article.article_type = 'Default Show'
          end

          new_article.creator_id = current_user.id

          # If there is a parent article, we need to do the same things again.
          new_article.ancestry = create_article(params[:article][:ancestry]) if params[:article][:ancestry]

          # Try to save the article
          if new_article.save
            new_article
          else
            nil
          end

        end

      end
    end
  end
end

