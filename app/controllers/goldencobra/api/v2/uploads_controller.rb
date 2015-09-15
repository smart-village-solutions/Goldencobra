module Goldencobra
  module Api
    module V2
      class UploadsController < ActionController::Base

        respond_to :json

        # /api/v2/uploads[.json]
        #
        # @return [json] Liefert alle Uploads :id, :complete_list_name
        def index
          require "oj"

          @uploads = Goldencobra::Upload.order("image_file_name, updated_at DESC").select([:id, :image_file_name, :source, :rights, :updated_at])

          # Die React Select Liste braucht das JSON in diesem Format. -hf
          json_uploads = @uploads.map{ |u| { "value" => u.id, "label" => u.complete_list_name } }

          respond_to do |format|
            format.json { render json: {"uploads" => Oj.dump(json_uploads, mode: :compat) }  }
          end
        end
      end
    end
  end
end
