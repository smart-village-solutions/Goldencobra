# encoding: utf-8

module Goldencobra
  module Api
    module V2
      class ArticlesController < ActionController::Base

        respond_to :json

        # /api/v2/articles/search[.json]
        # ---------------------------------------------------------------------------------------
        def search

          # Check if we have an argument.
          unless params[:q]
            render status: 200, json: { :status => 200 }
            return
          end

          # Check if the query string contains something.
          if params[:q].length == 0
            render status: 200, json: { :status => 200 }
          else
            # Search and return the result array.
            render status: 200, json: Goldencobra::Article.simple_search(
                ActionController::Base.helpers.sanitize(params[:q])
            ).to_json
          end
        end


        # /api/v2/articles/create[.json]
        # ---------------------------------------------------------------------------------------
        def create
          # Check if a user is currently logged in.
          unless current_user
            render status: 403, json: { :status => 403 }
            return
          end

          # Check if we do have an article passed by the parameters.
          unless params[:article]
            render status: 400, json: { :status => 400 }
            return
          end

          # Try to save the article
          if resposne = create_article(params[:article])
            render status: 200, json: { :status => 200, :id => resposne.id }
          else
            render status: 500, json: { :status => 500, :error => response.errors }
          end

        end


        protected

        # Creates an article from the given article array.
        # ---------------------------------------------------------------------------------------
        def create_article(article_param)

          # Input validation
          return nil unless article_param
          return nil unless params[:article]
          return nil unless current_user

          # Create a new article
          new_article = Goldencobra::Article.new(params[:article])
          new_article.creator_id = current_user.id

          if params[:article][:article_type]
            new_article.article_type = params[:article][:article_type]
          else
            new_article.article_type = 'Default Show'
          end

          if params[:author].present? && params[:author][:lastname].present?
            author = Goldencobra::Author.find_or_create_by_lastname(params[:author][:lastname])
            new_article.author = author
          end

          # Try to save the article
          new_article.save ? new_article : nil

        end


      end
    end
  end
end
