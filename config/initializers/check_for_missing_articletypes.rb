# encoding: utf-8
Rails.application.config.to_prepare do
	if ActiveRecord::Base.connection.table_exists?("goldencobra_articles") && ActiveRecord::Base.connection.table_exists?("goldencobra_articletypes")
		Goldencobra::Article.scoped.pluck(:article_type).uniq.each do |at|
			if Goldencobra::Articletype.find_by_name(at).blank?
				Goldencobra::Articletype.create(:name => at, :default_template_file => "application")
			end
		end
		Goldencobra::Articletype.scoped.each do |at|
			#install Basik set of Fieldgroups and Fields if no one is set up
			if !at.fieldgroups.any?
				a1 = at.fieldgroups.create(:title => "Allgemein", :position => "first_block", :foldable => false, :closed => false, :expert => false, :sorter => 1)
				a1.fields.create(:fieldname => "title", :sorter => 1)
				a1.fields.create(:fieldname => "content", :sorter => 1)
				a1.fields.create(:fieldname => "teaser", :sorter => 1)
				a1.fields.create(:fieldname => "tag_list", :sorter => 1)
				a1.fields.create(:fieldname => "frontend_tag_list", :sorter => 1)
				a1.fields.create(:fieldname => "active", :sorter => 1)

				a2 = at.fieldgroups.create(:title => "Weiterer Inhalt", :position => "last_block", :foldable => true, :closed => true, :expert => false, :sorter => 2)
				a2.fields.create(:fieldname => "subtitle", :sorter => 1)
				a2.fields.create(:fieldname => "context_info", :sorter => 1)
				a2.fields.create(:fieldname => "summary", :sorter => 1)

				a3 = at.fieldgroups.create(:title => "Metadescriptions", :position => "last_block", :foldable => true, :closed => true, :expert => true, :sorter => 3)
				a3.fields.create(:fieldname => "metatags", :sorter => 1)

				a4 = at.fieldgroups.create(:title => "Einstellungen", :position => "last_block", :foldable => true, :closed => true, :expert => true, :sorter => 4)
				a4.fields.create(:fieldname => "breadcrumb", :sorter => 1)
				a4.fields.create(:fieldname => "url_name", :sorter => 2)
				a4.fields.create(:fieldname => "parent_id", :sorter => 3)
				a4.fields.create(:fieldname => "canonical_url", :sorter => 4)
				a4.fields.create(:fieldname => "active_since", :sorter => 5)
				a4.fields.create(:fieldname => "enable_social_sharing", :sorter => 6)
				a4.fields.create(:fieldname => "robots_no_index", :sorter => 7)
				a4.fields.create(:fieldname => "cacheable", :sorter => 8)
				a4.fields.create(:fieldname => "commentable", :sorter => 9)
				a4.fields.create(:fieldname => "dynamic_redirection", :sorter => 10)
				a4.fields.create(:fieldname => "external_url_redirect", :sorter => 11)
				a4.fields.create(:fieldname => "redirect_link_title", :sorter => 12)
				a4.fields.create(:fieldname => "redirection_target_in_new_window", :sorter => 13)
				a4.fields.create(:fieldname => "author", :sorter => 14)

				a5 = at.fieldgroups.create(:title => "Zugriffsrechte", :position => "last_block", :foldable => true, :closed => true, :expert => true, :sorter => 5)
				a5.fields.create(:fieldname => "permissions", :sorter => 1)

				a6 = at.fieldgroups.create(:title => "Medien", :position => "last_block", :foldable => true, :closed => true, :expert => false, :sorter => 6)
				a6.fields.create(:fieldname => "article_images", :sorter => 1)
				puts "Default Fieldoptions recreated for #{at.name}"
			end
		end
	end
end