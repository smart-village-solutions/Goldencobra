class AddCacheToGoldencobraMenues < ActiveRecord::Migration
  def up
  	add_column :goldencobra_menues, :ancestry_depth, :integer, :default => 0
  	Goldencobra::Menue.scoped.each do |m|
  		m.save
  	end
  end

  def down
 		remove_column :goldencobra_menues, :ancestry_depth
  end
end
