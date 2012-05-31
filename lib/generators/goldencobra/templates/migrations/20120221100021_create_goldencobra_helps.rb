class CreateGoldencobraHelps < ActiveRecord::Migration
  def change
    create_table :goldencobra_helps do |t|
      t.string :title
      t.text :description
      t.string :url

      t.timestamps
    end
    Goldencobra::Help.create!(:title => "Goldencobra", :description => "https://github.com/ikusei/Goldencobra")
    
  end
end
