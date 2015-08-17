# encoding: utf-8

require 'spec_helper'

describe Goldencobra::Location do

  it "should have a latitude and longitude" do
    location = Goldencobra::Location.create(street: "Zossener Str. 55", 
                                              city: "Berlin",
                                               zip: "10961")
    expect(location.lat).to_not eq(nil)
    expect(location.lng).to_not eq(nil)
    expect(Goldencobra::Location.find_by_zip("10961").street).to eq "Zossener Str. 55"
  end

  it "should have no latitude and longitude because of missing city" do
    location = Goldencobra::Location.create(:street => "Puccinistrasse 40", :city => "", :zip => "13088")
    expect(location.lat).to eq(nil)
    expect(location.lng).to eq(nil)
    expect(Goldencobra::Location.find_by_zip("13088").street).to eq "Puccinistrasse 40"
  end

  it "should not have a latitude and longitude" do
    location = Goldencobra::Location.create(:street => " ", :city => "", :zip => "")
    expect(location.lat).to eq(nil)
    expect(location.lng).to eq(nil)
  end


end
