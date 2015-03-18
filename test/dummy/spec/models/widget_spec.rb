# encoding: utf-8

require 'spec_helper'

describe Goldencobra::Widget do

  # it "should update article cache of active articles" do
  #   active_article = Goldencobra::Article.create(:title => "Testseite", :active => true)
  #   sleep(1)
  #   widget = Goldencobra::Widget.create(:title => "Startseite", :content => "/", :active => true)
  #   regenerated_article = Goldencobra::Article.find_by_title("Testseite")
  #   regenerated_article.updated_at.to_f.should be > active_article.updated_at.to_f
  # end

  describe "#duplicate" do
    it "creates a new Widget and duplicates content, and other attributes" do
      @widget_one = Goldencobra::Widget.create(
        title: "Mein Widget",
        content: "Das ist mein Content",
        css_name: "hidden klasse-1 klasse-2",
        active: true,
        id_name: "mein-widget",
        sorter: 23,
        mobile_content: "Das ist der mobile Inhalt",
        default: true,
        description: "Dies ist der Beschreibungstext",
        offline_days: "Test",
        offline_time_active: false,
        alternative_content: "Alternativer Content",
        offline_date_start: nil,
        offline_date_end: nil,
        teaser: "Teaser Content"
      )

      duplicated_widget_id = @widget_one.duplicate!
      dup_widget = Goldencobra::Widget.find(duplicated_widget_id)
      dup_attrs = dup_widget.attributes.delete_if{ |a| %w(created_at updated_at).include?(a) }

      expect(duplicated_widget_id).to eq(Goldencobra::Widget.last.id)
      expect(Goldencobra::Widget.count).to eq(2)
      expect(dup_attrs).to eq(dupl_attributes.merge!({ "id" => duplicated_widget_id}))
    end
  end

  private

  def dupl_attributes
    {
      "title" => "Mein Widget (Kopie)",
      "content" => "Das ist mein Content",
      "css_name" => "hidden klasse-1 klasse-2",
      "active" => false,
      "id_name" => "mein-widget-kopie",
      "sorter" => 23,
      "mobile_content" => "Das ist der mobile Inhalt",
      "default" => false,
      "description" => "Dies ist der Beschreibungstext",
      "offline_days" => "Test",
      "offline_time_active" => false,
      "alternative_content" => "Alternativer Content",
      "offline_date_start" => nil,
      "offline_date_end" => nil,
      "offline_time_week_start_end" => {},
      "teaser" => "Teaser Content"
    }
  end
end
