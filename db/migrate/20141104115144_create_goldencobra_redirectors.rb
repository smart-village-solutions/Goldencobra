# encoding: utf-8

class CreateGoldencobraRedirectors < ActiveRecord::Migration
  def change
    create_table :goldencobra_redirectors do |t|
      t.text :source_url
      t.text :target_url
      t.integer :redirection_code, :default => 301
      t.boolean :active, :default => true
      t.boolean :include_subdirs, :default => false
      t.boolean :ignore_url_params, :default => true

      t.timestamps
    end
  end
end
