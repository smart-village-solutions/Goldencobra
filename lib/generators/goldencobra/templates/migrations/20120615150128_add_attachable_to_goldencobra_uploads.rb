class AddAttachableToGoldencobraUploads < ActiveRecord::Migration
  def change
    add_column :goldencobra_uploads, :attachable_id, :integer
    add_column :goldencobra_uploads, :attachable_type, :string
  end
end
