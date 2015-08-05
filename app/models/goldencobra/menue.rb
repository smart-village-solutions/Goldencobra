# encoding: utf-8

# == Schema Information
#
# Table name: goldencobra_menues
#
#  id                  :integer          not null, primary key
#  title               :string(255)
#  target              :string(255)
#  css_class           :string(255)
#  active              :boolean          default(TRUE)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  ancestry            :string(255)
#  sorter              :integer          default(0)
#  description         :text
#  call_to_action_name :string(255)
#  description_title   :string(255)
#  image_id            :integer
#

module Goldencobra
  class Menue < ActiveRecord::Base
    attr_accessible :title, :target, :css_class, :active, :ancestry, :parent_id,
                    :sorter, :description, :call_to_action_name, :description_title, :image_attributes, :image_id,
                    :permissions_attributes, :remote
    has_ancestry :orphan_strategy => :rootify, :cache_depth => true
    belongs_to :image, :class_name => Goldencobra::Upload, :foreign_key => "image_id"

    validates_presence_of :title
    validates_format_of :title, :with => /\A[\w\d\?\.\'\!\s&üÜöÖäÄß\-\:\,\"]+\z/
    has_many :permissions, -> { where subject_class: "Goldencobra::Menue" }, class_name: Goldencobra::Permission, foreign_key: "subject_id"

    accepts_nested_attributes_for :permissions, :allow_destroy => true

    if ActiveRecord::Base.connection.table_exists?("goldencobra_settings")
      if Goldencobra::Setting.for_key("goldencobra.menues.recreate_cache") == "true"
        after_save 'Goldencobra::Article.recreate_cache'
      end
    end
    if ActiveRecord::Base.connection.table_exists?("versions")
      has_paper_trail
    end
    scope :active, -> { where(:active => true).order(:sorter) }
    scope :inactive, -> { where(:active => false).order(:sorter) }
    scope :visible, -> { where("css_class <> 'hidden'").where("css_class <> 'not_visible'") }

    scope :parent_ids_in_eq, lambda { |art_id| subtree_of(art_id) }

    scope :parent_ids_in, lambda { |art_id| subtree_of(art_id) }

    before_save :set_descendants_status

    def self.find_by_pathname(name)
      if name.include?("/")
        where(:title => name.split("/").last).select{|a| a.path.map(&:title).join("/") == name}.first
      else
        find_by_title(name)
      end
    end

    def is_active?(request)
      @is_active_result ||= {}
      @is_active_result[request.path.squeeze("/").chomp("/").split("?")[0]] ||= request.path.squeeze("/").chomp("/").split("?")[0] == self.target.gsub("\"",'')
    end

    def has_active_child?(request, subtree_menues)
      @has_active_child_result ||= {}
      @has_active_child_result[request.path.squeeze("/").split("?")[0]] ||= has_active_descendant?(subtree_menues, request)
    end

    def has_active_descendant?(subtree_menues,request)
      subtree_menues.select{|a| a.ancestry.to_s.starts_with?("#{self.ancestry}/#{self.id}")}.map(&:target).include?(request.path.squeeze("/").split("?")[0])
    end

    def has_children
      self.has_children?
    end

    def mapped_to_article?
      #TODO Anfrage dauert zu lange bei 2000 Artikeln
      #@mapped_to_article_result ||= Goldencobra::Article.select([:url_name, :startpage, :ancestry, :id]).map{|a| a.public_url}.uniq.include?(self.target)
      false
    end


    # Render Content of Description with liquid Tags
    # 
    # @return [String] self.description liquified
    def liquid_description
      template = Liquid::Template.parse(self.description)
      template.render(Goldencobra::Article::LiquidParser)
    end

    def navigation_image
      return {} unless self.image

      {
        "alt_text" => self.image.alt_text ? self.image.alt_text : self.image.image_file_name,
        "src" => self.image.image(:original)
      }
    end


    # Filtert die übergebenen mthodennamen anhand einer Whiteliste 
    # und ersetzt exteren methodenbezeichnungen mit internene helpern
    # 
    # description => liquid_description
    # 
    # @param method_names [Array] Liste an Methodennamen als String
    # 
    # @return [Array] Liste an methoden als Symbol, bereinigt von invaliden aufrufen
    def self.filtered_methods(method_names=[])
      #Alle zugelasssenen methodennamen als Array of Strings
      allowed_attribute_methods = Goldencobra::Menue.new.attributes.keys 
      additional_whitelist_methods = ["liquid_description", "navigation_image"]
      all_allowed_methodes = allowed_attribute_methods + additional_whitelist_methods

      #Filter übergebene methodenliste auf die zugelassenen namen
      selected_methods = method_names.select{ |a| all_allowed_methodes.include?(a) }

      #Wandle method names um in Symbols
      method_names = selected_methods.map{ |a| a.to_sym }
      
      return method_names.sort
    end


    # Liefert ein Hash der übegenene Anestry Arranged Daten
    # @param nodes [Goldencobra::Menue] Ein Eltern-Menüelement 
    # @param display_methods [:method] Optionale Liste an Mehtoden die auf das Menüelement aufgerufen werden sollen
    # 
    #  { 
    #   :id => node.id, 
    #   :title => node.title, 
    #   :target => node.target, 
    #   :eg_desciption => node.eg_description
    #   :children => json_tree(sub_nodes).compact
    # }
    # 
    # @return [Hash] Hash of Menue Data with optional attributes
    def self.json_tree(nodes, display_methods )
      nodes.map do |node, sub_nodes|
        node.as_json(:only => [:id, :title, :target], :methods => display_methods).merge({:children => json_tree(sub_nodes, display_methods).compact})
      end
    end


    # **************************
    # **************************
    # Private Methods
    # **************************
    # **************************

    private

    def set_descendants_status
      if self.active_changed?
        # Save without callbacks
        if Rails::VERSION::MAJOR == 3
          self.descendants.map{ |d| d.update_column(:active, self.active) }
        elsif Rails::VERSION::MAJOR > 3
          self.descendants.map{ |d| d.update_columns(:active, self.active) }
        end
      end
    end


    # Allow Scopes and Methods to search for in ransack (n.a. metasearch)
    # @param auth_object = nil [self] "if auth_object.try(:admin?)"
    # 
    # @return [Array] Array of Symbols representing scopes and class methods
    def self.ransackable_scopes(auth_object = nil)
      [ :parent_ids_in ]
    end

  end
end


# has_ancestry Doku 
# 
# parent           Returns the parent of the record, nil for a root node
# parent_id        Returns the id of the parent of the record, nil for a root node
# root             Returns the root of the tree the record is in, self for a root node
# root_id          Returns the id of the root of the tree the record is in
# is_root?         Returns true if the record is a root node, false otherwise
# ancestor_ids     Returns a list of ancestor ids, starting with the root id and ending with the parent id
# ancestors        Scopes the model on ancestors of the record
# path_ids         Returns a list the path ids, starting with the root id and ending with the node's own id
# path             Scopes model on path records of the record
# children         Scopes the model on children of the record
# child_ids        Returns a list of child ids
# has_children?    Returns true if the record has any children, false otherwise
# is_childless?    Returns true is the record has no childen, false otherwise
# siblings         Scopes the model on siblings of the record, the record itself is included
# sibling_ids      Returns a list of sibling ids
# has_siblings?    Returns true if the record's parent has more than one child
# is_only_child?   Returns true if the record is the only child of its parent
# descendants      Scopes the model on direct and indirect children of the record
# descendant_ids   Returns a list of a descendant ids
# subtree          Scopes the model on descendants and itself
# subtree_ids      Returns a list of all ids in the record's subtree
# depth            Return the depth of the node, root nodes are at depth 0


