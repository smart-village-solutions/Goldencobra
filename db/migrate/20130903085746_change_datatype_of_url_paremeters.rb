class ChangeDatatypeOfUrlParemeters < ActiveRecord::Migration
  def up
  	change_column :goldencobra_trackings, :url_paremeters, :text
  end

  def down
  	change_column :goldencobra_trackings, :url_paremeters, :string
  end
end
