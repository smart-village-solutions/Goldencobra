require "spec_helper"

describe Goldencobra::ArticleAdapter, type: :model do
  before do
    Goldencobra::Setting.set_value_for_key("http://www.ikusei.de", "goldencobra.url")
  end
  describe "finding articles" do
    context "by a given url" do
      it "should find one article" do
        article = create(:article, url_name: "test")
        article.run_callbacks(:commit)
        found_article_id = Goldencobra::ArticleAdapter.find(article.absolute_public_url)
        expect(found_article_id.present?).to eq(true)
      end

      it "should redirect to an other url and find this article" do
        article = create(:article, url_name: "seite-b")
        article.run_callbacks(:commit)
        Goldencobra::Redirector.create(source_url: "www.ikusei.de/seite-a",
                                       target_url: "www.ikusei.de/seite-b",
                                       ignore_url_params: true,
                                       active: true)
        found_article_id = Goldencobra::ArticleAdapter.find("http://www.ikusei.de/seite-a", follow_redirection: true)
        found_article = Goldencobra::Article.find(found_article_id)
        expect(found_article_id.present?).to eq(true)
        expect(found_article.absolute_public_url).to eq("http://www.ikusei.de/seite-b")
      end
    end
  end
end
