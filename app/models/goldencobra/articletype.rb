# encoding: utf-8

module Goldencobra
  class Articletype < ActiveRecord::Base
    attr_accessible :default_template_file, :name, :fieldgroups_attributes

    has_many :articles, class_name: Goldencobra::Article, foreign_key: :article_type, primary_key: :name
    has_many :fieldgroups, class_name: Goldencobra::ArticletypeGroup, dependent: :destroy

    accepts_nested_attributes_for :fieldgroups, allow_destroy: true

    validates_uniqueness_of :name

    after_destroy :set_defaults


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
            # install basic set of fieldgroups and fields if no one is set up
            reset_field_blocks_for(at)
          end
        end
      end
    end

    private


    def self.reset_field_blocks_for(articletype)
      if !articletype.try(:fieldgroups).any?
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
      new_a.fields.create(fieldname: "active", sorter: 1)
      new_a.fields.create(fieldname: "subtitle", sorter: 10)
      new_a.fields.create(fieldname: "title", sorter: 20)
      new_a.fields.create(fieldname: "teaser", sorter: 30)
      new_a.fields.create(fieldname: "content", sorter: 40)
      new_a.fields.create(fieldname: "tag_list", sorter: 50)
    end

    def self.reset_index_block(at)
      if at.name.include?(" Index")
        new_a = at.fieldgroups.create(title: "Index", position: "first_block", foldable: true, closed: false, expert: false, sorter: 2)
        new_a.fields.create(fieldname: "index__article_for_index_id", sorter: 1)
        new_a.fields.create(fieldname: "index__article_descendents_depth", sorter: 2)
        new_a.fields.create(fieldname: "index__display_index_types", sorter: 3)
        new_a.fields.create(fieldname: "index__display_index_articletypes", sorter: 4)
        new_a.fields.create(fieldname: "index__index_of_articles_tagged_with", sorter: 5)
        new_a.fields.create(fieldname: "index__not_tagged_with", sorter: 6)
        new_a.fields.create(fieldname: "index__sorter_limit", sorter: 7)
        new_a.fields.create(fieldname: "index__sort_order", sorter: 8)
        new_a.fields.create(fieldname: "index__reverse_sort", sorter: 9)
      end
    end

    def self.reset_media_block(at)
      new_a = at.fieldgroups.create(title: "Medien", position: "last_block", foldable: true, closed: true, expert: false, sorter: 2)
      new_a.fields.create(fieldname: "article_images", sorter: 5)
    end


    def self.reset_meta_block(at)
      new_a = at.fieldgroups.create(title: "Metadescriptions", position: "last_block", foldable: true, closed: true, expert: false, sorter: 3)
      new_a.fields.create(fieldname: "breadcrumb", sorter: 1)
      new_a.fields.create(fieldname: "metatag_title_tag", sorter: 10)
      new_a.fields.create(fieldname: "metatag_meta_description", sorter: 20)
      new_a.fields.create(fieldname: "metatag_open_graph_title", sorter: 30)
      new_a.fields.create(fieldname: "metatag_open_graph_description", sorter: 40)
      new_a.fields.create(fieldname: "robots_no_index", sorter: 80)
    end


    def self.reset_widget_block(at)
      new_a = at.fieldgroups.create(title: "Widgets", position: "last_block", foldable: true, closed: true, expert: false, sorter: 4)
      new_a.fields.create(fieldname: "widgets", sorter: 1)
    end

    def self.reset_settings_block(at)
      new_a = at.fieldgroups.create(title: "Einstellungen", position: "last_block", foldable: true, closed: true, expert: false, sorter: 5)
      new_a.fields.create(fieldname: "frontend_tag_list", sorter: 10)
      new_a.fields.create(fieldname: "url_name", sorter: 20)
      new_a.fields.create(fieldname: "parent_id", sorter: 30)
      new_a.fields.create(fieldname: "active_since", sorter: 50)
      new_a.fields.create(fieldname: "cacheable", sorter: 70)
      new_a.fields.create(fieldname: "dynamic_redirection", sorter: 100)
      new_a.fields.create(fieldname: "external_url_redirect", sorter: 110)
      new_a.fields.create(fieldname: "redirect_link_title", sorter: 120)
      new_a.fields.create(fieldname: "redirection_target_in_new_window", sorter: 130)
    end

  end
end
