# encoding: utf-8

module Goldencobra
  class Articletype < ActiveRecord::Base
    attr_accessible :default_template_file, :name
    has_many :articles, :class_name => Goldencobra::Article, :foreign_key => :article_type, :primary_key => :name
    validates_uniqueness_of :name

  end
end
