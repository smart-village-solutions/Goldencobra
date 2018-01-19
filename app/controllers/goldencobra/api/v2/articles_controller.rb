module Goldencobra
  module Api
    module V2
      class ArticlesController < ActionController::Base
        skip_before_filter :verify_authenticity_token
        before_action :get_article,            only: [:show, :breadcrumb]
        before_action :find_article,           only: [:update]
        before_action :check_for_current_user, only: [:create, :update]
        before_action :check_for_article,      only: [:create, :update]
        before_action :check_for_referee,      only: [:create, :update]

        respond_to :json

        # /api/v2/articles/search[.json]
        # ----------------------------------------------------------------------
        def search
          # Check if we have an argument.
          unless params[:q]
            render status: 200, json: { status: 200 }
            return
          end

          # Check if the query string contains something.
          if params[:q].length == 0
            render status: 200, json: { status: 200 }
          else
            # Search and return the result array.
            render status: 200, json: Goldencobra::Article.simple_search(
              ActionController::Base.helpers.sanitize(params[:q])
            ).to_json
          end
        end


        # /api/v2/articles[.json]
        #
        # @return [json] Liefert Alle Artikel :id, :title, :parent_path
        # map{ |c| [c.parent_path, c.id] }
        def index
          if params[:article_ids].present?
            index_with_ids
          else
            @articles = cached_articles

            respond_to do |format|
              format.json do
                render json: Oj.dump(
                  { articles: articles_as_json },
                  mode: :compat
                )
              end
              # Returns all publicly visible, active Articles
              format.xml do
                @articles = Goldencobra::Article.
                            new.
                            filter_with_permissions(
                              Goldencobra::Article.active,
                              nil
                            )
              end
            end
          end
        end

        # /api/v2/articles/:url[.json]
        #
        # @param methods [String] "beliebe Attribute des Artikels im JSON
        #                         einfuegen"
        #
        # @return [json] Liefert Artikel mit einer bestimmten URL
        #                Im JSON Response befinden sich entweder alle Attribute,
        #                oder nur die mit params[:methods] definierten
        def show
          respond_to do |format|
            format.json do
              if params[:methods].present?
                render json: Oj.dump(
                  @article.as_json,
                  serializer: Goldencobra::ArticleCustomSerializer,
                  scope: params[:methods]
                )
              else
                render json: Oj.dump(@article.as_json)
              end
            end
          end
        end

        # /api/v2/articles/index_with_id[.json]
        #
        # @param methods [String] "beliebe Attribute des Artikels im JSON
        #                         einfuegen"
        #
        # @return [json] liefert für Artikel mit einer bestimmten URL
        #                Kinderartikel zurück, die wiederum per IDs angefragt
        #                wurden
        #
        #                im JSON Response befinden sich entweder alle Attribute,
        #                oder nur die mit params[:methods] definierten
        def index_with_ids
          article_ids = params[:article_ids]
          cache_key ||= ["indexarticles", article_ids]

          articles = Rails.cache.fetch(cache_key) do
            Goldencobra::Article.where("id IN (?)", article_ids)
          end
          respond_to do |format|
            format.json do
              if params[:methods].present?
                render json: Oj.dump(
                  articles,
                  each_serializer: Goldencobra::ArticleCustomSerializer,
                  scope: params[:methods]
                )
              else
                render json: Oj.dump(articles)
              end
            end
          end
        end

        # /api/v2/articles/create[.json]
        # ----------------------------------------------------------------------
        def create
          if existing_articles.any?
            render status: 423, json: {
              status: 423,
              error: "article already exists",
              id: existing_articles.first.id
            } and return
          end

          # Try to save the article
          response = create_article(params[:article])
          if response.id.present?
            render status: 200, json: { status: 200, id: response.id }
          else
            render status: 500, json: {
              status: 500,
              error: response.errors,
              id: nil
            }
          end
        end


        def update
          if @article.update_attributes(params[:article])
            render status: 200, json: { status: 200, id: @article.id }
            # Erst render Ergebnis dann den Rest machen
            create_images(@article, params[:images])
          else
            render_error(response.errors, 500)
          end
        end

        def breadcrumb
          breadcrumb = []
          @article.path.each do |art|
            breadcrumb << {
              title: art.breadcrumb_name,
              url: art.public_url
            }
          end
          respond_to do |format|
            format.json { render json: breadcrumb.to_json }
          end
        end



        private

        def find_article
          attrs = {
            creator_id: current_user.id,
            external_referee_id: params[:referee_id]
          }.delete_if { |_k, v| v.blank? }
          @article = Goldencobra::Article.where(attrs).first

          render_error("article not found", 423) and return unless @article
        end

        def setup_params(old_params)
          old_params.merge(
            creator_id: current_user.id,
            article_type: old_params.fetch(:article_type, "Default Show"),
            external_referee_id: params[:referee_id],
            external_referee_ip: request.env["REMOTE_ADDR"]
          ).merge(author.present? ? { author: author } : {})
        end

        def author
          if params[:author].present? && params[:author][:lastname].present?
            Goldencobra::Author.find_or_create_by_lastname(
              params[:author][:lastname]
            )
          end
        end

        def create_article(article_params)
          new_params = setup_params(article_params)
          new_article = Goldencobra::Article.new(new_params)
          # TODO: Does not work atm.
          # article_params.each do |i|
          #   new_article.images << Goldencobra::Upload.create(i[:image])
          # end
          new_article.save
          new_article
        end

        def check_for_current_user
          render_error(nil, 403) and return unless current_user
        end

        def check_for_article
          render_error("article data missing") and return unless params[:article]
        end

        def check_for_referee
          render_error("referee_id missing") and return unless params[:referee_id]
        end

        def render_error(message, status = 400)
          if message
            render status: status, json: { status: status, error: message }
          else
            render status: status, json: { status: status }
          end
        end

        def existing_articles
          attrs = {
            creator_id: current_user.id,
            external_referee_id: params[:referee_id]
          }.delete_if { |_k, v| v.blank? }
          Goldencobra::Article.where(attrs)
        end

        def create_images(article, images)
          images.each do |key,value|
            existing_images = Goldencobra::Upload.where(
              image_remote_url: value[:image][:image_url]
            )
            if existing_images.blank?
              img = Goldencobra::Upload.create(value[:image])
            else
              img = existing_images.first
            end
            image_position = Goldencobra::Upload.default_position
            article.article_images.create(image: img, position: image_position)
          end
        end

        def get_article
          url = params[:url].present? ? "/#{params[:url]}" : "/"

          @article = Goldencobra::Article.where(url_path: url).first
          unless @article
            raise "Article not found with url: #{url}"
          end
        end

        def articles_as_json
          if params[:react_select] && params[:react_select] == "true"
            # Die React Select Liste braucht das JSON in diesem Format. -hf
            @articles.map { |a| { "value" => a.id, "label" => a.parent_path } }
                     .sort { |a, b| a["label"] <=> b["label"] }
          else
            @articles.to_a.map do |a|
              a.as_json(only: [:id, :title], methods: [:parent_path])
            end
          end
        end

        def cached_articles
          cache_key = [
            "index-articles", "v2",
            Goldencobra::Article.order("updated_at DESC").limit(1).first.cache_key
          ]

          Rails.cache.fetch(cache_key) do
            Goldencobra::Article.select([:id, :title, :ancestry]).sort do |a, b|
              a[0] <=> b[0]
            end
          end
        end
      end
    end
  end
end
