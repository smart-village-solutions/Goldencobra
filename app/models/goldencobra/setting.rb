module Goldencobra
  class Setting < ActiveRecord::Base
    has_ancestry :orphan_strategy => :restrict
  end
end
