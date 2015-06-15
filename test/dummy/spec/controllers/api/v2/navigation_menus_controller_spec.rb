require 'spec_helper'

describe Goldencobra::Api::V2::NavigationMenusController, type: :controller do
  before(:each) do 
    @routes = Goldencobra::Engine.routes
    @main_menue = create :menue, target: "/", title: "Root"
  end

  describe 'with an url param' do

    it 'should return an json array of menue ids with url Params' do
      @menue_a = create :menue, target: "/news", title: "News", parent_id: @main_menue.id
      @menue_b = create :menue, target: "/news/nachricht-a", title: "Nachricht A", parent_id: @menue_a.id
      @menue_c = create :menue, target: "/newsarchiv", title: "Nachrichtenarchiv", parent_id: @menue_a.id
      
      get :active_ids, format: :json, url: "/news?de=1", id: @main_menue.id
      
      check_menue_responses(response)
    end


    it 'should return an json array of menue ids without url params' do
      @menue_a = create :menue, target: "/news", title: "News", parent_id: @main_menue.id
      @menue_b = create :menue, target: "/news/nachricht-a", title: "Nachricht A", parent_id: @menue_a.id
      @menue_c = create :menue, target: "/newsarchiv", title: "Nachrichtenarchiv", parent_id: @menue_a.id
      
      get :active_ids, format: :json, url: "/news", id: @main_menue.id
      
      check_menue_responses(response)
    end


    it 'should return an json array of menue ids with target params and without url params' do
      @menue_a = create :menue, target: "/news?en=1", title: "News", parent_id: @main_menue.id
      @menue_b = create :menue, target: "/news/nachricht-a", title: "Nachricht A", parent_id: @menue_a.id
      @menue_c = create :menue, target: "/newsarchiv", title: "Nachrichtenarchiv", parent_id: @menue_a.id
      
      get :active_ids, format: :json, url: "/news", id: @main_menue.id
      
      check_menue_responses(response)
    end


    it 'should return an json array of menue ids with target params and with url params' do
      @menue_a = create :menue, target: "/news?en=1", title: "News", parent_id: @main_menue.id
      @menue_b = create :menue, target: "/news/nachricht-a", title: "Nachricht A", parent_id: @menue_a.id
      @menue_c = create :menue, target: "/newsarchiv", title: "Nachrichtenarchiv", parent_id: @menue_a.id
      
      get :active_ids, format: :json, url: "/news?de=1", id: @main_menue.id
      
      check_menue_responses(response)
    end

  end


  private

  def check_menue_responses(response)
    menu_ids_to_show = JSON.parse(response.body)
    expect(response.status).to eq(200) 
    expect( menu_ids_to_show.include?(@menue_a.id) ).to be true
    expect( menu_ids_to_show.include?(@menue_b.id) ).to be false
    expect( menu_ids_to_show.include?(@menue_c.id) ).to be false
  end


end
