require "spec_helper"

describe Goldencobra::ArticleUrl, type: :model do
  before do
    Goldencobra::Setting.set_value_for_key("http://www.ikusei.de", "goldencobra.url")
    Goldencobra::Setting.set_value_for_key("false", "goldencobra.use_ssl")
  end

  describe "creating or updating an goldencobra article" do
    context "style of an article url" do
      before do
        @article = create(:article, url_name: "SeiteA")
        @article.run_callbacks(:commit)
      end
      it "should have no trailing '/'" do
        @article.urls.each do |au|
          expect(au.url.last).not_to eq("/")
        end
      end

      it "should start with http" do
        @article.urls.each do |au|
          expect(au.url.start_with?("http://")).to eq(true)
        end
      end

      it "should start with https" do
        Goldencobra::Setting.set_value_for_key("https://www.ikusei.de", "goldencobra.url")
        Goldencobra::Setting.set_value_for_key("true", "goldencobra.use_ssl")
        article = create(:article, url_name: "SeiteA")
        article.run_callbacks(:commit)
        article.urls.each do |au|
          expect(au.url.start_with?("https://")).to eq(true)
        end
      end

      it "should be downcased" do
        @article.urls.each do |au|
          expect(au.url.downcase == au.url).to eq(true)
        end
      end
    end

    context "domains are note used" do
      it "should create an article url" do
        article = create(:article, url_name: "SeiteA")
        article.run_callbacks(:commit)

        expect(article.urls.count).to eq(1)

        article_url = article.urls.first
        expect(article_url.url).to eq(article.absolute_public_url.downcase)
      end

      it "should update an article url" do
        article = create(:article, url_name: "SeiteA")
        article.run_callbacks(:commit)
        article.url_name = "SeiteB"
        article.save
        article.run_callbacks(:commit)

        expect(article.urls.count).to eq(1)

        article_url = article.urls.first
        expect(article_url.url).to eq(article.absolute_public_url.downcase)
        expect(article_url.url.include?("seiteb")).to eq(true)
      end

      it "should destroy an article url" do
        article = create(:article, url_name: "SeiteA")
        article.run_callbacks(:commit)
        article.destroy
        article.run_callbacks(:commit)

        expect(Goldencobra::ArticleUrl.all.count).to eq(0)
      end

      it "should have only 1 article url" do
        article = create(:article, url_name: "SeiteA")
        article.run_callbacks(:commit)
        expect(Goldencobra::ArticleUrl.all.count).to eq(1)
      end

      it "should have a / für a startpagearticle" do
        root_article = create(:article, url_name: "start")
        root_article.mark_as_startpage!
        root_article.run_callbacks(:commit)
        url_of_root = Goldencobra::ArticleUrl.where(article_id: root_article.id).first.url
        expect(url_of_root).to eq("http://www.ikusei.de/")
      end

      it "should update an children article url if a parent if modified" do
        root_article = create(:article, url_name: "start")
        root_article.run_callbacks(:commit)
        child_1 = create(:article, url_name: "child-1", parent_id: root_article.id)
        child_1.run_callbacks(:commit)
        child_2 = create(:article, url_name: "child-2", parent_id: child_1.id)
        child_2.run_callbacks(:commit)

        expect(Goldencobra::ArticleUrl.all.count).to eq(3)

        url_of_child_2 = Goldencobra::ArticleUrl.where(article_id: child_2.id).first.url
        expect(url_of_child_2).to eq("http://www.ikusei.de/start/child-1/child-2")

        # Modify root article and child_2 should be changed
        root_article.url_name = "new_start"
        root_article.save
        root_article.run_callbacks(:commit)
        url_of_child_2 = Goldencobra::ArticleUrl.where(article_id: child_2.id).first.url
        expect(url_of_child_2).to eq("http://www.ikusei.de/new_start/child-1/child-2")
      end

    end

    context "there are 2 domains in use" do
      before do
        @domain_a = create(:domain, title: "Ikusei", hostname: "www.ikusei.de")
        @domain_b = create(:domain, title: "Customer", hostname: "www.customer.de", main: false, url_prefix: "/subdir")
      end
      it "should create 2 article urls" do
        article = create(:article, url_name: "seite-a")
        article.run_callbacks(:commit)

        expect(article.urls.count).to eq(2)
        domain_a_urls = Goldencobra::ArticleUrl.where(url: "http://www.ikusei.de/seite-a")
        domain_b_urls = Goldencobra::ArticleUrl.where(url: "http://www.customer.de/subdir/seite-a")

        expect(domain_a_urls.count).to eq(1)
        expect(domain_b_urls.count).to eq(1)
      end

      it "should update 2 article url2" do
        article = create(:article, url_name: "seite-a")
        article.run_callbacks(:commit)
        article.url_name = "seite-b"
        article.save
        article.run_callbacks(:commit)

        expect(article.urls.count).to eq(2)
        domain_a_urls = Goldencobra::ArticleUrl.where(url: "http://www.ikusei.de/seite-b")
        domain_b_urls = Goldencobra::ArticleUrl.where(url: "http://www.customer.de/subdir/seite-b")

        expect(domain_a_urls.count).to eq(1)
        expect(domain_b_urls.count).to eq(1)
      end

      it "should destroy 2 article url" do
        article = create(:article, url_name: "seite-a")
        article.run_callbacks(:commit)
        article.destroy
        article.run_callbacks(:commit)

        expect(Goldencobra::ArticleUrl.all.count).to eq(0)
      end

      it "should have 2 article urls" do
        article = create(:article, url_name: "SeiteA")
        article.run_callbacks(:commit)
        expect(Goldencobra::ArticleUrl.all.count).to eq(2)
      end
    end
  end
end
