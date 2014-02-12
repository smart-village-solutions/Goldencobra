module Goldencobra
  module Api
    module V2
      class ArticlesController < ActionController::Base

        include Goldencobra::Api::V2::ArticlesHelper
        respond_to :json

        # /api/v2/articles/search[.json]
        # ---------------------------------------------------------------------------------------
        #
        # Format:
        #
        # [
        #  {
        #    'id': ...,
        #    'absolute_public_url': ...,
        #    'title': ...,
        #    'teaser': ...,
        #    'article_type': ...,
        #    'updated_at': ...,
        #    'parent_title': ...,
        #    'ancestry': ...
        #  },
        #  {
        #    ...
        #  },
        #    ...
        # ]
        #
        # ---------------------------------------------------------------------------------------
        def search

          # Check if the query string contains something.
          if params[:q].length == 0
            render status: 200, json: {}
            return
          end

          # 1. Do the search and return the search result array.
          render status: 200, json: do_search(
              ActionController::Base.helpers.sanitize(params[:q])
          )

        end

      end
    end
  end
end
