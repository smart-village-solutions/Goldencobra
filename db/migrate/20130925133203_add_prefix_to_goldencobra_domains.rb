class AddPrefixToGoldencobraDomains < ActiveRecord::Migration
  def change
    add_column :goldencobra_domains, :url_prefix, :string
  end
end
