# == Schema Information
#
# Table name: goldencobra_locations
#
#  id              :integer          not null, primary key
#  lat             :string(255)
#  lng             :string(255)
#  street          :string(255)
#  city            :string(255)
#  zip             :string(255)
#  region          :string(255)
#  country         :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  title           :string(255)
#  street_number   :string(255)
#  locateable_type :string(255)
#  locateable_id   :integer
#

module Goldencobra
  class Location < ActiveRecord::Base
    geocoded_by :complete_location, :latitude  => :lat, :longitude => :lng
    after_validation :geocode, :unless => :skip_geocode
    attr_accessor :skip_geocode
    liquid_methods :street, :city, :zip, :region, :country, :title
    belongs_to :locateable, :polymorphic => true

    def complete_location
      result = ""
      result += "#{self.street}" if self.street.present?
      result += " #{self.street_number}" if self.street_number.present?
      result += ", #{self.zip}" if self.zip.present?
      result += " #{self.city}" if self.city.present?
    end

    def title
      self.complete_location
    end

  end
end
