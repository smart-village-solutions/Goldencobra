# encoding: utf-8

module Goldencobra
  module Api
    module V2
      class ArticlesController < ActionController::Base

        include Goldencobra::Api::V2::ArticlesHelper
        respond_to :json

        # /api/v2/articles/search[.json]
        # ---------------------------------------------------------------------------------------
        def search

          # Check if we have an argument.
          unless params[:q]
            render status: 200, json: {}
            return
          end

          # Check if the query string contains something.
          if params[:q].length == 0
            render status: 200, json: {}
          else
            # 1. Do the search and return the search result array.
            render status: 200, json: Goldencobra::Article.simple_search(ActionController::Base.helpers.sanitize(params[:q])).to_json
          end
        end


        # /api/v2/articles/create[.json]
        # ---------------------------------------------------------------------------------------
        def create
          # Check if a user is currently logged in.
          unless current_user
            render status: 403, json: {}
            return
          end

          # Check if we do have an article passed by the parameters.
          unless params[:article]
            render status: 400, json: {}
            return
          end

          # Try to save the article
          if create_article(params[:article])
            render status: 200, json: {}
          else
            render status: 500, json: {}
          end

        end

      end
    end
  end
end
