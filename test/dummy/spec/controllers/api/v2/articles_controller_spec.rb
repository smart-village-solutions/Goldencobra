require "spec_helper"

describe Goldencobra::Api::V2::ArticlesController, type: :controller do
  before(:each) { @routes = Goldencobra::Engine.routes }

  describe "POST #create" do
    context "when not logged in" do
      before do
        post :create, format: :json
      end

      it "should return a json status forbidden" do
        expect(response.response_code).to eq 403
      end
    end

    context "as a user who is logged in" do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        @user = FactoryGirl.create(:user)
        sign_in @user

        post :create, format: :json
      end

      it "should return a json status 400" do
        expect(response.response_code).to eq 400
      end
    end
  end


  describe "#update" do
    context "without an existing article" do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it "returns an error 423" do
        post :update

        expect(response.response_code).to eq(423)
      end
    end
  end
end
