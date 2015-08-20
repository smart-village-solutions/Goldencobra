# encoding: utf-8

module Goldencobra
  class Articletype < ActiveRecord::Base
    attr_accessible :default_template_file, :name, :fieldgroups_attributes

    has_many :articles, class_name: Goldencobra::Article, foreign_key: :article_type, primary_key: :name
    has_many :fieldgroups, class_name: Goldencobra::ArticletypeGroup, dependent: :destroy

    accepts_nested_attributes_for :fieldgroups, allow_destroy: true

    validates_uniqueness_of :name

    after_destroy :set_defaults

    ArticleFieldOptions = {
      global_sorting_id: %{<% f.input :global_sorting_id, hint: I18n.t("goldencobra.article_field_hints.global_sorting_id") %>},
      title: '<% f.input :title, hint: I18n.t("goldencobra.article_field_hints.title") %>',
      subtitle: %{<% f.input :subtitle %>},
      content: %{<% f.input :content, input_html: { class: "tinymce" } %>},
      teaser: %{<% f.input :teaser, hint: I18n.t("goldencobra.article_field_hints.teaser"), input_html: { rows: 5 } %>},
      summary: %{<% f.input :summary, hint: I18n.t("goldencobra.article_field_hints.summary"), input_html: { rows: 5 } %>},
      tag_list: %{<% f.input :tag_list, hint: I18n.t("goldencobra.article_field_hints.tag_list"), wrapper_html: { class: '' } %>},
      frontend_tag_list: %{<% f.input :frontend_tag_list, hint: I18n.t("goldencobra.article_field_hints.frontend_tag_list"), wrapper_html: { class: '' } %>},
      active: %{<% f.input :active, hint: I18n.t("goldencobra.article_field_hints.active"), wrapper_html: { class: '' } %>},
      active_since: %{<% f.input :active_since, hint: I18n.t("goldencobra.article_field_hints.active_since"), as: :string, input_html: { class: "", size: "20" }, wrapper_html: { class: 'expert' } %>},
      context_info: %{<% f.input :context_info, input_html: { class: "tinymce" }, hint: I18n.t("goldencobra.article_field_hints.context_info") %>},
      metatags: %{<% warn("Deprecated method commentable") %>},
      metatag_title_tag: %{<% f.input :metatag_title_tag %>},
      metatag_meta_description: %{<% f.input :metatag_meta_description %>},
      metatag_open_graph_title: %{<% f.input :metatag_open_graph_title %>},
      metatag_open_graph_description: %{<% f.input :metatag_open_graph_description %>},
      metatag_open_graph_type: %{<% f.input :metatag_open_graph_type %>},
      metatag_open_graph_url: %{<% f.input :metatag_open_graph_url %>},
      metatag_open_graph_image: %{<% f.input :metatag_open_graph_image %>},
      breadcrumb: %{<% f.input :breadcrumb, hint: I18n.t("goldencobra.article_field_hints.breadcrumb") %>},
      url_name: %{<% f.input :url_name, hint: I18n.t("goldencobra.article_field_hints.url_name"), required: false %>},
      parent_id: %{<% f.input :parent_id, hint: I18n.t("goldencobra.article_field_hints.parent_id"), as: :select, collection: Goldencobra::Article.where("id = ?", f.object.parent_id).select([:id,:title, :ancestry]).map{|c| [c.parent_path, c.id]}.sort{|a,b| a[0] <=> b[0]}, input_html: { class: 'get_goldencobra_articles_per_remote', style: 'width: 80%;', 'dataplaceholder': 'Elternelement auswählen' } %>},
      canonical_url: %{<% f.input :canonical_url, hint: I18n.t("goldencobra.article_field_hints.canonical_url") %>},
      enable_social_sharing: %{<% warn("Deprecated method enable_social_sharing") %>},
      robots_no_index: %{<% f.input :robots_no_index, hint: I18n.t("goldencobra.article_field_hints.robots_no_index") %>},
      cacheable: %{<% f.input :cacheable, as: :boolean, hint: I18n.t("goldencobra.article_field_hints.cacheable") %>},
      commentable: %{<% warn("Deprecated method commentable") %>},
      dynamic_redirection: %{<% f.input :dynamic_redirection, as: :select, collection: Goldencobra::Article::DynamicRedirectOptions.map{|a| [a[1], a[0]]}, include_blank: false %>},
      external_url_redirect: %{<% f.input :external_url_redirect %>},
      redirect_link_title: %{<% f.input :redirect_link_title %>},
      redirection_target_in_new_window: %{<% f.input :redirection_target_in_new_window %>},
      author: %{<% warn("Deprecated Model Author") %>},
      permissions: %{<% f.has_many :permissions do |p|
        p.input :domain, include_blank: "Alle"
        p.input :role, include_blank: "Alle"
        p.input :action, as: :select, collection: Goldencobra::Permission::PossibleActions, include_blank: false
        p.input :_destroy, as: :boolean
      end %>},
      article_images: %{<% f.has_many :article_images do |ai|
        ai.input :image, as: :select, collection: Goldencobra::Upload.where(id: ai.object.image_id).map{|c| [c.complete_list_name, c.id]}, input_html: { class: 'article_image_file chosen-select get_goldencobra_uploads_per_remote', style: 'width: 80%;', 'dataplaceholder': 'Bitte warten' }, label: "Medium wählen", include_blank: false
        ai.input :position, as: :select, collection: Goldencobra::Setting.for_key("goldencobra.article.image_positions").to_s.split(",").map(&:strip), include_blank: false
        ai.input :_destroy, as: :boolean
      end %>},
      index__article_for_index_id: %{<% f.input :article_for_index_id, label: I18n.t('active_admin.articles.index.views.label1'), hint: I18n.t('active_admin.articles.index.views.hint1'), as: :select, collection: Goldencobra::Article.articles_for_index_selecetion, include_blank: "/", id: "article_event_articleindex_id", input_html: { class: 'chosen-select', style: 'width: 80%;' } %>},
      index__article_descendents_depth: %{<% f.input :index_of_articles_descendents_depth, as: :select, collection: [["Alle", "all"],["1 Ebene", "1"],["2 Ebenen", "2"],["3 Ebenen", "3"]], include_blank: false, label: I18n.t('active_admin.articles.index.views.label4'), hint: I18n.t('active_admin.articles.index.views.hint4') %>},
      index__display_index_types: %{<% f.input :display_index_types, label: I18n.t('active_admin.articles.index.views.label2'), hint: I18n.t('active_admin.articles.index.views.hint2'), as: :select, collection: Goldencobra::Article::DisplayIndexTypes, include_blank: false %>},
      index__display_index_articletypes: %{<% f.input :display_index_articletypes, label: I18n.t('active_admin.articles.index.views.label3'), hint: I18n.t('active_admin.articles.index.views.hint3'), as: :select, collection: ["all"] + Goldencobra::Article.article_types_for_search, include_blank: false %>},
      index__index_of_articles_tagged_with: %{<% f.input :index_of_articles_tagged_with, label: "Artikel mit folgenden Tags", hint: "Auf der Übersichtsseite werden alle Artikel des gleichen Artikeltyps mit diesen Tags ausgegeben. Sind keine Tags angegeben, werden alle Artikel des gleichen Artikeltyps ausgegeben."%>},
      index__not_tagged_with: %{<% f.input :not_tagged_with, label: "Artikel ohne folgende Tags", hint: "Artikel mit diesen Tags nicht anzeigen!" %>},
      index__sorter_limit: %{<% f.input :sorter_limit, label: "Anzahl anzuzeigender Artikel", hint: "Wieviel Artikel sollen maximal auf der Übersichtsseite erscheinen?" %>},
      index__sort_order: %{<% f.input :sort_order, hint: "Created_at - Reihenfolge nach Erstellungsdatum | Updated_at - Reihenfolge nach Aktualisierungsdatum | Random - Reihenfolge zufällig | Alphabetically - Reihenfolge alphabetisch | GlobalSortID - Reihenfolge nach globaler Sortiernummer im Einzelartikel", as: :select, collection: Goldencobra::Article::SortOptions, include_blank: false %>},
      index__reverse_sort: %{<% f.input :reverse_sort, hint: "Soll absteigend sortiert werden? Standard: aufsteigend" %>}
    }

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
            if !at.try(:fieldgroups).any?
              a1 = at.fieldgroups.create(title: "Allgemein", position: "first_block", foldable: true, closed: false, expert: false, sorter: 1)
              a1.fields.create(fieldname: "active", sorter: 1)
              a1.fields.create(fieldname: "subtitle", sorter: 10)
              a1.fields.create(fieldname: "title", sorter: 20)
              a1.fields.create(fieldname: "teaser", sorter: 30)
              a1.fields.create(fieldname: "content", sorter: 40)
              a1.fields.create(fieldname: "tag_list", sorter: 50)
              
              if at.name.include?(" Index")
                a1_1 = at.fieldgroups.create(title: "Index", position: "first_block", foldable: true, closed: false, expert: false, sorter: 2)
                a1_1.fields.create(fieldname: "index__article_for_index_id", sorter: 1)
                a1_1.fields.create(fieldname: "index__article_descendents_depth", sorter: 2)
                a1_1.fields.create(fieldname: "index__display_index_types", sorter: 3)
                a1_1.fields.create(fieldname: "index__display_index_articletypes", sorter: 4)
                a1_1.fields.create(fieldname: "index__index_of_articles_tagged_with", sorter: 5)
                a1_1.fields.create(fieldname: "index__not_tagged_with", sorter: 6)
                a1_1.fields.create(fieldname: "index__sorter_limit", sorter: 7)
                a1_1.fields.create(fieldname: "index__sort_order", sorter: 8)
                a1_1.fields.create(fieldname: "index__reverse_sort", sorter: 9)
              end

              a2 = at.fieldgroups.create(title: "Medien", position: "last_block", foldable: true, closed: true, expert: false, sorter: 2)
              a2.fields.create(fieldname: "article_images", sorter: 5)

              a3 = at.fieldgroups.create(title: "Metadescriptions", position: "last_block", foldable: true, closed: true, expert: true, sorter: 3)
              a3.fields.create(fieldname: "breadcrumb", sorter: 1)
              a3.fields.create(fieldname: "metatag_title_tag", sorter: 10)
              a3.fields.create(fieldname: "metatag_meta_description", sorter: 20)
              a3.fields.create(fieldname: "metatag_open_graph_title", sorter: 30)
              a3.fields.create(fieldname: "metatag_open_graph_description", sorter: 40)
              a3.fields.create(fieldname: "robots_no_index", sorter: 80) 

              a4 = at.fieldgroups.create(title: "Einstellungen", position: "last_block", foldable: true, closed: true, expert: true, sorter: 4)
              a4.fields.create(fieldname: "frontend_tag_list", sorter: 10)
              a4.fields.create(fieldname: "url_name", sorter: 20)
              a4.fields.create(fieldname: "parent_id", sorter: 30)
              a4.fields.create(fieldname: "active_since", sorter: 50)
              a4.fields.create(fieldname: "cacheable", sorter: 70)
              a4.fields.create(fieldname: "dynamic_redirection", sorter: 100)
              a4.fields.create(fieldname: "external_url_redirect", sorter: 110)
              a4.fields.create(fieldname: "redirect_link_title", sorter: 120)
              a4.fields.create(fieldname: "redirection_target_in_new_window", sorter: 130)

              puts "Default Fieldoptions recreated for #{at.try(:name)}"
            end
          end
        end
      end
    end
  end
end
