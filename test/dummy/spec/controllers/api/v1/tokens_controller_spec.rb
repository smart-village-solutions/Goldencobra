# encoding: utf-8

require 'spec_helper'

describe Goldencobra::Api::V1::TokensController, type: :controller do

  before(:each) { @routes = Goldencobra::Engine.routes }

  describe '#create', :type => :controller do
    it 'should require an email and password' do
      post :create, format: :json
      expect(response.response_code).to eq 400
    end

    before do
      @visitor = Visitor.create(email: 'john.doe@foo.bar',
                                password: '123456',
                                password_confirmation: '123456',
                                agb: true)
    end

    it "should return a user token given correct credentials" do
      token_to_json = { token: @visitor.authentication_token }.to_json

      post :create, format: :json, email: 'john.doe@foo.bar', password: '123456'
      expect(response.body).to eq token_to_json
    end

    it 'should render a 401 if password is wrong' do
      post :create, format: :json, email: 'john.doe@foo.bar', password: '12345'
      expect(response.response_code).to eq 401
    end

    it 'should render a 401 if email is wrong' do
      post :create, format: :json, email: 'john@foo.bar', password: '123456'
      expect(response.response_code).to eq 401
    end
  end
end
