require 'spec_helper'

describe Goldencobra::Location do
  
  it "should have a latitude and longitude" do
    location = Goldencobra::Location.create(:street => "Zossener Str. 55", :city => "Berlin", :zip => "10961")
    location.lat.should_not == nil
    location.lng.should_not == nil
  end

  it "should have no latitude and longitude because of missing city" do
    location = Goldencobra::Location.create(:street => "Zossener Str. 55", :city => "", :zip => "10961")
    location.lat.should == nil
    location.lng.should == nil
  end

  it "should not have a latitude and longitude" do
    location = Goldencobra::Location.create(:street => " ", :city => "", :zip => "")
    location.lat.should == nil
    location.lng.should == nil
  end

  
end
