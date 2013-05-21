# == Schema Information
#
# Table name: goldencobra_metatags
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  value            :string(255)
#  article_id       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  metatagable_id   :integer
#  metatagable_type :string(255)
#

module Goldencobra
  class Metatag < ActiveRecord::Base
    attr_accessible :name, :value, :article_id
    belongs_to :article
    belongs_to :metatagable, polymorphic: true
  end
end
