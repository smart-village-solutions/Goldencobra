require "spec_helper"

describe Goldencobra::ArticlesHelper, type: :helper do
  describe "#render_article_image_gallery" do
    it "returns nil if article is not present" do
      expect(helper.render_article_image_gallery).to eq nil
    end

    it "returns article's image gallery" do
      assign(:article, build(:article))
      upload = Goldencobra::Upload.create
      upload.save
      expect(helper.render_article_image_gallery).to eq("<ul class=\"goldencobra_article_image_gallery\"></ul>")
    end

    it "returns article's image gallery with tags if tags are present" do
      assign(:article, build(:article, image_gallery_tags: "foo-tag"))
      upload = Goldencobra::Upload.create
      upload.tag_list.add("foo-tag")
      upload.save
      expect(helper.render_article_image_gallery).to eq("<ul class=\"goldencobra_article_image_gallery\"><li><a title=\"\" href=\"missing_large.png\"><img src=\"/images/missing_thumb.png\" /></a></li></ul>")
    end

    it "returns article's image gallery with specified image sizes" do
      assign(:article, build(:article, image_gallery_tags: "foo-tag"))
      upload = Goldencobra::Upload.create
      upload.tag_list.add("foo-tag")
      upload.save
      expect(helper.render_article_image_gallery(link_image_size: :medium, target_image_size: :medium)).to eq("<ul class=\"goldencobra_article_image_gallery\"><li><a title=\"\" href=\"missing_medium.png\"><img src=\"/images/missing_medium.png\" /></a></li></ul>")
    end
  end
end
