require 'spec_helper'

describe Goldencobra::UrlBuilder do

  describe '#article_path' do

    context 'without prefix' do

      it 'returns / for a startpage' do
        article = build_stubbed :article, startpage: true
        builder  = Goldencobra::UrlBuilder.new(article, false)

        url = builder.article_path

        expect(url).to eq('/')
      end

      it 'returns the ancestry for an normal article' do
        article = create :article, url_name: 'first'
        child = create :article, ancestry: article.id, url_name: 'second'
        grandson = create :article, ancestry: "#{article.id}/#{child.id}", url_name: 'third'
        builder  = Goldencobra::UrlBuilder.new(grandson, false)

        url = builder.article_path
        
        expect(url).to eq('first/second/third/')
      end

    end

    context 'with prefix' do
      
      before(:each) do
        Goldencobra::Domain.stub_chain(:current, :url_prefix).and_return('http://foo.bar')
      end

      it 'returns / for a startpage' do
        article = build_stubbed :article, startpage: true
        builder  = Goldencobra::UrlBuilder.new(article, true)

        url = builder.article_path

        expect(url).to eq('http://foo.bar/')
      end

      it 'returns the ancestry for an normal article' do
        article = create :article, url_name: 'first'
        child = create :article, ancestry: article.id, url_name: 'second'
        grandson = create :article, ancestry: "#{article.id}/#{child.id}", url_name: 'third'
        builder  = Goldencobra::UrlBuilder.new(grandson, true)

        url = builder.article_path
        
        expect(url).to eq('http://foo.bar/first/second/third/')
      end

    end

  end
  
end