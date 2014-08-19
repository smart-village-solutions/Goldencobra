#encoding: utf-8
# == Schema Information
#
# Table name: goldencobra_articles
#
#  id                               :integer          not null, primary key
#  title                            :string(255)
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  url_name                         :string(255)
#  slug                             :string(255)
#  content                          :text
#  teaser                           :text
#  ancestry                         :string(255)
#  startpage                        :boolean          default(FALSE)
#  active                           :boolean          default(TRUE)
#  subtitle                         :string(255)
#  summary                          :text
#  context_info                     :text
#  canonical_url                    :string(255)
#  robots_no_index                  :boolean          default(FALSE)
#  breadcrumb                       :string(255)
#  template_file                    :string(255)
#  article_for_index_id             :integer
#  article_for_index_levels         :integer          default(0)
#  article_for_index_count          :integer          default(0)
#  article_for_index_images         :boolean          default(FALSE)
#  enable_social_sharing            :boolean
#  cacheable                        :boolean          default(TRUE)
#  image_gallery_tags               :string(255)
#  article_type                     :string(255)
#  external_url_redirect            :string(255)
#  index_of_articles_tagged_with    :string(255)
#  sort_order                       :string(255)
#  reverse_sort                     :boolean
#  author_backup                    :string(255)
#  sorter_limit                     :integer
#  not_tagged_with                  :string(255)
#  use_frontend_tags                :boolean          default(FALSE)
#  dynamic_redirection              :string(255)      default("false")
#  redirection_target_in_new_window :boolean          default(FALSE)
#  commentable                      :boolean          default(FALSE)
#  active_since                     :datetime         default(2012-09-30 12:53:13 UTC)
#  redirect_link_title              :string(255)
#  display_index_types              :string(255)      default("show")
#  author_id                        :integer
#


#For article rendering to string (:render_html) needed
include Goldencobra::ApplicationHelper
require "open-uri"

