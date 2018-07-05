class RemoveIgnoreFromRedirections < ActiveRecord::Migration
  def change
    remove_column :goldencobra_redirectors, :ignore_url_params, :boolean, default: true
  end
end
