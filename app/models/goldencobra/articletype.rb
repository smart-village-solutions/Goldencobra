# encoding: utf-8

module Goldencobra
  class Articletype < ActiveRecord::Base
    attr_accessible :default_template_file, :name, :fieldgroups_attributes
    has_many :articles, :class_name => Goldencobra::Article, :foreign_key => :article_type, :primary_key => :name
    validates_uniqueness_of :name

    has_many :fieldgroups, :class_name => Goldencobra::ArticletypeGroup, :dependent => :destroy
    accepts_nested_attributes_for :fieldgroups, :allow_destroy => true

    ArticleFieldOptions = {
        :title => %{<% f.input :title, :hint => I18n.t("goldencobra.article_field_hints.title") %>},
        :subtitle => %{<% f.input :subtitle %>},
        :content => %{<% f.input :content, :input_html => { :class => "tinymce" } %>},
        :teaser => %{<% f.input :teaser, :hint => I18n.t("goldencobra.article_field_hints.teaser"), :input_html => { :rows => 5 } %>},
        :summary => %{<% f.input :summary, :hint => I18n.t("goldencobra.article_field_hints.summary"), :input_html => { :rows => 5 } %>},
        :tag_list => %{<% f.input :tag_list, :hint => I18n.t("goldencobra.article_field_hints.tag_list"), :wrapper_html => { class: 'expert' } %>},
        :frontend_tag_list => %{<% f.input :frontend_tag_list, hint: I18n.t("goldencobra.article_field_hints.frontend_tag_list"), :wrapper_html => { class: 'expert' } %>},
        :active => %{<% f.input :active, :hint => I18n.t("goldencobra.article_field_hints.active"), :wrapper_html => { class: 'expert' } %>},
        :active_since => %{<% f.input :active_since, :hint => I18n.t("goldencobra.article_field_hints.active_since"), as: :string, :input_html => { class: "", :size => "20" }, :wrapper_html => { class: 'expert' } %>},
        :context_info => %{<% f.input :context_info, :input_html => { :class => "tinymce" }, :hint => I18n.t("goldencobra.article_field_hints.context_info") %>},
        :metatags => %{<% f.has_many :metatags do |m|
          m.input :name, :as => :select, :collection => Goldencobra::Article::MetatagNames, :input_html => { :class => 'metatag_names'}, :hint => I18n.t("goldencobra.article_field_hints.metatags_name")
          m.input :value, :input_html => { :class => 'metatag_values'}
          m.input :_destroy, :label => "entfernen/zurücksetzen", :hint => I18n.t("goldencobra.article_field_hints.metatags_destroy"), :as => :boolean
        end %>},
        :breadcrumb => %{<% f.input :breadcrumb, :hint => I18n.t("goldencobra.article_field_hints.breadcrumb") %>},
        :url_name => %{<% f.input :url_name, :hint => I18n.t("goldencobra.article_field_hints.url_name"), required: false %>},
        :parent_id => %{<% f.input :parent_id, :hint => I18n.t("goldencobra.article_field_hints.parent_id"), :as => :select, :collection => Goldencobra::Article.all.map{|c| [c.parent_path, c.id]}.sort{|a,b| a[0] <=> b[0]}, :include_blank => true, :input_html => { :class => 'chzn-select-deselect', :style => 'width: 70%;', 'data-placeholder' => 'Elternelement auswählen' } %>},
        :canonical_url => %{<% f.input :canonical_url, :hint => I18n.t("goldencobra.article_field_hints.canonical_url") %>},
        :enable_social_sharing => %{<% f.input :enable_social_sharing, :hint => I18n.t("goldencobra.article_field_hints.enable_social_sharing") %>},
        :robots_no_index => %{<% f.input :robots_no_index, :hint => I18n.t("goldencobra.article_field_hints.robots_no_index") %>},
        :cacheable => %{<% f.input :cacheable, :as => :boolean, :hint => I18n.t("goldencobra.article_field_hints.cacheable") %>},
        :commentable => %{<% f.input :commentable, :as => :boolean, :hint => I18n.t("goldencobra.article_field_hints.commentable") %>},
        :dynamic_redirection => %{<% f.input :dynamic_redirection, :as => :select, :collection => Goldencobra::Article::DynamicRedirectOptions.map{|a| [a[1], a[0]]}, :include_blank => false %>},
        :external_url_redirect => %{<% f.input :external_url_redirect %>},
        :redirect_link_title => %{<% f.input :redirect_link_title %>},
        :redirection_target_in_new_window => %{<% f.input :redirection_target_in_new_window %>},
        :author => %{<% f.input :author, :hint => I18n.t("goldencobra.article_field_hints.author") %>},
        :permissions => %{<% f.has_many :permissions do |p|
          p.input :role, :include_blank => "Alle"
          p.input :action, :as => :select, :collection => Goldencobra::Permission::PossibleActions, :include_blank => false
          p.input :_destroy, :as => :boolean
        end %>},
        :article_images => %{<% f.has_many :article_images do |ai|
          ai.input :image, :as => :select, :collection => Goldencobra::Upload.order("updated_at DESC").map{|c| [c.complete_list_name, c.id]}, :input_html => { :class => 'article_image_file chzn-select', :style => 'width: 70%;', 'data-placeholder' => 'Medium auswählen' }, :label => "Medium wählen"
          ai.input :position, :as => :select, :collection => Goldencobra::Setting.for_key("goldencobra.article.image_positions").split(",").map(&:strip), :include_blank => false
          ai.input :_destroy, :as => :boolean
        end %>}
    }

  end
end
