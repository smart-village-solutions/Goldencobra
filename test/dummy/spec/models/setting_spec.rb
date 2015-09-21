# encoding: utf-8

require 'spec_helper'

describe Goldencobra::Setting do
  describe "changing a value" do
    it "successfully changes a value" do
      Goldencobra::Setting.create(title: "url", value: "www.goldencobra.de", ancestry: "goldencobra")
      Goldencobra::Setting.set_value_for_key("http://www.goldencobra.de", "goldencobra.url")
      expect(Goldencobra::Setting.where(title: "url").first.value).to eq("http://www.goldencobra.de")
    end
  end
end
