# encoding: utf-8

# == Schema Information
#
# Table name: translations
#
#  id             :integer          not null, primary key
#  locale         :string(255)
#  key            :string(255)
#  value          :text
#  interpolations :text
#  is_proc        :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Translation < ActiveRecord::Base
  attr_accessible :interpolations, :is_proc, :key, :locale, :value

  scope :missing_values, where("value IS NULL OR value = ''")
  scope :with_values, where("value IS NOT NULL OR value <> ''")

end

