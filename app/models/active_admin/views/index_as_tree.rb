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
          ul :class=> "item_tree" do
            show_subtree_of_item(item)
          end
        end

      end



      def self.index_name
        "Tree"
      end



      private


      def show_subtree_of_item(item)
        li do
          div :class => "tree_item" do 
            div :class => "tree_item_title" do
              item.title
            end
            div do
              link_to(t(:edit), edit_admin_article_path(item.id), :class => "member_link edit_link edit", :title => I18n.t('active_admin.articles.index.article_preview'))
            end
            div do
              link_to(t(:view), item.public_url, :class => "member_link edit_link view", :title => I18n.t('active_admin.articles.index.article_edit'))
            end
            div do
              link_to(t(:new_subarticle), new_admin_article_path(:parent => item), :class => "member_link edit_link new_subarticle", :title => I18n.t('active_admin.articles.index.create_subarticle'))
            end             
            div do
              link_to(t(:delete), admin_article_path(item.id), :method => :DELETE, "data-confirm" => t("delete_article", :scope => [:goldencobra, :flash_notice]), :class => "member_link delete_link delete", :title => I18n.t('active_admin.articles.index.delete_article'))
            end
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