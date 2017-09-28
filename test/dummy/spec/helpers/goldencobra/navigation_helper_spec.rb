require "spec_helper"

describe Goldencobra::NavigationHelper, type: :helper do
  it "uses gsub correctly" do
    expect(("my-awesome-class").to_s.gsub(/[^\w\-]/,' ')).to eq("my-awesome-class")
    expect(("another_awesome_class").to_s.gsub(/[^\w\-]/,' ')).to eq("another_awesome_class")
    expect(("not A%N awes$me_*+wCl!ass --but-dashes-work").to_s.gsub(/[^\w\-]/,' ')).to eq("not A N awes me_  wCl ass --but-dashes-work")
    expect(("my-test-class-1").to_s.gsub(/[^\w\-]/,' ')).to eq("my-test-class-1")
  end
end