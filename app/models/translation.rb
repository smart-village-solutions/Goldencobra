class Translation < ActiveRecord::Base
  attr_accessible :interpolations, :is_proc, :key, :locale, :value

  scope :missing_values, where("value IS NULL OR value = ''")
  scope :with_values, where("value IS NOT NULL OR value <> ''")

end

