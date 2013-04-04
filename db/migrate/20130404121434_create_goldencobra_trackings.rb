class CreateGoldencobraTrackings < ActiveRecord::Migration
  def change
    create_table :goldencobra_trackings do |t|
      t.text :request
      t.string :session_id
      t.string :referer
      t.string :url
      t.string :ip

      t.timestamps
    end
  end
end
