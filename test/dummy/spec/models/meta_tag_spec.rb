# encoding: utf-8

require "spec_helper"

describe Goldencobra::ArticleConcerns::MetaTag do
  it "should return breadcrumb as meta_title" do
    article = create(:article, breadcrumb: "breadcrumb")
    article.update_columns(metatag_title_tag: nil)
    expect(article.send(:get_meta_value, :metatag_title_tag, :breadcrumb, :title)).to eq("breadcrumb")
  end

  it "should return title as meta_title" do
    article = create(:article, title: "title", breadcrumb: "breadcrumb")
    expect(article.send(:get_meta_value, :title, :breadcrumb)).to eq("title")
  end

  it "should return breadcrumb as meta_title" do
    article = create(:article, title: "title", breadcrumb: "breadcrumb")
    expect(article.send(:get_meta_value, :breadcrumb, :title)).to eq("breadcrumb")
  end

  it "sould have meta tags" do
    Goldencobra::Setting.set_value_for_key("Custom Title Tag", "goldencobra.page.default_title_tag")
    Goldencobra::Setting.set_value_for_key("www.yourdomain.com", "goldencobra.url")
    Goldencobra::Setting.set_value_for_key("image_url", "goldencobra.facebook.opengraph_default_image")
    custom_tag_settings = Goldencobra::Setting.where(title: "custom_tags").first
    Goldencobra::Setting.create(title: "foo", value: "bar", parent_id: custom_tag_settings.id)
    article = create(:article, teaser: "Dies ist ein Teaser")

    expect(article.meta_tag_site).to eq("Custom Title Tag")
    expect(article.meta_tag_title_tag).to eq("Article's breadcrumb title")
    expect(article.meta_tag_meta_description).to eq("Dies ist ein Teaser")
    expect(article.meta_tag_open_graph_title).to eq("Article's breadcrumb title")
    expect(article.meta_tag_open_graph_description).to eq("Dies ist ein Teaser")
    expect(article.meta_tag_open_graph_type).to eq("website")
    expect(article.meta_tag_open_graph_url).to eq("http://www.yourdomain.com/short-title")
    expect(article.meta_tag_open_graph_image).to eq("image_url")
    expect(article.meta_tag_canonical_url).to eq("http://www.yourdomain.com/short-title")
    expect(article.meta_tag_static_custom[:foo]).to eq("bar")
  end
end
