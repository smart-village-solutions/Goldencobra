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
    #TODO: offset implementieren
    def navigation_menu(menue_id, options={})
      return "id can't be blank" if menue_id.blank?
      depth = options[:depth] || 0
      offset = options[:offset] || 0
      class_name = options[:class] || ""
      id_name = options[:id] || ""
      if menue_id.class == String
        master_menue = Goldencobra::Menue.active.find_by_pathname(menue_id)
      else
        master_menue = Goldencobra::Menue.active.find_by_id(menue_id)
      end
      #Check for Permission
      if params[:frontend_tags] && params[:frontend_tags][:format] && params[:frontend_tags][:format] == "email"
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
        master_menue.children.active.includes(:image).collect do |child|
          #check if Menuitem is readable by permissions
          if ability.can?(:read, child)
            content << navigation_menu_helper(child, depth, 1, options)
          end
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

    def navigation_menu_helper(child, depth, current_depth, options)
      child_link = content_tag(:a, child.title, :href => child.target.gsub("\"",''))
      image_link = child.image.present? ? image_tag(child.image.image(:original)) : ""
      child_link = child_link + content_tag(:a, image_link, :href => child.target.gsub("\"",''), :class => "navigtion_link_imgage_wrapper") unless options[:show_image] == false
      child_link = child_link + content_tag(:a, child.description_title, :href => child.target.gsub("\"",''), :class => "navigtion_link_description_title") unless options[:show_description_title] == false
      template = Liquid::Template.parse(child.description)
      child_link = child_link + content_tag("div", raw(template.render(Goldencobra::Article::LiquidParser)), :class => "navigtion_link_description") unless options[:show_description] == false
      child_link = child_link + content_tag(:a, child.call_to_action_name, :href => child.target.gsub("\"",''), :class => "navigtion_link_call_to_action_name") unless options[:show_call_to_action_name] == false
      current_depth = current_depth + 1
      if child.children && (depth == 0 || current_depth <= depth)
        content_level = ""
        child.children.active.each do |subchild|
            content_level << navigation_menu_helper(subchild, depth, current_depth, options)
        end
        if content_level.present?
          child_link = child_link + content_tag(:ul, raw(content_level), :class => "level_#{current_depth} children_#{child.children.active.visible.count}" )
        end
      end
      return content_tag(:li, raw(child_link),"data-id" => child.id , :class => "#{ child.children.active.visible.count > 0 ? 'has_children' : ''} #{child.has_active_child?(request) ? 'has_active_child' : ''} #{child.is_active?(request) ? 'active' : ''} #{child.css_class.gsub(/\W/,' ')}".squeeze(' ').strip)
    end

  end
end