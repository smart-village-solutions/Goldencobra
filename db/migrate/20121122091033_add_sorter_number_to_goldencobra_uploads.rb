class AddSorterNumberToGoldencobraUploads < ActiveRecord::Migration
  def change
    add_column :goldencobra_uploads, :sorter_number, :integer
  end
end
