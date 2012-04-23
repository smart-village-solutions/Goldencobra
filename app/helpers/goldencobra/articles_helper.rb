module Goldencobra
  module ArticlesHelper
    
    
    def render_article_widgets
      if @article
        result = ""
        @article.widgets.active.each do |widget|
          template = Liquid::Template.parse(widget.content)
          result << content_tag("section", raw(template.render(Goldencobra::Article::LiquidParser)) , :class => widget.css_name, :id => widget.id_name)
        end
        return raw(result)
      end
    end
    
    def navigation_menu(menue_id, options={})
      return "id can't be blank" if menue_id.blank?
      #0 = unlimited, 1 = self, 2 = self and children 1. grades, 3 = self and up to children 2.grades
      depth = options[:depth] || 0
      class_name = options[:class] || ""
      id_name = options[:id] || ""
      master_menue = Goldencobra::Menue.active.find_by_id(menue_id)

      if master_menue
        content = ""
        master_menue.children.active.collect do |child|
          content << navigation_menu_helper(child, depth, 1)
        end
        result = content_tag(:ul, raw(content),:id => "#{id_name}", :class => "#{class_name} #{depth} navigation #{master_menue.css_class.gsub(/\W/,' ')}".squeeze(' ').strip)
      end
      
      return raw(result)
    end
    
    
    def breadcrumb(options={})
      class_name = options[:class] || ""
      if @article
        list = ""
        @article.path.each do |art|
          link_name = link_to(art.breadcrumb_name, art.public_url)
          list << content_tag(:li, raw(link_name))
        end
        content_list = content_tag(:ol, raw(list))
    		result = content_tag(:nav, raw(content_list), :id => "breadcrumb", :class => "#{class_name}")
        return raw(result)
      end
    end
    
    def index_of_articles(options={})
      if @article && @article.article_for_index_id.present? && master_index_article = Article.find_by_id(@article.article_for_index_id)
        result_list = ""
        result_list += content_tag(:h2, raw("&nbsp;"), class: "boxheader")
        result_list += content_tag(:h1, "#{master_index_article.title}", class: "headline")
        dom_element = (options[:wrapper]).present? ? options[:wrapper] : :div
        master_index_article.descendants.order(:created_at).limit(@article.article_for_index_limit).each do |art|
          if @article.article_for_index_levels.to_i == 0 || (@article.depth + @article.article_for_index_levels.to_i > art.depth)
            rendered_article_list_item = render_article_list_item(art)

            result_list += content_tag(dom_element, rendered_article_list_item, :id => "article_index_list_item_#{art.id}", :class => "article_index_list_item")
          end
        end
        return content_tag(:article, raw(result_list), :id => "article_index_list")
      end
    end
    
    private
    
    def render_article_list_item(article_item)
      result = ""
      result += content_tag(:div, link_to(article_item.title, article_item.public_url), :class=> "title")
      result += content_tag(:div, article_item.created_at.strftime("%d.%m.%Y %H:%M"), :class=>"created_at")
      if @article.article_for_index_images == true && article_item.images.count > 0
        result += content_tag(:div, image_tag(article_item.images.first.image(:thumb)), :class => "article_image")
      end
      result += content_tag(:div, raw(article_item.public_teaser), :class => "teaser")
      result += content_tag(:div, link_to(s("goldencobra.article.article_index.link_to_article"), article_item.public_url), :class=> "link_to_article")
      return raw(result)
    end
    
    def navigation_menu_helper(child, depth, current_depth)
      child_link = content_tag(:a, child.title, :href => child.target.gsub("\"",''))
      current_depth = current_depth + 1
      if child.children && (depth == 0 || current_depth <= depth)
        content_level = ""
        child.children.active.each do |subchild|
            content_level << navigation_menu_helper(subchild, depth, current_depth)
        end
        if content_level.present?
          child_link = child_link + content_tag(:ul, raw(content_level), :class => "level_#{current_depth}" )
        end
      end  
      return content_tag(:li, raw(child_link), :class => "#{child.has_active_child?(request) ? 'has_active_child' : ''} #{child.is_active?(request) ? 'active' : ''} #{child.css_class.gsub(/\W/,' ')}".squeeze(' ').strip)
    end
    
  end
end
