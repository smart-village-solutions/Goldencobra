require 'spec_helper'

describe Goldencobra::Api::V2::NavigationMenusController, type: :controller do
  before(:each) do
    @routes = Goldencobra::Engine.routes
    @main_menue = create :menue, target: "/", title: "Root"
  end

  describe "#active_ids" do
    context 'for menus without target params' do
      before do
        @menue_a = create :menue, target: "/news", title: "News", parent_id: @main_menue.id
        @menue_b = create :menue, target: "/news/nachricht-a", title: "Nachricht A", parent_id: @menue_a.id
        @menue_c = create :menue, target: "/newsarchiv", title: "Nachrichtenarchiv", parent_id: @menue_a.id
      end

      it 'should return an json array of menue ids with url Params' do
        get :active_ids, format: :json, url: "/news?de=1", id: @main_menue.id
        check_menue_responses(response)
      end

      it 'should return an json array of menue ids without url params' do
        get :active_ids, format: :json, url: "/news", id: @main_menue.id

        check_menue_responses(response)
      end

      it "should ignore trailing slashes without url params" do
        get :active_ids, format: :json, url: "/news/", id: @main_menue.id

        menu_ids = JSON.parse(response.body)

        expect(menu_ids).to eq([@main_menue.id, @menue_a.id])
      end

      it "should ignore trailing slashes with url params" do
        get :active_ids, format: :json, url: "/news/?de=1", id: @main_menue.id

        menu_ids = JSON.parse(response.body)

        expect(menu_ids).to eq([@main_menue.id, @menue_a.id])
      end
    end

    context "for menus with target params" do
      before do
        @menue_a = create :menue, target: "/news?en=1", title: "News", parent_id: @main_menue.id
        @menue_b = create :menue, target: "/news/nachricht-a", title: "Nachricht A", parent_id: @menue_a.id
        @menue_c = create :menue, target: "/newsarchiv", title: "Nachrichtenarchiv", parent_id: @menue_a.id
      end

      it 'should return an json array of menue ids without url params' do
        get :active_ids, format: :json, url: "/news", id: @main_menue.id

        check_menue_responses(response)
      end

      it 'should return an json array of menue ids with url params' do
        get :active_ids, format: :json, url: "/news?de=1", id: @main_menue.id

        check_menue_responses(response)
      end

      it "should ignore trailing slashes without url params" do
        get :active_ids, format: :json, url: "/news/", id: @main_menue.id

        menu_ids = JSON.parse(response.body)

        expect(menu_ids).to eq([@main_menue.id, @menue_a.id])
      end

      it "should ignore trailing slashes with url params" do
        get :active_ids, format: :json, url: "/news/?de=1", id: @main_menue.id

        menu_ids = JSON.parse(response.body)

        expect(menu_ids).to eq([@main_menue.id, @menue_a.id])
      end
    end

    context "if last path component has no Goldencobra::Menue entry" do
      before do
        @news     = create :menue, target: "/news",             title: "News",   parent_id: @main_menue.id
        @news2015 = create :menue, target: "/news/2015",        title: "2015",   parent_id: @news.id
        @berlin   = create :menue, target: "/news/2015/berlin", title: "Berlin", parent_id: @news2015.id
      end

      it "should return all parent ids" do
        get :active_ids, format: :json, url: "/news/2015/berlin/news-1", id: @main_menue.id

        menu_ids = JSON.parse(response.body)

        expect(menu_ids).to eq([@main_menue.id, @news.id, @news2015.id, @berlin.id])
      end

      it "should ignore trailing slashes without url params" do
        get :active_ids, format: :json, url: "/news/2015/berlin/news-1/", id: @main_menue.id

        menu_ids = JSON.parse(response.body)

        expect(menu_ids).to eq([@main_menue.id, @news.id, @news2015.id, @berlin.id])
      end

      it "should ignore trailing slashes with url params" do
        get :active_ids, format: :json, url: "/news/2015/berlin/news-1/?de=1", id: @main_menue.id

        menu_ids = JSON.parse(response.body)

        expect(menu_ids).to eq([@main_menue.id, @news.id, @news2015.id, @berlin.id])
      end
    end
  end


  private

  def check_menue_responses(response)
    menu_ids_to_show = JSON.parse(response.body)
    expect(response.status).to eq(200)
    expect(menu_ids_to_show.include?(@menue_a.id)).to be true
    expect(menu_ids_to_show.include?(@menue_b.id)).to be false
    expect(menu_ids_to_show.include?(@menue_c.id)).to be false
  end


end
