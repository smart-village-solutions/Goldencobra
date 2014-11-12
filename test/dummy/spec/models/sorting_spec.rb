# encoding: utf-8

require 'spec_helper'

describe Goldencobra::Article do

  describe 'sorting Articles on index pages' do
    before(:each) do
      @attr = { :title  => "Testartikel", :article_type => "Default Show", :breadcrumb => 'bc_testarticle' }
    end

    it "should have a global sorting id" do
      a = Goldencobra::Article.new(@attr)
      a.save
      a.global_sorting_id.should == 0
    end
  end
end
