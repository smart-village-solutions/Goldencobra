module Goldencobra
  module ArticlesHelper
    
    def navigation_menu(menue_id, options={})
      return "id can't be blank" if menue_id.blank?
      #0 = unlimited, 1 = self, 2 = self and children 1. grades, 3 = self and up to children 2.grades
      depth = options[:depth] || 0
      class_name = options[:class] || ""
      id_name = options[:id] || ""
      master_menue = Goldencobra::Menue.find_by_id(menue_id)

      if master_menue
        content = ""
        master_menue.children.collect do |child|
          content << navigation_menu_helper(child, depth, 1)
        end
        result = content_tag(:ul, raw(content),:id => "#{id_name}" :class => "#{class_name} #{depth} navigation #{master_menue.css_class.gsub(/\W/,' ')}".squeeze(' ').strip)
      end
      
      return raw(result)
    end
    
    
    
    private
    def navigation_menu_helper(child, depth, current_depth)
      child_link = content_tag(:a, child.title, :href => child.target.gsub("\"",''))
      current_depth = current_depth + 1
      if child.children && (depth == 0 || current_depth <= depth)
        content_level = ""
        child.children.each do |subchild|
            content_level << navigation_menu_helper(subchild, depth, current_depth)
        end
        child_link = child_link + content_tag(:ul, raw(content_level), :class => "level_#{current_depth}" )
      end  
      return content_tag(:li, raw(child_link), :class => "#{child.has_active_child?(request) ? 'has_active_child' : ''} #{child.is_active?(request) ? 'active' : ''} #{child.css_class.gsub(/\W/,' ')}".squeeze(' ').strip)
    end
    
  end
end
