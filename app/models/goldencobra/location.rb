# == Schema Information
#
# Table name: goldencobra_locations
#
#  id         :integer(4)      not null, primary key
#  lat        :string(255)
#  lng        :string(255)
#  street     :string(255)
#  city       :string(255)
#  zip        :string(255)
#  region     :string(255)
#  country    :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  title      :string(255)
#

module Goldencobra
  class Location < ActiveRecord::Base
    geocoded_by :complete_location, :latitude  => :lat, :longitude => :lng
    after_validation :geocode
    liquid_methods :street, :city, :zip, :region, :country, :title
    
    def complete_location 
      result = ""
      result += "#{self.street}" if self.street.present?
      result += ", #{self.zip}" if self.zip.present?
      result += ", #{self.city}" if self.city.present?
    end
        
  end
end
