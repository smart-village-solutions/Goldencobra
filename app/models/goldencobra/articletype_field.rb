# encoding: utf-8

module Goldencobra
  class ArticletypeField < ActiveRecord::Base
    attr_accessible :articletype_group_id, :class_name, :fieldname, :sorter

    belongs_to :group, :class_name => Goldencobra::ArticletypeGroup, :foreign_key => :articletype_group_id

    default_scope order(:sorter)
  end
end
