# encoding: utf-8

module Goldencobra
  class Articletype < ActiveRecord::Base
    attr_accessible :default_template_file, :name, :fieldgroups_attributes

    has_many :articles, class_name: Goldencobra::Article, foreign_key: :article_type, primary_key: :name
    has_many :fieldgroups, class_name: Goldencobra::ArticletypeGroup, dependent: :destroy

    accepts_nested_attributes_for :fieldgroups, allow_destroy: true

    validates_uniqueness_of :name

    after_destroy :set_defaults

    ArticleFieldOptions = [:global_sorting_id, :title, :subtitle, :content,
                           :teaser, :summary, :tag_list, :frontend_tag_list, :active,
                           :active_since, :context_info, :metatags, :metatag_title_tag,
                           :metatag_meta_description, :metatag_open_graph_title,
                           :metatag_open_graph_description, :metatag_open_graph_type,
                           :metatag_open_graph_url, :metatag_open_graph_image, :breadcrumb,
                           :url_name, :parent_id, :canonical_url, :enable_social_sharing,
                           :robots_no_index, :cacheable, :commentable, :dynamic_redirection,
                           :external_url_redirect, :redirect_link_title, :redirection_target_in_new_window,
                           :author, :permissions, :widgets, :article_images, :index__article_for_index_id,
                           :index__article_descendents_depth, :index__display_index_types,
                           :index__display_index_articletypes, :index__index_of_articles_tagged_with,
                           :index__not_tagged_with, :index__sorter_limit, :index__sort_order, :index__reverse_sort
                           ]

    def set_defaults
      Goldencobra::Articletype.reset_to_default
    end

    def self.reset_to_default
      if ActiveRecord::Base.connection.table_exists?("goldencobra_articles") && ActiveRecord::Base.connection.table_exists?("goldencobra_articletypes")
        Goldencobra::Article.article_types_for_select.each do |at|
          if Goldencobra::Articletype.find_by_name(at).blank?
            Goldencobra::Articletype.create(name: at, default_template_file: "application")
            puts "Default Articletype created for #{at}"
          end
        end

        if ActiveRecord::Base.connection.table_exists?("goldencobra_articletype_groups")
          Goldencobra::Articletype.all.each do |at|
            # Install basic set of fieldgroups and fields if none are set up
            reset_field_blocks_for(at)
          end
        end
      end
    end

    private


    def self.reset_field_blocks_for(articletype)
      if articletype.try(:fieldgroups).blank?
        reset_common_block(articletype)
        reset_index_block(articletype)
        reset_media_block(articletype)
        reset_meta_block(articletype)
        reset_widget_block(articletype)
        reset_settings_block(articletype)
      end
    end


    def self.reset_common_block(at)
      new_a = at.fieldgroups.create(title: "Allgemein", position: "first_block", foldable: true, closed: false, expert: false, sorter: 1)
      common_elements = ["active", "subtitle", "title", "teaser", "content", "tag_list"]
      common_elements.each_with_index do |name, index|
        new_a.fields.create(fieldname: name, sorter: index * 10)
      end
    end

    def self.reset_index_block(at)
      if at.name.include?(" Index")
        new_a = at.fieldgroups.create(title: "Index", position: "first_block", foldable: true, closed: false, expert: false, sorter: 2)
        index_elements = ["index__article_for_index_id", "index__article_descendents_depth", "index__display_index_types",
                          "index__display_index_articletypes", "index__index_of_articles_tagged_with", "index__not_tagged_with",
                          "index__sorter_limit","index__sort_order","index__reverse_sort"]
        index_elements.each_with_index do |name, index|
          new_a.fields.create(fieldname: name, sorter: index * 10)
        end
      end
    end

    def self.reset_media_block(at)
      new_a = at.fieldgroups.create(title: "Medien", position: "last_block", foldable: true, closed: true, expert: false, sorter: 2)
      new_a.fields.create(fieldname: "article_images", sorter: 5)
    end


    def self.reset_meta_block(at)
      new_a = at.fieldgroups.create(title: "Metadescriptions", position: "last_block", foldable: true, closed: true, expert: false, sorter: 3)
      metas = ["breadcrumb", "metatag_title_tag", "metatag_meta_description", "metatag_open_graph_title", "metatag_open_graph_description", "robots_no_index"]
      metas.each_with_index do |name, index|
        new_a.fields.create(fieldname: name, sorter: index * 10)
      end
    end


    def self.reset_widget_block(at)
      new_a = at.fieldgroups.create(title: "Widgets", position: "last_block", foldable: true, closed: true, expert: false, sorter: 4)
      new_a.fields.create(fieldname: "widgets", sorter: 1)
    end

    def self.reset_settings_block(at)
      new_a = at.fieldgroups.create(title: "Einstellungen", position: "last_block", foldable: true, closed: true, expert: false, sorter: 5)
      setting_elements = ["frontend_tag_list", "url_name", "parent_id", "active_since", "cacheable", "dynamic_redirection",
                          "external_url_redirect", "redirect_link_title", "redirection_target_in_new_window"]
      setting_elements.each_with_index do |name, index|
        new_a.fields.create(fieldname: name, sorter: index * 10)
      end
    end

  end
end
