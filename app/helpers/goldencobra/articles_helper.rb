module Goldencobra
  module ArticlesHelper


    def render_article_content_parts(article)
      render :partial => "/goldencobra/articles/show", :locals => {:article => article}
    end

    def render_article_image_gallery
      if @article
        result = ""
        uploads = Goldencobra::Upload.tagged_with(@article.image_gallery_tags.present? ? @article.image_gallery_tags.split(",") : "" )
        if uploads && uploads.count > 0
          uploads.each do |upload|
            result << content_tag("li", link_to(image_tag(upload.image.url(:thumb)), upload.image.url(:large)))
          end
        end
        return content_tag("ul", raw(result), :class => "goldencobra_article_image_gallery")
      end
    end

    def navigation_menu(menue_id, options={})
      return "id can't be blank" if menue_id.blank?
      #0 = unlimited, 1 = self, 2 = self and children 1. grades, 3 = self and up to children 2.grades
      depth = options[:depth] || 0
      class_name = options[:class] || ""
      id_name = options[:id] || ""
      if menue_id.class == String
        master_menue = Goldencobra::Menue.active.find_by_title(menue_id)
      else
        master_menue = Goldencobra::Menue.active.find_by_id(menue_id)
      end

      if master_menue
        content = ""
        master_menue.children.active.includes(:image).collect do |child|
          content << navigation_menu_helper(child, depth, 1, options)
        end
        if id_name.present?
          result = content_tag(:ul, raw(content),:id => "#{id_name}", :class => "#{class_name} #{depth} navigation #{master_menue.css_class.to_s.gsub(/\W/,' ')}".squeeze(' ').strip)
        else
          result = content_tag(:ul, raw(content), :class => "#{class_name} #{depth} navigation #{master_menue.css_class.to_s.gsub(/\W/,' ')}".squeeze(' ').strip)
        end
      end

      return raw(result)
    end


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

    def index_of_articles(options={})
      if @article && @article.article_for_index_id.present? && master_index_article = Goldencobra::Article.find_by_id(@article.article_for_index_id)
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

    def render_article_type_content(options={})
      if @article && @article.article_type.present? && @article.kind_of_article_type.present?
        render :partial => "articletypes/#{@article.article_type_form_file.downcase}/#{@article.kind_of_article_type.downcase}"
      else
        render :partial => "articletypes/default/show"
      end
    end

    def render_article_widgets(options={})
      custom_css = options[:class] || ""
      taggs = options[:tagged_with] || ""
      default = options[:default] || "false"
      widget_wrapper = options[:wrapper] || "section"
      result = ""
      if @article
        widgets = @article.widgets.active
        if taggs.present? && default == "false"
          widgets = widgets.tagged_with(taggs.split(","))
        elsif default == true && taggs.present?
          widgets = Goldencobra::Widget.where(:default => true).tagged_with(taggs.split(","))
        else
          widgets = widgets.where(:tag_list => "")
        end

        widgets.each do |widget|
          template = Liquid::Template.parse(widget.content)
          if widget.id_name.present?
            result << content_tag(widget_wrapper, raw(template.render(Goldencobra::Article::LiquidParser)) , :class => "#{widget.css_name} #{custom_css}", :id => widget.id_name)
          else
            result << content_tag(widget_wrapper, raw(template.render(Goldencobra::Article::LiquidParser)) , :class => "#{widget.css_name} #{custom_css}")
          end
        end
      end
      return raw(result)
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
      return content_tag(:li, raw(child_link), :class => "#{child.has_active_child?(request) ? 'has_active_child' : ''} #{child.is_active?(request) ? 'active' : ''} #{child.css_class.gsub(/\W/,' ')}".squeeze(' ').strip)
    end

  end
end
