# encoding: utf-8

class AddTaggingcounter < ActiveRecord::Migration
  def up
    unless column_exists? :tags, :taggings_count
      add_column :tags, :taggings_count, :integer
    end
  end

  def down
    if column_exists? :tags, :taggings_count
      remove_column :tags, :taggings_count
    end
  end
end
