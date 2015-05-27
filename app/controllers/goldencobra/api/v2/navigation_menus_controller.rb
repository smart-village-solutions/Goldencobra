module Goldencobra
  module Api
    module V2
      class NavigationMenusController < ActionController::Base

        before_filter :get_master_element

        respond_to :json


        # Get active IDs of current request/url
        # Searches in Subtree of a given MasterElement
        # @param id [String] [ID of Submenu to search for]
        # @param url [String] Url to Search vor Active MenueIDs
        #
        # Example
        # http://localhost:3000/api/v2/navigation_menus/active?id=1&url=/seite1/seite-a
        #
        # @return [Integer] Array if Integers als Menue IDs
        def active_ids
          # @master_element is set by before filter

          if params[:url].present?
            url_to_search = params[:url]

            # URI parse domain and url path
            parsed_url = URI(url_to_search)

            current_menue = @master_element.subtree.active.where(:target => parsed_url.path).first
            if current_menue.present?
              @active_menue_ids = current_menue.path_ids
            else
              @active_menue_ids = []
            end
          else
            @active_menue_ids = []
          end

          respond_to do |format|
            format.json { render json: @active_menue_ids }
          end
        end



        # /api/v2/navigation_menus[.json]
        #
        # @param id [String] [ID of Submenu to render]
        # @param methods [String] "css_class,liquid_description,navigation_image,description_title,call_to_action_name"
        # [
        #     {
        #         "id": 2,
        #         "title": "Startseite",
        #         "target": "/",
        #         "children": [
        #             {
        #                 "id": 10,
        #                 "title": "Seite 1",
        #                 "target": "/seite1",
        #                 "children": [
        #                     {
        #                         "id": 12,
        #                         "title": "Subseite A",
        #                         "target": "/seite1/seite-a",
        #                         "children": []
        #                     }
        #                 ]
        #             },
        #             {
        #                 "id": 11,
        #                 "title": "Seite 2",
        #                 "target": "/seite2",
        #                 "children": []
        #             }
        #         ]
        #     },
        #     {
        #         "id": 5,
        #         "title": "Weiteres",
        #         "target": "/weiteres",
        #         "children": []
        #     }
        # ]
        #
        #
        #
        #  Response as JSON
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
        # @return [json] All menus with :id, :complete_list_name, etc.
        def index
          # @master_element is set by before filter

          # Generate cache key: if any Menuitem is changed => invalidate
          last_modified = Goldencobra::Menue.order(:updated_at).pluck(:updated_at).last.to_i
          cache_sub_key = [ params[:depth], params[:offset], display_methods, last_modified ].flatten.join("_")
          cache_key = "Navigation/menue_#{@master_element.id}/#{Digest::MD5.hexdigest(cache_sub_key)}"

          #Gibt es das Menü bereits im Cache?
          # if Rails.cache.exist?(cache_key)
            # @json_tree = Rails.cache.read(cache_key)
          # else
            # How many levels of subtree should be displayed
            depth = params[:depth].present? ? params[:depth].to_i : 9999

            # How many levels of subtree should be skipped
            offset = params[:offset].present? ? params[:offset].to_i : 0

            # Current Level of master element
            current_depth = @master_element.ancestry_depth

            # Get all menus of subtree from startlevel to endlevel
            menus = @master_element.subtree.active.visible
            menus = filter_elements(menus)
            menus = menus.after_depth(current_depth + offset).to_depth(current_depth + depth)

            # Prepare menu data to display
            menue_data_as_json = menus.arrange(:order => :sorter)

            # JsonTree to display, use specified display_methods
            @json_tree = Goldencobra::Menue.json_tree(menue_data_as_json, display_methods )

            # Save result to cache
            # Rails.cache.write(cache_key, @json_tree)
          # end

          respond_to do |format|
            format.json { render json: @json_tree }
          end
        end



        private

        def get_master_element
          # find MasterElement by ID, Name or TargetUrl
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

          # Validate presence of master element
          raise "No Menueitem found" if @master_element.blank?
        end


        def display_methods
          filtered_methods = []

          if params[:methods].present?
            additional_elements_to_show = params[:methods].split(",").compact

            filtered_methods = Goldencobra::Menue.filtered_methods(additional_elements_to_show)
          end

          return filtered_methods
        end

        def filter_elements(menus)
          return menus unless params[:filter_classes]
          filter_classes = params[:filter_classes].split(",")

          filter_classes.each do |filter_class|
            filter_string = "%#{filter_class}%"
            menus = menus.where('goldencobra_menues.css_class NOT LIKE ?', filter_string)
          end
          menus
        end
      end
    end
  end
end
