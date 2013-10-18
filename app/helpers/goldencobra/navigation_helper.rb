module Goldencobra
  module NavigationHelper

    def breadcrumb(options={})
      id_name = options[:id] || "breadcrumb"
      class_name = options[:class] || ""
      if @article
        list = ""
        @article.path.each do |art|
          link_name = link_to(art.breadcrumb_name, art.public_url)
          list << content_tag(:li, raw(link_name))
        end
        content_list = content_tag(:ol, raw(list))
        if id_name.present?
          result = content_tag(:nav, raw(content_list), :id => "#{id_name}", :class => "#{class_name}")
        else
          result = content_tag(:nav, raw(content_list), :class => "#{class_name}")
        end
        return raw(result)
      end
    end

    #
    # navigation_menu("Hauptmenue", :depth => 1, :class => "top", :id => "menue1", :offset => 1 )
    # depth: 0 = unlimited, 1 = self, 2 = self and children 1. grades, 3 = self and up to children 2.grades
    # offset: number of levels to skip, 0 = none

    #<%= navigation_menu("Top-Menu", :current_article => @article, :class => "ul_main_nav", :depth => 1, :offset => 1 %>

    #TODO: offset implementieren
    def navigation_menu(menue_id, options={})
      return "id can't be blank" if menue_id.blank?
      depth = options[:depth] || 0
      offset = options[:offset] || 0
      class_name = options[:class] || ""
      id_name = options[:id] || ""
      submenue_of_article = options[:submenue_of_article] || ""
      current_article = options[:current_article] || ""

      if menue_id.class == String
        if current_article.present? && current_article.public_url.present?
          current_menue = Goldencobra::Menue.active.where(:target => current_article.public_url(false)).select{|a| a.path.map(&:title).join("/").include?(menue_id)}.first
          if current_menue
            master_menue = Goldencobra::Menue.find_by_id(current_menue.path_ids[offset])
          else
            return ""
          end
        elsif submenue_of_article.present? && submenue_of_article.public_url.present?
          master_menue = Goldencobra::Menue.active.where(:target => submenue_of_article.public_url).select{|a| a.path.map(&:title).join("/").include?(menue_id)}.first
        else
          master_menue = Goldencobra::Menue.active.find_by_pathname(menue_id)
        end
      else
        master_menue = Goldencobra::Menue.active.find_by_id(menue_id)
      end

      return "" if master_menue.blank?

      current_depth = master_menue.ancestry_depth
      #Check for Permission
      if params[:frontend_tags] && params[:frontend_tags].class != String && params[:frontend_tags][:format] && params[:frontend_tags][:format] == "email"
        #Wenn format email, dann gibt es keinen realen webseit besucher
        ability = Ability.new()
      else
        operator = current_user || current_visitor
        ability = Ability.new(operator)
      end
      if !ability.can?(:read, master_menue)
        return ""
      end
      if master_menue.present?
        content = ""
        subtree_menues = master_menue.subtree.after_depth(current_depth + offset).to_depth(current_depth + depth).active.includes(:permissions).includes(:image)
        subtree_menues = subtree_menues.to_a.delete_if{|a| !ability.can?(:read, a)}

        current_depth = 1
        menue_roots(subtree_menues).each do |root|
          content << navigation_menu_helper(root, options, subtree_menues, current_depth)
        end

        if id_name.present?
          result = content_tag(:ul, raw(content),:id => "#{id_name}", :class => "#{class_name} #{depth} navigation #{master_menue.css_class.to_s.gsub(/\W/,' ')}".squeeze(' ').strip)
        else
          result = content_tag(:ul, raw(content), :class => "#{class_name} #{depth} navigation #{master_menue.css_class.to_s.gsub(/\W/,' ')}".squeeze(' ').strip)
        end
      end
      return raw(result)
    end

    private

    def menue_roots(menue_array)
      min_of_layers = menue_array.map{|a| a.ancestry.split("/").count }.min
      return menue_array.select{|a| a.ancestry.to_s.split("/").count == min_of_layers }
    end

    def menue_children(menue_element, menue_array)
      return menue_array.select{|a| a.ancestry.to_s.split("/").last.to_i == menue_element.id }
    end

    def navigation_menu_helper(child, options, subtree_menues, current_depth)
      if @current_client && @current_client.url_prefix.present?
        child_target_link = @current_client.url_prefix + child.target.gsub("\"",'')
      else
        child_target_link = child.target.gsub("\"",'')
      end
      child_link = content_tag(:a, child.title, :href => child_target_link)
      image_link = child.image.present? ? image_tag(child.image.image(:original)) : ""
      child_link = child_link + content_tag(:a, image_link, :href => child_target_link, :class => "navigtion_link_imgage_wrapper") unless options[:show_image] == false
      child_link = child_link + content_tag(:a, child.description_title, :href => child_target_link, :class => "navigtion_link_description_title") unless options[:show_description_title] == false
      template = Liquid::Template.parse(child.description)
      child_link = child_link + content_tag("div", raw(template.render(Goldencobra::Article::LiquidParser)), :class => "navigtion_link_description") unless options[:show_description] == false
      child_link = child_link + content_tag(:a, child.call_to_action_name, :href => child_target_link, :class => "navigtion_link_call_to_action_name") unless options[:show_call_to_action_name] == false

      current_depth += 1

      child_elements = menue_children(child, subtree_menues)
      visible_child_element_count = 0
      if child_elements.count > 0
        content_level = ""
        child_elements.each do |subchild|
          if !subchild.css_class.include?("hidden") && !subchild.css_class.include?("not_visible")
            visible_child_element_count += 1
          end
          content_level << navigation_menu_helper(subchild, options, subtree_menues, current_depth)
        end
        if content_level.present?
          child_link = child_link + content_tag(:ul, raw(content_level), :class => "level_#{current_depth} children_#{visible_child_element_count}" )
        end
      end
      return content_tag(:li, raw(child_link),"data-id" => child.id , :class => "#{ visible_child_element_count > 0 ? 'has_children' : ''}  #{child.has_active_child?(request) ? 'has_active_child' : ''}    #{child.is_active?(request) ? 'active' : ''}    #{child.css_class.gsub(/\W/,' ')}".squeeze(' ').strip)
    end

  end
end