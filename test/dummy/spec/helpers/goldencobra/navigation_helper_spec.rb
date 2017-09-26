require "spec_helper"

describe Goldencobra::NavigationHelper, type: :helper do
  it "gsub works correctly" do
    expect("my-awesome-class").to_s.gsub(/[^A-z\-]/,' ').to eq("my-awesome-class")
    expect("another_awesome_class").to_s.gsub(/[^A-z\-]/,' ').to eq("another_awesome_class")
  end
end