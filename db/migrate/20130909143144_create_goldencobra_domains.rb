class CreateGoldencobraDomains < ActiveRecord::Migration
  def change
    create_table :goldencobra_domains do |t|
      t.string :hostname
      t.string :title
      t.string :client

      t.timestamps
    end
  end
end
