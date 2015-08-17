require "spec_helper"

describe "Settings initializer", type: :model do
  it "imports the default settings" do
    expect(Goldencobra::Setting.for_key("goldencobra.locations.geocoding")).to eq "true"
  end
end