module Goldencobra
  class Article < ActiveRecord::Base
    extend FriendlyId
    MetatagNames = ["Title Tag", "Meta Description", "Keywords", "OpenGraph Title", "OpenGraph Description", "OpenGraph Type", "OpenGraph URL", "OpenGraph Image"]
    LiquidParser = {}
    SortOptions = ["Created_at", "Updated_at", "Random", "Alphabetically"]
    DynamicRedirectOptions = [[:false,"deaktiviert"],[:latest,"neuester Untereintrag"], [:oldest, "ältester Untereintrag"]]
    DisplayIndexTypes = [["Einzelseiten", "show"],["Übersichtsseiten", "index"], ["Alle Seiten", "all"]]
    attr_accessor   :hint_label, :manual_article_sort
    ImportDataFunctions = []

    serialize :link_checker#, Hash

    has_many :metatags
    has_many :images, :through => :article_images, :class_name => Goldencobra::Upload
    has_many :article_images
    has_many :article_widgets
    has_many :widgets, :through => :article_widgets
    has_many :vita_steps, :as => :loggable, :class_name => Goldencobra::Vita
    has_many :comments, :class_name => Goldencobra::Comment
    has_many :permissions, :class_name => Goldencobra::Permission, :foreign_key => "subject_id", :conditions => {:subject_class => "Goldencobra::Article"}
    belongs_to :articletype, :class_name => Goldencobra::Articletype, :foreign_key => "article_type", :primary_key => "name"
    belongs_to :creator, :class_name => User, :foreign_key => "creator_id"

    belongs_to :author, :class_name => Goldencobra::Author

    accepts_nested_attributes_for :metatags, :allow_destroy => true, :reject_if => proc { |attributes| attributes['value'].blank? }
    accepts_nested_attributes_for :article_images, :allow_destroy => true
    accepts_nested_attributes_for :images, :allow_destroy => true
    accepts_nested_attributes_for :permissions, :allow_destroy => true
    accepts_nested_attributes_for :author, :allow_destroy => true

    acts_as_taggable_on :tags, :frontend_tags #https://github.com/mbleigh/acts-as-taggable-on
    has_ancestry    :orphan_strategy => :restrict
    friendly_id     :for_friendly_name, use: [:slugged] #, :history
    web_url         :external_url_redirect
    has_paper_trail
    liquid_methods :title, :created_at, :updated_at, :subtitle, :context_info, :id, :frontend_tags

    validates_presence_of :title, :article_type
    validates_format_of :url_name, :with => /\A[\w\d-]+\Z/, allow_blank: true
    validates_presence_of :breadcrumb, :on => :create
    validates_length_of :breadcrumb, :within => 1..70, :on => :create

    after_create :set_active_since
    after_create :notification_event_create
    before_save :parse_image_gallery_tags
    before_save :set_url_name_if_blank
    before_save :set_standard_application_template
    before_save :set_url_path
    after_save :set_default_meta_opengraph_values
    after_save :verify_existence_of_opengraph_image
    after_update :notification_event_update
    after_update :update_parent_article_etag
    before_destroy :update_parent_article_etag

    attr_protected :startpage

    scope :robots_index, where(:robots_no_index => false)
    scope :robots_no_index, where(:robots_no_index => true)
    #scope :active nun als Klassenmethode unten definiert
    scope :inactive, where(:active => false)
    scope :startpage, where(:startpage => true)
    scope :articletype, lambda{ |name| where(:article_type => name)}
    scope :latest, lambda{ |counter| order("created_at DESC").limit(counter)}
    scope :parent_ids_in_eq, lambda { |art_id| subtree_of(art_id) }
    scope :parent_ids_in, lambda { |art_id| subtree_of(art_id) }
    scope :modified_since, lambda{ |date| where("updated_at > ?", Date.parse(date))}
    scope :for_sitemap, includes(:images).where('dynamic_redirection = "false" AND ( external_url_redirect IS NULL OR external_url_redirect = "") AND active = 1 AND robots_no_index =  0')
    scope :frontend_tag_name_contains, lambda{|tag_name| tagged_with(tag_name.split(","), :on => :frontend_tags)}
    scope :tag_name_contains, lambda{|tag_name| tagged_with(tag_name.split(","), :on => :tags)}
    if ActiveRecord::Base.connection.table_exists?("goldencobra_metatags")
      scope :no_title_tag, where("goldencobra_articles.id NOT IN (?)", Goldencobra::Metatag.where(:name => "Title Tag").where("value IS NOT NULL AND value <> ''").pluck(:article_id).uniq)
      scope :no_meta_description, where("goldencobra_articles.id NOT IN (?)", Goldencobra::Metatag.where(:name => "Meta Description").where("value IS NOT NULL AND value <> ''").pluck(:article_id).uniq)
    end

    search_methods :frontend_tag_name_contains
    search_methods :tag_name_contains
    search_methods :parent_ids_in
    search_methods :parent_ids_in_eq

    if ActiveRecord::Base.connection.table_exists?("goldencobra_settings")
      if Goldencobra::Setting.for_key("goldencobra.use_solr") == "true"
        searchable do
          text :title, :boost => 5
          text :summary
          text :content
          text :subtitle
          text :searchable_in_article_type
          string :article_type_for_search
          boolean :active
          time :created_at
          time :updated_at
        end
      end
    end


    # **************************
    # **************************
    # Instance Methods
    # **************************
    # **************************

    def parent_path
      self.path.map(&:title).join(" / ")
    end

    #scope for index articles, display show articles, index articless or both articles of an current type
    def self.articletype_for_index(current_article)
      if current_article.display_index_types == "show"
        articletype("#{current_article.article_type_form_file} Show")
      elsif current_article.display_index_types == "index"
        articletype("#{current_article.article_type_form_file} Index")
      else
        where("article_type = '#{current_article.article_type_form_file} Show' OR article_type = '#{current_article.article_type_form_file} Index'")
      end
    end

    def render_html(layoutfile="application", localparams={})
      av = ActionView::Base.new(ActionController::Base.view_paths + ["#{::Goldencobra::Engine.root}/app/views/goldencobra/articles/"])
      av.request = ActionDispatch::Request.new(Rack::MockRequest.env_for(self.public_url))
      av.request["format"] = "text/html"
      av.controller = Goldencobra::ArticlesController.new
      av.controller.request = av.request
      if localparams.present? && localparams[:params].present?
        av.params.merge!(localparams[:params])
      end
      av.assign({:article => self})
      html_to_render = av.render(template: "/goldencobra/articles/show.html.erb", :layout => "layouts/#{layoutfile}", :locals => localparams, :content_type => "text/html" )
      return html_to_render
    end

    def comments_of_subarticles
      Goldencobra::Comment.where("article_id in (?)", self.subtree_ids)
    end

    def find_related_subarticle
      if self.dynamic_redirection == "latest"
        self.descendants.order("id DESC").first
      else
        self.descendants.order("id ASC").first
      end
    end


    #Das ist der Titel, der verwendet wird, wenn daraus ein Menüpunkt erstellt werden soll.
    #der menue.title hat folgende vorgaben: validates_format_of :title, :with => /^[\w\d\?\.\'\!\s&üÜöÖäÄß\-\:\,\"]+$/
    def parsed_title
      self.title.to_s.gsub("/", " ")
    end


    #@article.image_standard @article.image_logo @article.image_logo_medium
    def self.init_image_methods
      if ActiveRecord::Base.connection.table_exists?("goldencobra_settings")
        Goldencobra::Setting.for_key("goldencobra.article.image_positions").to_s.split(",").map(&:strip).each do |image_type|
          define_method "image_#{image_type.underscore}" do
            self.image(image_type,"original")
          end
          define_method "image_alt_#{image_type.underscore}" do
            self.article_images.where(position: image_type).first.image.alt_text || self.article_images.where(position: image_type).first.image.image_file_name
          end
          Goldencobra::Upload.attachment_definitions[:image][:styles].keys.each do |style_name|
            define_method "image_#{image_type.underscore}_#{style_name.to_s}" do
              self.image(image_type,style_name)
            end
          end
        end
      end
    end

    Goldencobra::Article.init_image_methods
    def image(position="standard", size="original")
      any_images = self.article_images.where(position: position)
      if any_images.any? && any_images.first.image && any_images.first.image.image
        return any_images.first.image.image.url(size.to_sym)
      else
        return ""
      end
    end


    def respond_to_all?(method_name)
      begin
        return eval("self.#{method_name}.present?")
      rescue
        return false
      end
    end

    # Gets the related object by article_type
    def get_related_object
      if self.article_type.present? && self.article_type_form_file.present? && self.respond_to?(self.article_type_form_file.underscore.parameterize.downcase)
        return self.send(self.article_type_form_file.underscore.parameterize.downcase)
      else
        return nil
      end
    end

    #dynamic methods for article.event or article.consultant .... depending on related object type
    def method_missing(meth, *args, &block)
      if meth.to_s.split(".").first == self.get_related_object.class.name.downcase
          if meth.to_s.split(".").count == 1
            self.get_related_object
          else
            self.get_related_object.send(meth.to_s.split(".").last)
          end
      else
        super
      end
    end

    def index_articles(current_operator=nil, user_frontend_tags=nil)
      if self.article_for_index_id.blank?
        #Index aller Artikel anzeigen
        @list_of_articles = Goldencobra::Article.active.articletype_for_index(self)
      else
        #Index aller Artikel anzeigen, die Kinder sind von einem Bestimmten artikel
        parent_article = Goldencobra::Article.find_by_id(self.article_for_index_id)
        if parent_article
          @list_of_articles = parent_article.descendants.active.articletype_for_index(self)
        else
          @list_of_articles = Goldencobra::Article.active.articletype_for_index(self)
        end
      end
      #include related models
      @list_of_articles = @list_of_articles.includes("#{self.article_type_form_file.underscore.parameterize.downcase}") if self.respond_to?(self.article_type_form_file.underscore.parameterize.downcase)
      #get articles with tag
      if self.index_of_articles_tagged_with.present?
        @list_of_articles = @list_of_articles.tagged_with(self.index_of_articles_tagged_with.split(",").map{|t| t.strip}, on: :tags, any: true)
      end
      #get articles without tag
      if self.not_tagged_with.present?
        @list_of_articles = @list_of_articles.tagged_with(self.not_tagged_with.split(",").map{|t| t.strip}, :exclude => true, on: :tags)
      end
      #get_articles_by_frontend_tags
      if user_frontend_tags.present?
        @list_of_articles = @list_of_articles.tagged_with(user_frontend_tags, on: :frontend_tags, any: true)
      end
      #filter with permissions
      @list_of_articles = filter_with_permissions(@list_of_articles,current_operator)

      #sort list of articles
      if self.sort_order.present?
        if self.sort_order == "Random"
          @list_of_articles = @list_of_articles.flatten.shuffle
        elsif self.sort_order == "Alphabetical"
          @list_of_articles = @list_of_articles.flatten.sort_by{|article| article.title }
        elsif self.respond_to?(self.sort_order.downcase)
          sort_order = self.sort_order.downcase
          @list_of_articles = @list_of_articles.flatten.sort_by{|article| article.respond_to?(sort_order) ? article.send(sort_order) : article }
        elsif self.sort_order.include?(".")
          sort_order = self.sort_order.downcase.split(".")
          @unsortable = @list_of_articles.flatten.select{|a| !a.respond_to_all?(self.sort_order) }
          @list_of_articles = @list_of_articles.flatten.delete_if{|a| !a.respond_to_all?(self.sort_order) }
          @list_of_articles = @list_of_articles.sort_by{|a| eval("a.#{self.sort_order}") }
          if @unsortable.count > 0
            @list_of_articles = @unsortable + @list_of_articles
            @list_of_articles = @list_of_articles.flatten
          end
        end
        if self.reverse_sort
          @list_of_articles = @list_of_articles.reverse
        end
      end
      if self.sorter_limit && self.sorter_limit > 0
        @list_of_articles = @list_of_articles[0..self.sorter_limit-1]
      end

      return @list_of_articles
    end


    # Methode filtert die @list_of_articles.
    # Rückgabewert: Ein Array all der Artikel, die der operator lesen darf.
    def filter_with_permissions(list, current_operator)
      if current_operator && current_operator.respond_to?(:has_role?) && current_operator.has_role?(Goldencobra::Setting.for_key("goldencobra.article.preview.roles").split(",").map{|a| a.strip})
        return list
      else
        a = Ability.new(current_operator)
        new_list = []
        list.each do |article|
          if a.can?(:read, article)
            new_list << article.id
          end
        end
      end
      return list.where('goldencobra_articles.id in (?)', new_list)
    end

    #Gibt ein Textstring zurück der bei den speziellen Artiekltypen für die Volltextsuche durchsucht werden soll
    def searchable_in_article_type
      @searchable_in_article_type_result ||= begin
        related_object = self.get_related_object
        if related_object && related_object.respond_to?(:fulltext_searchable_text)
          related_object.fulltext_searchable_text
        else
          " "
        end
      end
    end

    # Returns a special article_typs customs rss fields as xml
    def article_type_xml_fields
      related_object = self.get_related_object
      if related_object && related_object.respond_to?(:custom_rss_fields)
        related_object.custom_rss_fields
      end
    end

    def public_url(with_prefix=true)
      if self.startpage
        if with_prefix
          return "#{Goldencobra::Domain.current.try(:url_prefix)}/"
        else
          return "/"
        end
      else

        #url_path in der Datenbank als string speichern und beim update von ancestry neu berechnen... ansosnten den urlpafh aus dem string holen statt jedesmal über alle eltern iterierne
        if self.url_path.present?
          a_url = self.url_path
        else
          a_url = "/#{self.path.select([:ancestry, :url_name, :startpage]).map{|a| a.url_name if !a.startpage}.compact.join("/")}"
          self.save
        end

        if with_prefix
          return "#{Goldencobra::Domain.current.try(:url_prefix)}#{a_url}"
        else
          return a_url
        end
      end
      #Goldencobra::UrlBuilder.new(self, with_prefix).article_path
    end

    def date_of_last_modified_child
      if self.children.length > 0
        if self.children.order("updated_at DESC").first.updated_at.utc > self.updated_at.utc
          self.children.order("updated_at DESC").first.updated_at.utc
        else
          self.updated_at.utc
        end
      else
        self.updated_at.utc
      end
    end

    def absolute_base_url
      if Goldencobra::Setting.for_key("goldencobra.use_ssl") == "true"
        "https://#{Goldencobra::Setting.for_key('goldencobra.url')}"
      else
        "http://#{Goldencobra::Setting.for_key('goldencobra.url')}"
      end
      #Goldencobra::UrlBuilder.new(self).absolute_base_url
    end

    def absolute_public_url
      if Goldencobra::Setting.for_key("goldencobra.use_ssl") == "true"
        "https://#{Goldencobra::Setting.for_key('goldencobra.url')}#{self.public_url}"
      else
        "http://#{Goldencobra::Setting.for_key('goldencobra.url')}#{self.public_url}"
      end
      #Goldencobra::UrlBuilder.new(self).absolute_public_url
    end

    def for_friendly_name
      if self.url_name.present?
        self.url_name
      elsif self.breadcrumb.present?
        self.breadcrumb
      else
        self.title
      end
    end

    # Gibt Consultant | Subsidiary | etc. zurück je nach Seitentyp
    def article_type_form_file
      if self.article_type.present?
        self.article_type.split(" ")[0..-2].join("")
      end
    end

    # Gibt Index oder Show zurück, je nach Seitentyp
    def kind_of_article_type
      self.article_type.present? ? self.article_type.split(" ").last : ""
    end

    # Liefert Kategorienenamen für sie Suche unabhängig ob Die Seite eine show oder indexseite ist
    def article_type_for_search
      if self.article_type.present?
        self.article_type.split(" ")[0..-2].join("")
      else
        "Article"
      end
    end

    def selected_layout
      if self.template_file.blank?
        if self.articletype.present? && self.articletype.default_template_file.present?
          self.articletype.default_template_file
        else
          "application"
        end
      else
        self.template_file
      end
    end

    def breadcrumb_name
      if self.breadcrumb.present?
        return self.breadcrumb
      else
        return self.title
      end
    end

    def public_teaser
      return self.teaser if self.teaser.present?
      return self.summary if self.teaser.blank? && self.summary.present?
      return self.content[0..200] if self.teaser.blank? && self.summary.blank?
    end

    def article_for_index_limit
      if self.article_for_index_count.to_i <= 0
        return 1000
      else
        self.article_for_index_count.to_i
      end
    end

    def mark_as_startpage!
      Goldencobra::Article.startpage.each do |a|
        a.startpage = false
        a.save
      end
      self.startpage = true
      self.save
    end

    def is_startpage?
      self.startpage
    end

    def metatag(name)
      return "" if !MetatagNames.include?(name)
      metatag = self.metatags.find_by_name(name)
      metatag.value if metatag
    end


    #Datum für den RSS reader, Datum ist created_at es sei denn ein Articletype hat ein published_at definiert
    def published_at
      if self.article_type.present? && self.article_type_form_file.present? && self.respond_to?(self.article_type_form_file.underscore.parameterize.downcase)
        related_object = self.send(self.article_type_form_file.underscore.parameterize.downcase)
        if related_object && related_object.respond_to?(:published_at)
          related_object.published_at
        else
          self.created_at
        end
      else
        self.created_at
      end
    end

    def linked_menues
      Goldencobra::Menue.where(:target => self.public_url)
    end

    def complete_json

    end


    # **************************
    # **************************
    # Callback Methods
    # **************************
    # **************************

    def set_url_path
      self.url_path = "/#{self.path.select([:ancestry, :url_name, :startpage]).map{|a| a.url_name if !a.startpage}.compact.join("/")}"
    end

    #Nachdem ein Artikel gelöscht oder aktualsisiert wurde soll sein Elternelement aktualisiert werden, damit ein rss feed oder ähnliches mitbekommt wenn ein kindeintrag gelöscht oder bearbeitet wurde
    def update_parent_article_etag
      if self.parent.present?
        self.parent.update_attributes(:updated_at => Time.now)
      end
    end

    def set_active_since
      self.active_since = self.created_at
    end

    def parse_image_gallery_tags
      if self.respond_to?(:image_gallery_tags)
        self.image_gallery_tags = self.image_gallery_tags.compact.delete_if{|a| a.blank?}.join(",") if self.image_gallery_tags.class == Array
      end
    end

    def set_default_meta_opengraph_values
      # Diese Zeile schein Überflüssig geworden zu sein, da nun der teaser, description oder title als defaultwerte genommen werden
      #meta_description = Goldencobra::Setting.for_key('goldencobra.page.default_meta_description_tag')

      if self.teaser.present?
        meta_description = remove_html_tags(self.teaser.truncate(200))
      else
        meta_description = self.content.present? ? remove_html_tags(self.content).truncate(200) : self.title
      end

      if Goldencobra::Metatag.where(article_id: self.id, name: 'Meta Description').none?
        Goldencobra::Metatag.create(name: 'Meta Description',
                                    article_id: self.id,
                                    value: meta_description)
      end

      if Goldencobra::Metatag.where(article_id: self.id, name: 'Title Tag').none?
        Goldencobra::Metatag.create(name: 'Title Tag',
                                    article_id: self.id,
                                    #value: self.breadcrumb.present? ? self.breadcrumb : self.title)
                                    value: self.title)
      end

      if Goldencobra::Metatag.where(article_id: self.id, name: 'OpenGraph Description').none?
        Goldencobra::Metatag.create(name: 'OpenGraph Description',
                                    article_id: self.id,
                                    value: meta_description)
      end

      if Goldencobra::Metatag.where(article_id: self.id, name: 'OpenGraph Title').none?
        Goldencobra::Metatag.create(name: 'OpenGraph Title',
                                    article_id: self.id,
                                    value: self.title)
      end

      if Goldencobra::Metatag.where(article_id: self.id, name: 'OpenGraph URL').none?
        Goldencobra::Metatag.create(name: 'OpenGraph URL',
                                    article_id: self.id,
                                    value: self.absolute_public_url)
      end
    end

    # helper um links zu entfernen in text
    def remove_html_tags(text)
      text.gsub(/<[^<]+?>/, "")
    end

    def verify_existence_of_opengraph_image
      if Goldencobra::Metatag.where(article_id: self.id, name: "OpenGraph Image").none?
        if self.article_images.any? && self.article_images.first.present? && self.article_images.first.image.present? && self.article_images.first.image.image.present?
          og_img_val = "#{self.absolute_base_url}#{self.article_images.first.image.image.url}"
        else
          og_img_val = Goldencobra::Setting.for_key("goldencobra.facebook.opengraph_default_image")
        end
        Goldencobra::Metatag.create(name: "OpenGraph Image", article_id: self.id, value: og_img_val)
      end
    end

    def notification_event_create
      ActiveSupport::Notifications.instrument("goldencobra.article.created", :article_id => self.id)
    end

    def notification_event_update
      ActiveSupport::Notifications.instrument("goldencobra.article.updated", :article_id => self.id)
    end

    def set_url_name_if_blank
      if self.url_name.blank?
        #self.url_name = self.breadcrumb
        self.url_name = self.friendly_id.split("--")[0]
      end
    end

    def set_standard_application_template
      if ActiveRecord::Base.connection.table_exists?("goldencobra_articles") && ActiveRecord::Base.connection.table_exists?("goldencobra_articletypes")
        if self.template_file.blank?
          if self.articletype.present? && self.articletype.default_template_file.present?
            self.template_file = self.articletype.default_template_file
          else
            self.template_file = "application"
          end
        end
      end
    end

    # **************************
    # **************************
    # Class Methods
    # **************************
    # **************************

    def self.active
      Goldencobra::Article.where("active = 1 AND active_since < '#{Time.now.strftime('%Y-%m-%d %H:%M:%S ')}'")
    end

    def active?
      self.active && self.active_since < Time.now.utc
    end

    def self.search_by_url(url)
      article = nil
      articles = Goldencobra::Article.where(:url_name => url.split("/").last.to_s.split(".").first)
      article_path = "/#{url.split('.').first}"
      if articles.count > 0
        article = articles.select{|a| a.public_url(false) == article_path}.first
      end
      return article
    end

    def self.load_liquid_methods(options={})

    end

    def self.recent(count)
      Goldencobra::Article.where('title IS NOT NULL').order('created_at DESC').limit(count)
    end

    def self.recreate_cache
      if RUBY_VERSION.include?("1.9.")
        ArticlesCacheWorker.perform_async()
      else
        Goldencobra::Article.active.each do |article|
          article.updated_at = Time.now
          article.without_versioning :save
        end
      end
    end

    def self.article_types_for_select
      results = []
      path_to_articletypes = File.join(::Rails.root, "app", "views", "articletypes")
      if Dir.exist?(path_to_articletypes)
        Dir.foreach(path_to_articletypes) do |name| #.map{|a| File.basename(a, ".html.erb")}.delete_if{|a| a =~ /^_edit/ }.delete_if{|a| a[0] == "_"}
          file_name_path = File.join(path_to_articletypes,name)
          if File.directory?(file_name_path)
            Dir.foreach(file_name_path) do |sub_name|
                file_name = "#{name.titleize.gsub(' ','')}#{sub_name.titleize}" if File.exist?(File.join(file_name_path,sub_name)) && (sub_name =~ /^_(?!edit).*/) == 0
                results << file_name.split(".").first if file_name.present?
            end
          end
        end
      end
      return results
    end

    def self.article_types_for_search
      results = []
      path_to_articletypes = File.join(::Rails.root, "app", "views", "articletypes")
      if Dir.exist?(path_to_articletypes)
        Dir.foreach(path_to_articletypes) do |name| #.map{|a| File.basename(a, ".html.erb")}.delete_if{|a| a =~ /^_edit/ }
          results << name.capitalize unless name.include?(".")
        end
      end
      return results
    end

    def self.templates_for_select
      Dir.glob(File.join(::Rails.root, "app", "views", "layouts", "*.html.erb")).map{|a| File.basename(a, ".html.erb")}.delete_if{|a| a =~ /^_/ }
    end

    def self.simple_search(q)
      self.active.search(:title_or_subtitle_or_url_name_or_content_or_summary_or_teaser_contains => q).relation.map {
          |article|
        {
            :id => article.id,
            :absolute_public_url => article.absolute_public_url,
            :title => article ? article.title : '',
            :teaser => article ? article.teaser : '',
            :article_type => article.article_type,
            :updated_at => article.updated_at,
            :parent_title => article.parent ? article.parent.title ? article.parent.title : '' : '',
            :ancestry => article.ancestry ? article.ancestry : ''
        }
      }
    end

  end
end

#parent           Returns the parent of the record, nil for a root node
#parent_id        Returns the id of the parent of the record, nil for a root node
#root             Returns the root of the tree the record is in, self for a root node
#root_id          Returns the id of the root of the tree the record is in
#is_root?         Returns true if the record is a root node, false otherwise
#ancestor_ids     Returns a list of ancestor ids, starting with the root id and ending with the parent id
#ancestors        Scopes the model on ancestors of the record
#path_ids         Returns a list the path ids, starting with the root id and ending with the node's own id
#path             Scopes model on path records of the record
#children         Scopes the model on children of the record
#child_ids        Returns a list of child ids
#has_children?    Returns true if the record has any children, false otherwise
#is_childless?    Returns true is the record has no childen, false otherwise
#siblings         Scopes the model on siblings of the record, the record itself is included
#sibling_ids      Returns a list of sibling ids
#has_siblings?    Returns true if the record's parent has more than one child
#is_only_child?   Returns true if the record is the only child of its parent
#descendants      Scopes the model on direct and indirect children of the record
#descendant_ids   Returns a list of a descendant ids
#subtree          Scopes the model on descendants and itself
#subtree_ids      Returns a list of all ids in the record's subtree
#depth            Return the depth of the node, root nodes are at depth 0

