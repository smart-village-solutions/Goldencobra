# encoding: utf-8

require 'spec_helper'

describe Goldencobra::ArticlesController, type: :controller do

  before(:each) { @routes = Goldencobra::Engine.routes }

  describe ".rss" do

    before(:each) do
      @article = Goldencobra::Article.create(title: "Mein Artikel", url_name: "mein-artikel")
    end

    it "should return an RSS feed" do
      get :sitemap, format: "xml"

      expect(response).to be_success
    end
  end

  describe "permissions:", type: :controller do
    render_views
    before(:each) do
      Goldencobra::Setting.import_default_settings(::Rails.root + "../../config/settings.yml")
      Goldencobra::Permission.delete_all
      @parent_article = create :article
      @child_article = create :article, parent_id: @parent_article.id
      @user = create :user
      @visitor = create :visitor
      @admin_role = create :role, name: "Admin"
      @guest_role = create :role, name: "Guest"
      @user.roles << @admin_role
      @visitor.roles << @guest_role
      @domain_access = create :domain, title: "Access"
      @domain_restricted = create :domain, title: "Restricted", hostname: "test.localhost"
    end

    context 'as an admin' do
      it "should be possible to read a secured article as a preview function" do
        create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", subject_id: @parent_article.id.to_s, :role_id => @admin_role.id, :sorter_id => 200
        sign_in(:user, @user)
        visit "#{@parent_article.public_url}?auth_token=#{@user.authentication_token}"
        expect(page).to have_content(@parent_article.title)
      end

      it "should be possible to read an article" do
        visit "/admin/logout"
        sign_in(:user, @user)
        visit "#{@parent_article.public_url}?auth_token=#{@user.authentication_token}"
        expect(page).to have_content(@parent_article.title)
      end

      it 'should return 404 if no article is found' do
        sign_in(:user, @user)
        visit "/no_article?auth_token=#{@user.authentication_token}"
        expect(page).to have_content('404')
      end
    end

    context 'as a visitor' do
      it "should be possible to read an article" do
        sign_in(:visitor, @visitor)
        visit @parent_article.public_url
        expect(page).to have_content(@parent_article.title)
      end

      it "should not be possible to read a secured article as a visitor" do
        create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", :sorter_id => 200, :subject_id => @parent_article.id
        sign_in(:visitor, @visitor)
        visit @parent_article.public_url
        expect(page).to have_content("Nicht authorisiert")
      end

      it "should not be possible to read a secured article for a domain if i am on this domain" do
        create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", :sorter_id => 200, :subject_id => @parent_article.id, :domain_id => @domain_access.id
        sign_in(:visitor, @visitor)
        visit @parent_article.public_url
        expect(page).to have_content("Nicht authorisiert")
      end

      it "should be possible to read a secured article for a domain if it's locked for another domain" do
        create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", :sorter_id => 200, :subject_id => @parent_article.id, :domain_id => @domain_restricted.id
        sign_in(:visitor, @visitor)
        visit @parent_article.public_url
        expect(page).to have_content(@parent_article.title)
      end

      it "should not be possible to read a secured article for a domain if I am on this domain with a role" do
        create :permission, action: "not_read", subject_class: "Goldencobra::Article", sorter_id: 200, subject_id: @parent_article.id, domain_id: @domain_access.id, role_id: @guest_role.id
        sign_in(:visitor, @visitor)
        visit @parent_article.public_url
        # expect(page).to have_content("Nicht authorisiert")
      end

      it "should be possible to read a secured article for a domain if it's locked for another domain with a role" do
        create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", :sorter_id => 200, :subject_id => @parent_article.id, :domain_id => @domain_restricted.id, :role_id => @guest_role.id
        sign_in(:visitor, @visitor)
        visit @parent_article.public_url
        expect(page).to have_content(@parent_article.title)
      end

      it "should not be possible to read a secured article" do
        create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", :sorter_id => 200, :subject_id => @parent_article.id, :role_id => @guest_role.id
        expect(Goldencobra::Permission.last.subject_class.include?(":all")).to eq false
        a = Ability.new(@visitor)
        expect(a.can?(:read, @parent_article)).to eq false
        expect(a.cannot?(:read, @parent_article)).to eq true
        visit "#{@parent_article.public_url}?auth_token=#{@visitor.authentication_token}"
        expect(page).to have_content("Nicht authorisiert")
      end

      it "should not be possible to read an article with secured parent article" do
        sign_in(:visitor, @visitor)
        create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", :role_id => @guest_role.id, :sorter_id => 200, :subject_id => @parent_article.id
        visit "#{@child_article.public_url}?auth_token=#{@visitor.authentication_token}"
        expect(page).to have_content("Nicht authorisiert")
      end

      it 'should return 404 if no article is found' do
        sign_in(:visitor, @visitor)
        visit "/no_article?auth_token=#{@visitor.authentication_token}"
        expect(page).to have_content('404')
      end
    end

    context 'as a guest or not logged in' do
      it "should be possible to read an article" do
        visit @parent_article.public_url
        expect(page).to have_content(@parent_article.title)
      end

      it "should not be possible to read a secured article" do
        create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", :sorter_id => 200, :subject_id => @parent_article.id
        visit @parent_article.public_url
        expect(page).to have_content("Nicht authorisiert")
      end

      it "should not be possible to read an article with secured parent article" do
        create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", :sorter_id => 200, :subject_id => @parent_article.id
        visit "#{@child_article.public_url}"
        expect(page).to have_content("Nicht authorisiert")
      end

      it "should not be possible to read all articles" do
        create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", :sorter_id => 200
        visit @parent_article.public_url
        expect(page).to have_content("Nicht authorisiert")
      end

      it 'should return 404 if no article is found' do
        visit "/no_article"
        expect(page).to have_content('404')
      end

      it "should not be possible to read a secured article for a domain if i am on this domain" do
        create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", :sorter_id => 200, :subject_id => @parent_article.id, :domain_id => @domain_access.id
        visit @parent_article.public_url
        expect(page).to have_content("Nicht authorisiert")
      end

      it "should be possible to read a secured article for a domain if it's locked for another domain" do
        create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", :sorter_id => 200, :subject_id => @parent_article.id, :domain_id => @domain_restricted.id
        visit @parent_article.public_url
        expect(page).to have_content(@parent_article.title)
      end
    end


    context 'an RSS feed with protected documents' do
      before do
        @ra = create :article, title: 'Root Article', content: 'Test Inhalt', url_name: 'root-article', article_type: 'Default Index'
        5.times do |i|
          create :article, title: "Child Article #{i+1}", parent_id: @ra.id, url_name: "child-article-#{i+1}"
        end
      end

      context 'when not logged in' do
        it 'should be possible to read the root article as rss' do
          art = Goldencobra::Article.where(title: 'Root Article').first
          visit "#{art.public_url}.rss"
          expect(response).to be_success
        end

        it 'should not be possible to view a restricted article as rss' do
          art = Goldencobra::Article.where(url_name: "child-article-2").first
          create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", :sorter_id => 200, :subject_id => art.id
          visit "#{art.public_url}.rss"

          expect(page).to_not have_content('Child Article 2')
          expect(page).to have_content('Nicht authorisiert')
        end

        it "should give a reduced rss feed" do
          child2 = Goldencobra::Article.where(url_name: "child-article-2").first
          create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", :sorter_id => 200, :subject_id => child2.id
          art = Goldencobra::Article.where(title: 'Root Article').first

          visit "#{art.public_url}.rss"

          expect(page).to have_content('Root Article')
          expect(page).to have_content('Child Article 1')
          expect(page).to_not have_content('Child Article 2')
        end

        context 'providing an auth_token' do
          it "should give a complete rss feed if the token is correct" do
            child2 = Goldencobra::Article.where(url_name: "child-article-2").first
            create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", :sorter_id => 200, :subject_id => child2.id
            create :permission, :action => "read", :subject_class => "Goldencobra::Article", :sorter_id => 220, :subject_id => child2.id, role_id: @guest_role.id
            art = Goldencobra::Article.where(title: 'Root Article').first
            token = Visitor.last.authentication_token

            visit "#{art.public_url}.rss?auth_token=#{token}"

            expect(page).to have_content('Root Article')
            expect(page).to have_content('Child Article 1')
            expect(page).to have_content('Child Article 2')
          end

          it "should respond with '401-Nicht authorisiert' if the token is incorrect" do
            child2 = Goldencobra::Article.where(url_name: "child-article-2").first
            create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", :sorter_id => 200, :subject_id => child2.id
            create :permission, :action => "read", :subject_class => "Goldencobra::Article", :sorter_id => 220, :subject_id => child2.id, role_id: @guest_role.id
            art = Goldencobra::Article.where(title: 'Root Article').first

            visit "#{art.public_url}.rss?auth_token=123abc"

            expect(page).to have_content('Nicht authorisiert')
          end
        end
      end

      context 'when logged in as a visitor' do
        it 'should be possible to read the root article as rss' do
          art = Goldencobra::Article.where(title: 'Root Article').first
          visit "#{art.public_url}.rss"
          expect(response).to be_success
        end

        it "should give a complete rss feed" do
          child2 = Goldencobra::Article.where(url_name: "child-article-2").first
          create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", :sorter_id => 200, :subject_id => child2.id
          create :permission, :action => "read", :subject_class => "Goldencobra::Article", :sorter_id => 220, :subject_id => child2.id, role_id: @guest_role.id
          art = Goldencobra::Article.where(title: 'Root Article').first

          visit "#{art.public_url}.rss?auth_token=#{@visitor.authentication_token}"

          expect(page).to have_content('Root Article')
          expect(page).to have_content('Child Article 1')
          expect(page).to have_content('Child Article 2')
        end
      end

      context 'when logged in as a admin' do
        it "should give a complete rss feed" do
          sign_in(:user, @user)
          child2 = Goldencobra::Article.where(url_name: "child-article-2").first
          create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", :sorter_id => 200, :subject_id => child2.id
          create :permission, :action => "read", :subject_class => "Goldencobra::Article", :sorter_id => 220, :subject_id => child2.id, role_id: @guest_role.id
          art = Goldencobra::Article.where(title: 'Root Article').first

          visit "#{art.public_url}.rss?auth_token=#{@user.authentication_token}"

          expect(page).to have_content('Root Article')
          expect(page).to have_content('Child Article 1')
          expect(page).to have_content('Child Article 2')
        end
      end
    end
  end

  describe "#show" do
    it "renders 406 if request.format is php" do
      get :show, { format: :php }

      expect(response.status).to eq(406)
    end

    context "with a valid format" do
      before do
        Goldencobra::Article.create(title: "Mein Artikel", url_name: "mein-artikel")
      end

      it "accepts .html" do
        visit "/mein-artikel"

        expect(response.status).to eq(200)
      end

      it "accepts .json" do
        visit "/mein-artikel.json"

        expect(response.status).to eq(200)
      end

      it "accepts .json" do
        visit "/mein-artikel.rss"

        expect(response.status).to eq(200)
      end
    end
  end
end
