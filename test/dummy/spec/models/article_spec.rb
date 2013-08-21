require 'spec_helper'

describe Goldencobra::Article do

  describe 'creating an article' do
    before(:each) do
      @attr = { :title  => "Testartikel", :url_name  => "testartikel", :article_type => "Default Show" }
    end

    it "should have a valid redirect url by inserting an url without http" do
      a = Goldencobra::Article.create!(@attr)
      a.external_url_redirect = "www.google.de"
      a.save
      Goldencobra::Article.find_by_id(a.id).external_url_redirect.should == "http://www.google.de"
    end

    it "should have a valid redirect url by inserting an url with http" do
      a = Goldencobra::Article.create!(@attr)
      a.external_url_redirect = "http://www.google.de"
      a.save
      Goldencobra::Article.find_by_id(a.id).external_url_redirect.should == "http://www.google.de"
    end

    it "should create a new article given valid attributes" do
      Goldencobra::Article.create!(@attr)
    end

    it "should set active_since to the created_at datetime" do
      article = create :article
      article.active_since.should eql(article.created_at)
    end

    it "should require a title" do
      no_name_article = Goldencobra::Article.new(@attr.merge(:title => ""))
      no_name_article.should_not be_valid
    end

    it "should not require a url_name because it is filled automatically" do
      no_url_name_article = Goldencobra::Article.new(@attr.merge(:url_name => ""))
      no_url_name_article.should be_valid
    end

    it "should not display partial in templatefiles" do
      File.new("#{::Rails.root}/app/views/layouts/tim_test.html.erb", "w")
      File.new("#{::Rails.root}/app/views/layouts/_partial.html.erb", "w")
      File.new("#{::Rails.root}/app/views/layouts/_partial_2.html.erb", "w")
      File.new("#{::Rails.root}/app/views/layouts/12layout.html.erb", "w")

      Goldencobra::Article.templates_for_select.include?("tim_test").should == true
      Goldencobra::Article.templates_for_select.include?("_partial").should == false
      Goldencobra::Article.templates_for_select.include?("_partial_2").should == false
      Goldencobra::Article.templates_for_select.include?("application").should == true
      Goldencobra::Article.templates_for_select.include?("12layout").should == true

      File.delete("#{::Rails.root}/app/views/layouts/tim_test.html.erb")
      File.delete("#{::Rails.root}/app/views/layouts/_partial.html.erb")
      File.delete("#{::Rails.root}/app/views/layouts/_partial_2.html.erb")
      File.delete("#{::Rails.root}/app/views/layouts/12layout.html.erb")
    end

    it "should return a list of 5 last modified articles" do
      Goldencobra::Article.create(title: "Blah", :article_type => "Default Show")
      Goldencobra::Article.create(title: "Blah2", :article_type => "Default Show")
      Goldencobra::Article.create(title: "Blah3", :article_type => "Default Show")
      Goldencobra::Article.create(title: "Blah4", :article_type => "Default Show")
      Goldencobra::Article.create(title: "Blah5", :article_type => "Default Show")
      Goldencobra::Article.recent(5).collect.count.should == 5
    end
  end

  describe 'open graph' do
    it 'should have some metatags' do
      article = create :article
      article.metatags.count.should > 0
    end

    it "should set a default open graph title" do
      article = create :article
      Goldencobra::Metatag.where(name: 'OpenGraph Title', article_id: article.id).count.should == 1
    end

    it "should match the article's title" do
      article = create :article
      Goldencobra::Metatag.where(name: 'OpenGraph Title',
                                 article_id: article.id).first.value.should == article.title
    end

    it "should set a default OG url if none exists" do
      article = create :article
      Goldencobra::Metatag.where(name: 'OpenGraph URL', article_id: article.id).count.should == 1
    end

    it "should match the artices url" do
      article = create :article
      Goldencobra::Metatag.where(name: 'OpenGraph URL',
                                 article_id: article.id).first.value.should == article.absolute_public_url
    end

    it "should should set a default OG description" do
      article = create :article
      Goldencobra::Metatag.where(name: 'OpenGraph Description',
                                 article_id: article.id).count.should == 1
    end

    it "should match the article's teaser text" do
      article = create :article, teaser: 'Das ist ein kurzer Teaser Text.'
      Goldencobra::Metatag.where(name: 'OpenGraph Description',
                                 article_id: article.id).first.value.should == article.teaser
    end

    it "should match the article's content text if teaser is empty" do
      article = create :article, content: 'Sed ut perspiciatis unde omnis iste natus' +
      'error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ' +
      'ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.'
      Goldencobra::Metatag.where(name: 'OpenGraph Description',
                                 article_id: article.id).first.value.should == article.content.truncate(200)
    end

    it "should match the article's title if neither teaser nor content present" do
      article = create :article
      Goldencobra::Metatag.where(name: 'OpenGraph Description',
                                 article_id: article.id).first.value.should == article.title
    end

    # it "should use the articles image as OpenGraph Image" do
    #   @article = create :article
    #   upload = Goldencobra::Upload.create(image: File.new(fixture_file("50x50.png"), "rb"))
    #   ai = Goldencobra::ArticleImage.create(article_id: @article.id, image_id: upload.id)
    #   @article.save
    #   puts "...#{@article.article_images}.."
    #   Goldencobra::Metatag.where(name: 'OpenGraph Image',
    #                              article_id: @article.id).first.value.should == @article.article_images.first.image.image.url
    # end
  end

  context 'index articles' do
    before do
      @article = create :article
      @list_of_articles = []
      5.times do
        @list_of_articles << (create :article, article_for_index_id: @article.id, parent: @article)
      end
    end

    it 'should have a parent article' do
      expect(Goldencobra::Article.last.index_articles).to eq(@list_of_articles)
    end
  end

  context 'related object' do
    it 'should return a proper published_at' do
      @article = create :article
      expect(@article.published_at).to eq(@article.created_at)
    end
  end

  context 'template file' do
    it 'returns application if blank' do
      @article = create :article
      expect(@article.selected_layout).to eq('application')
    end

    it 'returns a template file if present' do
      @article = create :article, template_file: 'my_template_file'
      expect(@article.selected_layout).to eq('my_template_file')
    end
  end

  context 'breadcrumb name' do
    it 'returns a breadcrumb name if present' do
      article = create :article, breadcrumb: 'my-breadcrumb', title: 'awesome title'
      expect(article.breadcrumb_name).to eq('my-breadcrumb')
    end

    it "returns the article's title if no breadcrumb given" do
      article = create :article, title: 'awesome title'
      expect(article.breadcrumb_name).to eq('awesome title')
    end
  end

  context 'public teaser' do
    it 'returns teaser if present' do
      article = create :article, teaser: 'my-teaser', content: "a"*230, summary: 'my-summary'
      expect(article.public_teaser).to eq('my-teaser')
    end

    it 'returns summary if present and teaser blank' do
      article = create :article, summary: 'my-summary', content: "a"*230
      expect(article.public_teaser).to eq('my-summary')
    end

    it 'returns the first 200 chars of content if neither is given' do
      article = create :article, content: "a"*230
      expect(article.public_teaser).to eq("a"*200)
    end
  end

  context 'for friendly name' do
    it 'returns the url name if present' do
      article = create :article, url_name: 'my-url-name'
      expect(article.for_friendly_name).to eq('my-url-name')
    end

    it 'returns the title if url name is blank' do
      article = create :article, url_name: ''
      expect(article.for_friendly_name).to eq(article.title.parameterize)
    end
  end
end
