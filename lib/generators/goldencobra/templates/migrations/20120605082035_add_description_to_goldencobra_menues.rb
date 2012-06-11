class AddDescriptionToGoldencobraMenues < ActiveRecord::Migration
  def change
    add_column :goldencobra_menues, :description, :text
    add_column :goldencobra_menues, :call_to_action_name, :string
  end
end
