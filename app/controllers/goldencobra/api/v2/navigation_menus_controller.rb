module Goldencobra
  module Api
    module V2
      class NavigationMenusController < ActionController::Base
        
        before_filter :get_master_element

        respond_to :json

        # /api/v2/uploads[.json]
        # 
        # @param id [String] [ID of Submenu to render]
        #  
        #  {"1" => [ {"2" => [ {"10" => [] }, ...]} , {"3"  => [] }, ...] }
        # 
        # [
        #   {
        #     "ancestry": "1",
        #     "id": 2,
        #     "target": "/termine",
        #     "title": "Termine"
        #   },
        #   {
        #     "ancestry": "1",
        #     "id": 3,
        #     "target": "/weiteres",
        #     "title": "Weiteres"
        #   },
        #   {
        #     "ancestry": "1/2",
        #     "id": 10,
        #     "target": "/seite1",
        #     "title": "Seite 1"
        #   },
        #   {
        #     "ancestry": "1/2",
        #     "id": 11,
        #     "target": "/seite2",
        #     "title": "Seite 2"
        #   },
        #   {
        #     "ancestry": "1/2/10",
        #     "id": 12,
        #     "target": "/seite1/seite-a",
        #     "title": "Subseite A"
        #   }
        # ]
        # 
        # 
        # 
        #  Response Menü als JSON
        #  {
        #     "active": true,
        #     "ancestry": null,
        #     "ancestry_depth": 0,
        #     "call_to_action_name": null,
        #     "created_at": "2014-10-10T09:43:54+02:00",
        #     "css_class": "",
        #     "description": null,
        #     "description_title": null,
        #     "id": 1,
        #     "image_id": null,
        #     "remote": false,
        #     "sorter": 0,
        #     "target": "",
        #     "title": "Top-Navigation",
        #     "updated_at": "2014-10-10T09:43:54+02:00"
        #  }
        #
        # @return [json] Liefert alle Menüs :id, :complete_list_name
        def index
          # @master_element is set by before filter

          # Set Options
          # How many levels of subtree should be displayed
          depth = params[:depth].present? ? params[:depth].to_i : 9999

          # How many levels of subtree should be skipped
          offset = params[:offset].present? ? params[:offset].to_i : 0

          #Current Level of master element
          current_depth = @master_element.ancestry_depth

          # GEt alls Menus of Subtree from startlevel to endlevel
          @menus = @master_element.subtree.active.after_depth(current_depth + offset).to_depth(current_depth + depth)

          #Prepare Menue Data to Display
          @menue_data_as_json = @menus.arrange_serializable(:order => :sorter) do |parent, children| 
            {
              "id" => parent.id,
              "title" => parent.title,
              "target" => parent.target,
              "children" => children
            }
          end

          respond_to do |format|
            format.json { render json: @menue_data_as_json.as_json(:only => ["id", "title", "target", "children"]) }
          end
        end



        private 

        def get_master_element
          #find MasterElement by ID, Name or TargetUrl
          # Priority ID > Name > Target
          if params[:id]
            @master_element = Goldencobra::Menue.active.find_by_id(params[:id])
          elsif params[:name]
            @master_element = Goldencobra::Menue.active.find_by_pathname(params[:name])
          elsif params[:target]
            @master_element = Goldencobra::Menue.active.find_by_target(params[:target])
          else
            raise "No Menueitem to search for"
          end

          #Validate presents of master element
          raise "No Menueitem found" if @master_element.blank?
        end

      end
    end
  end
end
