require 'spec_helper'
require 'faker'

describe Goldencobra::ListOfArticles do
  before do
    @article = create :article
    create_sub_articles
  end

  describe 'sort order' do
    it 'sorts the list alphabetically' do
      @article.sort_order = 'Alphabetical'
      @article.save
      sorted_list_of_articles = get_list.flatten.sort_by{|art| art.title }

      expect(sorted_list_of_articles).to eq(get_list)
    end

    it 'sorts the list by created_at' do
      @article.sort_order = 'Created_at'
      @article.save
      sorted_list_of_articles = get_list.flatten.sort_by{|art| art.created_at.to_i }

      expect(sorted_list_of_articles).to eq(get_list)
    end

    it 'sorts the list randomly' do
      @article.sort_order = 'Random'
      @article.save
      
      sorted_by_date = get_list.flatten.sort_by{|art| art.created_at.to_i }
      sorted_by_title = get_list.flatten.sort_by{|art| art.title }
      sorted_by_id = get_list.flatten.sort_by{ |art| art.id }

      @list_of_articles = get_list
      expect(@list_of_articles).to_not eq(sorted_by_date)
      expect(@list_of_articles).to_not eq(sorted_by_title)
      expect(@list_of_articles).to_not eq(sorted_by_id)
    end

    it 'sorts the list by article.attributes' do
      @article.sort_order = 'title'
      @article.save
      sorted_list_of_articles = get_list.flatten.sort_by{|art| art.title }

      expect(sorted_list_of_articles).to eq(get_list)
    end
  end

  private
  def create_sub_articles
    5.times do |i|
      create :article, article_for_index_id: @article.id, parent: @article, title: Faker::Lorem.sentence
      sleep 1
    end
  end
  
  def get_list
    Goldencobra::ListOfArticles.new(@article).to_a
  end
end
