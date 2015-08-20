class ChangeMetatagStorage < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :metatag_title_tag, :string
    add_column :goldencobra_articles, :metatag_meta_description, :string
    add_column :goldencobra_articles, :metatag_open_graph_title, :string
    add_column :goldencobra_articles, :metatag_open_graph_description, :string
    add_column :goldencobra_articles, :metatag_open_graph_type, :string, :default => "website"
    add_column :goldencobra_articles, :metatag_open_graph_url, :string
    add_column :goldencobra_articles, :metatag_open_graph_image, :string

    drop_table :goldencobra_metatags
  end
end
