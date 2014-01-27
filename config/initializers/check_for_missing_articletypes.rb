# encoding: utf-8
Rails.application.config.to_prepare do
	if ActiveRecord::Base.connection.table_exists?("goldencobra_articles") && ActiveRecord::Base.connection.table_exists?("goldencobra_articletypes")
		Goldencobra::Article.scoped.pluck(:article_type).uniq.each do |at|
			if Goldencobra::Articletype.find_by_name(at).blank?
				Goldencobra::Articletype.create(:name => at, :default_template_file => "application")
			end
		end
	end
end