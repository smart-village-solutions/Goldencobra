require "spec_helper"

describe Goldencobra::ArticleAdapter, type: :model do
  before do
    Goldencobra::Setting.set_value_for_key("http://www.ikusei.de", "goldencobra.url")
  end
  describe "finding articles" do
    context "by a given url" do
      it "should find one article id" do
        article = create(:article, url_name: "test")
        article.run_callbacks(:commit)
        found_article_id = Goldencobra::ArticleAdapter.find(article.absolute_public_url)
        expect(found_article_id.present?).to eq(true)
      end

      it "should find the startpage with trailing Slash" do
        article = create(:article, url_name: "test")
        article.run_callbacks(:commit)
        article.mark_as_startpage!
        article.run_callbacks(:commit)
        found_article_id = Goldencobra::ArticleAdapter.find("http://www.ikusei.de/")
        expect(found_article_id.present?).to eq(true)
      end

      it "should find the startpage without trailing Slash" do
        article = create(:article, url_name: "test")
        article.run_callbacks(:commit)
        article.mark_as_startpage!
        article.run_callbacks(:commit)
        found_article_id = Goldencobra::ArticleAdapter.find("http://www.ikusei.de")
        expect(found_article_id.present?).to eq(true)
      end

      it "should find no article id" do
        article = create(:article, url_name: "test")
        article.run_callbacks(:commit)
        found_article_id = Goldencobra::ArticleAdapter.find("")
        expect(found_article_id).to eq(nil)
      end

      it "should find a list of urls by a given article_id" do
        article = create(:article, url_name: "test")
        article.run_callbacks(:commit)
        found_article_urls = Goldencobra::ArticleAdapter.find_url_by_id(article.id)
        expect(found_article_urls.count).to eq(1)
        expect(found_article_urls.first).to eq("http://www.ikusei.de/test")
      end

      it "should redirect to an other url and find this article" do
        article = create(:article, url_name: "seite-b")
        article.run_callbacks(:commit)
        Goldencobra::Redirector.create(source_url: "www.ikusei.de/seite-a",
                                       target_url: "www.ikusei.de/seite-b",
                                       active: true)
        found_article_id = Goldencobra::ArticleAdapter.find("http://www.ikusei.de/seite-a", follow_redirection: true)
        found_article = Goldencobra::Article.find(found_article_id)
        expect(found_article_id.present?).to eq(true)
        expect(found_article.absolute_public_url).to eq("http://www.ikusei.de/seite-b")
      end

      it "should find a Goldencobra::Article by a given id" do
        article = create(:article, url_name: "seite-b")
        found_article = Goldencobra::ArticleAdapter.find_by_id(article.id)
        expect(found_article.present?).to eq(true)
        expect(found_article.id).to eq(article.id)
      end
    end
  end
end
