module ActiveAdmin
  module Views
    class IndexAsTree < ActiveAdmin::Component

      def build(page_presenter, collection)
        @collection = collection
        @origin_ids_to_display = @collection.map(&:id)

        # Get Root Elements to display
        @root_elements = @collection.map(&:root).uniq

        # Get all Element IDs and their parent_ids (path_ids) to display
        @items_to_display = @collection.map(&:path_ids).flatten.uniq

        # Start With root elements and display all children
        # which ar in @items_to_display
        @root_elements.each do |item|
          show_subtree_of_item(item)
        end

      end



      def self.index_name
        "Tree"
      end



      private


      def show_subtree_of_item(item)
        li do
          div :class => "" do
            link_to item.title, edit_admin_article_path(item.id)
          end
          ul do
            item.children.each do |child|
              next unless @items_to_display.include?(child.id)
              show_subtree_of_item(child)
            end
          end
        end
      end

    end
  end
end