module Goldencobra
  class ArticletypeTemplate < ActiveRecord::Base
    belongs_to :template, class_name: "Goldencobra::Template"
    belongs_to :articletype
  end
end

# == Schema Information
#
# Table name: goldencobra_articletype_templates
#
#  id             :integer          not null, primary key
#  articletype_id :integer
#  template_id    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
