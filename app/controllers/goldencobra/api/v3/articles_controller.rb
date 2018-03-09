module Goldencobra
  module Api
    module V3
      class ArticlesController < ActionController::Base
        skip_before_action :verify_authenticity_token
        before_action :get_article,            only: [:show]

        respond_to :json

        # /api/v3/articles[.json]
        #
        # @return [json] Liefert Alle Artikel :id, :title, :parent_path
        # map{ |c| [c.parent_path, c.id] }
        def index
          if params[:article_ids].present?
            index_with_ids
          else
            @articles = Goldencobra::Article.active
            @articles = @articles.tagged_with(params[:tags].split(","), on: :tags) if params[:tags].present?
            @articles = @articles.tagged_with(params[:no_tags].split(","), exclude: true, on: :tags) if params[:no_tags].present?

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

        # /api/v3/articles/:id[.json]
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

        # /api/v3/articles/index_with_id[.json]
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

        private

        def render_error(message, status = 400)
          if message
            render status: status, json: { status: status, error: message }
          else
            render status: status, json: { status: status }
          end
        end

        def get_article
          @article = Goldencobra::Article.where(id: params[:id]).first
          unless @article
            raise "Article not found with url: #{url}"
          end
        end

        def articles_as_json
          @articles.map do |a|
            a.as_json(methods: [:public_url, :index_articles, :image_standard_big])
          end
        end
      end
    end
  end
end
