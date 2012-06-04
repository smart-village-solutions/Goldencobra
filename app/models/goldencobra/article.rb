# == Schema Information
#
# Table name: goldencobra_articles
#
#  id                       :integer(4)      not null, primary key
#  title                    :string(255)
#  created_at               :datetime        not null
#  updated_at               :datetime        not null
#  url_name                 :string(255)
#  slug                     :string(255)
#  content                  :text
#  teaser                   :text
#  ancestry                 :string(255)
#  startpage                :boolean(1)      default(FALSE)
#  active                   :boolean(1)      default(TRUE)
#  subtitle                 :string(255)
#  summary                  :text
#  context_info             :text
#  canonical_url            :string(255)
#  robots_no_index          :boolean(1)      default(FALSE)
#  breadcrumb               :string(255)
#  template_file            :string(255)
#  article_for_index_id     :integer(4)
#  article_for_index_levels :integer(4)      default(0)
#  article_for_index_count  :integer(4)      default(0)
#  article_for_index_images :boolean(1)      default(FALSE)
#  enable_social_sharing    :boolean(1)
#  cacheable                :boolean(1)      default(TRUE)
#  image_gallery_tags       :string(255)
#

module Goldencobra
  class Article < ActiveRecord::Base    
    extend FriendlyId
    attr_accessor :hint_label
    friendly_id :url_name, use: [:slugged, :history]
    has_ancestry :orphan_strategy => :restrict
    acts_as_taggable_on :tags #https://github.com/mbleigh/acts-as-taggable-on
    MetatagNames = ["Title Tag", "Meta Description", "Keywords", "OpenGraph Title", "OpenGraph Type", "OpenGraph URL", "OpenGraph Image"]
    LiquidParser = {}
    has_many :metatags
    accepts_nested_attributes_for :metatags, :allow_destroy => true, :reject_if => proc { |attributes| attributes['value'].blank? }
    has_many :images, :through => :article_images, :class_name => Goldencobra::Upload
    has_many :article_images
    has_many :article_widgets
    has_many :widgets, :through => :article_widgets
    has_many :vita_steps, :as => :loggable, :class_name => Goldencobra::Vita
    accepts_nested_attributes_for :article_images    
    
    validates_presence_of :title
    
    before_save :verify_existens_of_url_name_and_slug
    before_save :parse_image_gallery_tags
    validates_format_of :url_name, :with => /^[\w\d-]+$/, allow_blank: true
    attr_protected :startpage
    
    scope :robots_index, where(:robots_no_index => false)
    scope :robots_no_index, where(:robots_no_index => true)
    scope :active, where(:active => true)
    scope :inactive, where(:active => false)
    scope :startpage, where(:startpage => true)    

    scope :parent_ids_in_eq, lambda { |art_id| subtree_of(art_id) }
    search_methods :parent_ids_in_eq
    
    scope :parent_ids_in, lambda { |art_id| subtree_of(art_id) }
    search_methods :parent_ids_in

    after_save :verify_existence_of_opengraph_image
     
    liquid_methods :title, :created_at, :updated_at, :subtitle, :context_info
     
    def public_url
      if self.startpage
        return "/" 
      else
        "/#{self.path.map{|a| a.url_name if !a.startpage}.compact.join("/")}"
      end
    end 

    def parse_image_gallery_tags
      if self.respond_to?(:image_gallery_tags)
        self.image_gallery_tags = self.image_gallery_tags.compact.delete_if{|a| a.blank?}.join(",") if self.image_gallery_tags.class == Array
      end
    end
    def verify_existence_of_opengraph_image
      if Goldencobra::Metatag.where("article_id = ? AND name = 'OpenGraph Image'", self.id).count == 0
        Goldencobra::Metatag.create(article_id: self.id, name: "OpenGraph Image", value: Goldencobra::Setting.for_key("goldencobra.facebook.opengraph_default_image"))
      end
    end
    
    def verify_existens_of_url_name_and_slug
      self.url_name = self.title.downcase.parameterize if self.url_name.blank?
      self.slug = self.url_name.downcase.parameterize if self.slug.blank?
    end
    
    def self.templates_for_select
      Dir.glob(File.join(::Rails.root, "app", "views", "layouts", "*.html.erb")).map{|a| File.basename(a, ".html.erb")}.delete_if{|a| a =~ /^_/ }
    end

    def self.article_types_for_select
      results = []
      path_to_articletypes = File.join(::Rails.root, "app", "views", "articletypes")
      if Dir.exist?(path_to_articletypes)
        Dir.foreach(path_to_articletypes) do |name| #.map{|a| File.basename(a, ".html.erb")}.delete_if{|a| a =~ /^_edit/ }
          file_name_path = File.join(path_to_articletypes,name)
          if File.directory?(file_name_path)
            Dir.foreach(file_name_path) do |sub_name|
                file_name = "#{name}#{sub_name}" if File.exist?(File.join(file_name_path,sub_name)) && (sub_name =~ /^_(?!edit).*/) == 0 
                results << file_name.split(".").first.titleize if file_name.present?
            end
          end
        end
      end
      return results
    end
    
    def article_type_form_file
      self.article_type.split(" ").first if self.article_type.present?
    end

    
    def selected_layout
      if self.template_file.blank?
        "application"
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
      Article.startpage.each do |a|
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

    def self.recent(count)
      Goldencobra::Article.where('title IS NOT NULL').order('updated_at DESC').limit(count)
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

