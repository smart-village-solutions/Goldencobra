# encoding: utf-8

module Goldencobra
  class ImportMetadata < ApplicationRecord
  	ImportDataFunctions = []
    belongs_to :importmetatagable, polymorphic: true
  end
end
