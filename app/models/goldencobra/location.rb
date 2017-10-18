# encoding: utf-8

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
    geocoded_by :complete_location, latitude: :lat, longitude: :lng
    after_validation :safe_geocode, unless: :skip_geocoding_once_or_always

    attr_accessor :skip_geocode
    liquid_methods :street, :city, :zip, :region, :country, :title
    belongs_to :locateable, polymorphic: true

    def safe_geocode
      geocode
    rescue Geocoder::OverQueryLimitError
    end

    def complete_location
      result = ""
      result += street.to_s if street.present?
      result += " #{street_number}" if street_number.present?
      result += ", #{zip}" if zip.present?
      result += " #{city}" if city.present?
    end

    def title
      complete_location
    end

    def skip_geocoding_once_or_always
      (Goldencobra::Setting.for_key("goldencobra.locations.geocoding") == "false") ||
        skip_geocode || manual_geocoding
    end
  end
end
