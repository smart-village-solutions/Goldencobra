# encoding: utf-8

module Goldencobra
  module ArticlesHelper

    # 'Read on' link to article for index-pages
    # If external_url_redirect is set and a link_title is given,
    # display this link title. Otherwise display a generic link title.
    def read_on(article, options={})
      target_window = article.redirection_target_in_new_window ? "_blank" : "_top"
      html_class = "more #{options[:class]}".strip
      if article.redirect_link_title.present?
        link_to article.redirect_link_title, article.external_url_redirect, class: html_class, target: target_window
      else
        link_to t(:read_on, scope: [:articles]), article.public_url, class: html_class, target: target_window, title: article.title
      end
    end

    #Ausgabe aller Hauptbestandteile eines Artikels über "content_for :xy"
    def render_article_content_parts(article)
      render :partial => "/goldencobra/articles/show", :locals => {:article => article}
    end


    #Parse text for a single Word and make a link to an Article to this Word as a Subarticle of a given Article
    def parse_glossar_entries(content,tag_name, parent_article_id=nil)
      glossar_parent = nil
      if parent_article_id
        glossar_parent = Goldencobra::Article.find_by_id(parent_article_id)
        glossar_article = glossar_parent.children.where(:breadcrumb => tag_name).first
      else
        glossar_article = Goldencobra::Article.where(:breadcrumb => tag_name).first
      end
      unless glossar_article
        glossar_article = Goldencobra::Article.create(:title => tag_name, :breadcrumb => tag_name, :article_type => "Default Show", :parent => glossar_parent)
      end

      if glossar_article.present?
        replace_with = "<a href='#{glossar_article.public_url}' class='glossar'>#{tag_name}</a>"
        content = content.gsub(/\b(?<!\/)#{tag_name}(?!<)\b/, "#{replace_with}")
      end
    end


    # [render_article_image_gallery description]
    # @param options={} [Hash] {link_image_size: :thumb, target_image_size: :large}
    # 
    # @return [HTML] ImageGallery
    def render_article_image_gallery(options={})
      link_image_size = option.fetch(:link_image_size, :thumb)
      target_image_size = option.fetch(:target_image_size, :large)
      if @article
        result = ""
        uploads = Goldencobra::Upload.tagged_with(@article.image_gallery_tags.present? ? @article.image_gallery_tags.split(",") : "" )
        if uploads && uploads.count > 0
          uploads.order(:sorter_number).each do |upload|
            result << content_tag("li", link_to(image_tag(upload.image.url(link_image_size), {alt: upload.alt_text}), upload.image.url(target_image_size), title: raw(upload.description)))
          end
        end
        return content_tag("ul", raw(result), :class => "goldencobra_article_image_gallery")
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
      if @article
        if @article.article_type.present? && @article.kind_of_article_type.present?
         render :partial => "articletypes/#{@article.article_type_form_file.underscore.parameterize.downcase}/#{@article.kind_of_article_type.downcase}"
        else
          render :partial => "articletypes/default/show"
        end
      end
    end

    def render_article_widgets(options={})
      @timecontrol = Goldencobra::Setting.for_key("goldencobra.widgets.time_control") == "true"
      custom_css = options[:class] || ""
      tags = options[:tagged_with] || ""
      default = options[:default] || "false"
      widget_wrapper = options[:wrapper] || "section"
      result = ""
      if params[:frontend_tags] && params[:frontend_tags].class != String && params[:frontend_tags][:format] && params[:frontend_tags][:format] == "email"
        #Wenn format email, dann gibt es keinen realen webseit besucher
        ability = Ability.new()
      else
        if !defined?(current_user).nil? || !defined?(current_visitor).nil?
          operator = current_user || current_visitor
          ability = Ability.new(operator)
        else
          ability = Ability.new()
        end
      end
      if @article
        widgets = @article.widgets.active
        if tags.present? && default == "false"
          widgets = widgets.tagged_with(tags.split(","))
        elsif default == true && tags.present?
          widgets = Goldencobra::Widget.active.where(:default => true).tagged_with(tags.split(","))
        else
          widgets = widgets.where(:tag_list => "")
        end
        widgets = widgets.order(:sorter)

        widgets.each do |widget|
          #check if current user has permissions to see this widget
          if ability.can?(:read, widget)
            template = Liquid::Template.parse(widget.content)
            alt_template = Liquid::Template.parse(widget.alternative_content)
            html_data_options = {"class" => "#{widget.css_name} #{custom_css} goldencobra_widget",
                                  "id" => widget.id_name.present? ? widget.id_name : "widget_id_#{widget.id}",
                                  'data-date-start' => widget.offline_date_start_display,
                                  'data-date-end' => widget.offline_date_end_display,
                                  'data-offline-active' => widget.offline_time_active,
                                  'data-id' => widget.id
                                }
            html_data_options = html_data_options.merge(widget.offline_time_week)
            result << content_tag(widget_wrapper, raw(template.render(Goldencobra::Article::LiquidParser)), html_data_options)
            if @timecontrol
              result << content_tag(widget_wrapper, raw(alt_template.render(Goldencobra::Article::LiquidParser)),
                          class: "#{widget.css_name} #{custom_css} hidden goldencobra_widget", 'data-id' => widget.id)
            end
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

  end
end
