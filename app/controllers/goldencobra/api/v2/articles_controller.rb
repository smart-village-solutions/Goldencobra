module Goldencobra
  module Api
    module V2
      class ArticlesController < ActionController::Base
        skip_before_filter :verify_authenticity_token
        before_filter :get_article, only: [:show, :breadcrumb]

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


        # /api/v2/articles[.json]
        #
        # @return [json] Liefert Alle Artikel :id,:title, :ancestry
        # map{|c| [c.parent_path, c.id]}
        def index
          if params[:article_ids].present?
            index_with_ids
          else
            @articles = Goldencobra::Article.select([:id, :title, :ancestry]).sort{ |a, b|
              a[0] <=> b[0]
            }

            if params[:react_select] && params[:react_select] == "true"
              # Die React Select Liste braucht das JSON in diesem Format. -hf
              json_uploads = @articles.map{ |a| { "value" => a.id, "label" => a.parent_path } }
            else
              json_uploads = @articles.map{ |a| a.as_json(:only => [:id, :title], :methods => [:parent_path]) }
            end

            respond_to do |format|
              format.json { render json: json_uploads.as_json }
              # Returns all publicly visible, active Articles
              format.xml { @articles = Goldencobra::Article.new.filter_with_permissions(Goldencobra::Article.active, nil) }
            end
          end
        end

        # /api/v2/articles/:url[.json]
        #
        # @param methods [String] "beliebe Attribute des Artikels im JSON einfuegen"
        #
        # @return [json] Liefert Artikel mit einer bestimmten URL
        #                Im JSON Response befinden sich entweder alle Attribute, oder nur die mit
        #                params[:methods] definierten
        def show
          respond_to do |format|
            format.json {
              if params[:methods].present?
                render json: @article,
                       serializer: Goldencobra::ArticleCustomSerializer,
                       scope: params[:methods]
              else
                render json: @article
              end
            }
          end
        end

        # /api/v2/articles/index_with_id[.json]
        #
        # @param methods [String] "beliebe Attribute des Artikels im JSON einfuegen"
        #
        # @return [json] liefert für Artikel mit einer bestimmten URL Kinderartikel zurück,
        #                die wiederum per IDs angefragt wurden
        #
        #                im JSON Response befinden sich entweder alle Attribute, oder nur die mit
        #                params[:methods] definierten
        def index_with_ids
          article_ids = params[:article_ids]
          articles = Goldencobra::Article.where("id IN (?)", article_ids)
          respond_to do |format|
            format.json {
              if params[:methods].present?
                render json: articles,
                       each_serializer: Goldencobra::ArticleCustomSerializer,
                       scope: params[:methods]
              else
                render json: articles
              end
            }
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
            render status: 400, json: { :status => 400, :error => "article data missing" }
            return
          end

          #check if an external referee is passed by the parameters
          unless params[:referee_id]
            render status: 400, json: { :status => 400, :error => "referee_id missing"  }
            return
          end

          #check if Article already exists by comparing external referee and current user of caller
          existing_articles = Goldencobra::Article.where(:creator_id => current_user.id, :external_referee_id => params[:referee_id])
          if existing_articles.any?
            render status: 423, json: { :status => 423, :error => "article already exists", :id => existing_articles.first.id  }
            return
          end

          # Try to save the article
          response = create_article(params[:article])
          if response.id.present?
            render status: 200, json: { :status => 200, :id => response.id }
          else
            render status: 500, json: { :status => 500, :error => response.errors, :id => nil }
          end
        end


        def update
          unless current_user
            render status: 403, json: { :status => 403 }
            return
          end

          # Check if we do have an article passed by the parameters.
          unless params[:article]
            render status: 400, json: { :status => 400, :error => "article data missing" }
            return
          end

          #check if an external referee is passed by the parameters
          unless params[:referee_id]
            render status: 400, json: { :status => 400, :error => "referee_id missing"  }
            return
          end

          #check if Article already exists by comparing external referee and current user of caller
          existing_articles = Goldencobra::Article.where(:creator_id => current_user.id, :external_referee_id => params[:referee_id])
          if existing_articles.blank?
            render status: 423, json: { :status => 423, :error => "article not found", :id => nil  }
            return
          end

          # Try to save the article
          response = update_article(params[:article])
          if response.id.present?
            render status: 200, json: { :status => 200, :id => response.id }

            #Erst render ergebnis dann den rest machen
            if params[:images].present?
              params[:images].each do |key,value|
                existing_images = Goldencobra::Upload.where(:image_remote_url => value[:image][:image_url])
                if existing_images.blank?
                  img = Goldencobra::Upload.create(value[:image])
                else
                  img = existing_images.first
                end
                image_position = Goldencobra::Setting.for_key("goldencobra.article.image_positions").to_s.split(",").map(&:strip).first
                existing_articles.first.article_images.create(:image => img, :position => image_position)
              end
            end

          else
            render status: 500, json: { :status => 500, :error => response.errors, :id => nil }
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

        protected

        # Creates an article from the given article array.
        # ---------------------------------------------------------------------------------------
        def create_article(article_param)

          # Input validation
          return nil unless article_param
          return nil unless params[:article]
          return nil unless current_user
          return nil unless params[:referee_id]

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

          if params[:images].present?
            params[:images].each do |i|
              img = Goldencobra::Upload.create(i[:image])
              article.images << img
            end
          end


          #Set externel Referee
          new_article.external_referee_id = params[:referee_id]
          new_article.external_referee_ip = request.env['REMOTE_ADDR']

          # Try to save the article
          new_article.save
          return new_article
        end


        def update_article(article_param)
          # Input validation
          return nil unless article_param
          return nil unless params[:article]
          return nil unless current_user
          return nil unless params[:referee_id]

          # Get existing article
          article = Goldencobra::Article.where(:creator_id => current_user.id).find_by_external_referee_id(params[:referee_id])

          if params[:author].present? && params[:author][:lastname].present?
            author = Goldencobra::Author.find_or_create_by_lastname(params[:author][:lastname])
            article.author = author
            article.save
          end

          # if params[:images].present?
          #   params[:images].each do |key,value|
          #     existing_images = Goldencobra::Upload.where(:image_remote_url => value[:image][:image_url])
          #     if existing_images.blank?
          #       img = Goldencobra::Upload.create(value[:image])
          #     else
          #       img = existing_images.first
          #     end
          #     image_position = Goldencobra::Setting.for_key("goldencobra.article.image_positions").to_s.split(",").map(&:strip).first
          #     article.article_images.create(:image => img, :position => image_position)
          #   end
          # end

          # Update existing article
          article.update_attributes(params[:article])

          # Try to save the article
          return article
        end

        private

        def get_article
          url = params[:url].present? ? "/#{params[:url]}" : "/"

          @article = Goldencobra::Article.where(url_path: url).first
          unless @article
            raise "Article not found with url: #{url}"
          end
        end
      end
    end
  end
end
