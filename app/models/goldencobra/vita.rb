module Goldencobra
  class Vita < ActiveRecord::Base
    belongs_to :loggable, :polymorphic => true
    attr_accessible :description, :title, :user_id
  end
end
