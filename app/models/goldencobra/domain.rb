module Goldencobra
  class Domain < ActiveRecord::Base

    validates_presence_of :client
    validates_format_of :client, :with => /^[\w]+$/
    validates_presence_of :title
    validates_presence_of :hostname
  	validates_uniqueness_of :hostname


  	def self.current
  		Thread.current[:current_client]
  	end

  	def self.current=(ccl)
  		Thread.current[:current_client] = ccl
  	end

  end
end
