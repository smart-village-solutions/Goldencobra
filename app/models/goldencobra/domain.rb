module Goldencobra
  class Domain < ActiveRecord::Base

    validates_presence_of :client
    validates_format_of :client, :with => /^[\w]+$/
    validates_presence_of :title
    validates_presence_of :hostname
  	validates_uniqueness_of :hostname

  end
end
