class AddAlttextToGoldencobraUploads < ActiveRecord::Migration
  def change
    add_column :goldencobra_uploads, :alt_text, :string
  end
end
