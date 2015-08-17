# encoding: utf-8

require 'spec_helper'

describe Goldencobra::Location do

  before do
    Geocoder.configure(:lookup => :test)

    Geocoder::Lookup::Test.add_stub(
      "Zossener Str. 55, 10961 Berlin", [
                      {
                        'latitude'     => 40.7143528,
                        'longitude'    => -74.0059731,
                        'address'      => 'Zossener Str. 55 10961 Berlin',
                        'state'        => 'Berlin',
                        'state_code'   => '',
                        'country'      => 'Germany',
                        'country_code' => 'DE'
                      }
                    ]
    )
  end
  it "should have a latitude and longitude" do
    location = Goldencobra::Location.create(street: "Zossener Str. 55", 
                                              city: "Berlin",
                                               zip: "10961")
    expect(location.lat).to_not eq(nil)
    expect(location.lng).to_not eq(nil)
    expect(Goldencobra::Location.find_by_zip("10961").street).to eq "Zossener Str. 55"
  end

  it "should have no latitude and longitude because of missing city" do
    location = Goldencobra::Location.create(street: "Puccinistrasse 40", city: "", zip: "13088")
    expect(location.lat).to eq(nil)
    expect(location.lng).to eq(nil)
    expect(Goldencobra::Location.find_by_zip("13088").street).to eq "Puccinistrasse 40"
  end

  it "should not have a latitude and longitude" do
    location = Goldencobra::Location.create(street: " ", city: "", zip: "")
    expect(location.lat).to eq(nil)
    expect(location.lng).to eq(nil)
  end


end
