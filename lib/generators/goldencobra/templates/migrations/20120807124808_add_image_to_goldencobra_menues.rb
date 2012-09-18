class AddImageToGoldencobraMenues < ActiveRecord::Migration
  def change
    add_column :goldencobra_menues, :image_id, :integer
  end
end
