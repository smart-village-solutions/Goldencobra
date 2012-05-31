class AddSocialSharingToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :enable_social_sharing, :boolean

  end
end
