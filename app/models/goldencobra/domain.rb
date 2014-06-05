# encoding: utf-8

module Goldencobra
  class Domain < ActiveRecord::Base

    has_many :permissions, :class_name => Goldencobra::Permission

    validates_presence_of :client
    validates_format_of :client, :with => /^[\w]+$/
    validates_presence_of :title
    validates_presence_of :hostname
  	validates_uniqueness_of :hostname

    before_save :mark_as_main

    def self.main
      Goldencobra::Domain.where(:main => true).first
    end

    def mark_as_main
      if self.main == true
        Goldencobra::Domain.where("id <> #{self.id.to_i}").each do |a|
          a.main = false
          a.save
        end
      end
    end

  	def self.current
  		Thread.current[:current_client]
  	end

  	def self.current=(ccl)
  		Thread.current[:current_client] = ccl
  	end

  end
end
