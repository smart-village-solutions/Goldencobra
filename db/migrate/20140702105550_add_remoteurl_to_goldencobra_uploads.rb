class AddRemoteurlToGoldencobraUploads < ActiveRecord::Migration
  def change
    add_column :goldencobra_uploads, :image_remote_url, :string
  end
end
