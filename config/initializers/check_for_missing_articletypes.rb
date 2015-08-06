Rails.application.config.to_prepare do
	if ActiveRecord::Base.connection.table_exists?("goldencobra_articles") && ActiveRecord::Base.connection.table_exists?("goldencobra_articletypes")
		Goldencobra::Article.article_types_for_select.each do |at|
			if Goldencobra::Articletype.find_by_name(at).blank?
				Goldencobra::Articletype.create(name: at, default_template_file: "application")
				puts "Default Articletype created for #{at}"
			end
		end
		if ActiveRecord::Base.connection.table_exists?("goldencobra_articletype_groups")
			Goldencobra::Articletype.all.each do |at|
				# install basic set of fieldgroups and fields if no one is set up
				if !at.try(:fieldgroups).any?
					a1 = at.fieldgroups.create(title: "Allgemein", position: "first_block", foldable: true, closed: false, expert: false, sorter: 1)
					a1.fields.create(fieldname: "active", sorter: 1)
					a1.fields.create(fieldname: "breadcrumb", sorter: 5)
					a1.fields.create(fieldname: "subtitle", sorter: 10)
					a1.fields.create(fieldname: "title", sorter: 20)
					a1.fields.create(fieldname: "teaser", sorter: 30)
					a1.fields.create(fieldname: "content", sorter: 40)
					a1.fields.create(fieldname: "tag_list", sorter: 50)

					a2 = at.fieldgroups.create(title: "Medien", position: "last_block", foldable: true, closed: true, expert: false, sorter: 1)
					a2.fields.create(fieldname: "article_images", sorter: 1)

					a3 = at.fieldgroups.create(title: "Metadescriptions", position: "last_block", foldable: true, closed: true, expert: true, sorter: 3)
					a3.fields.create(fieldname: "metatags", sorter: 1)

					a4 = at.fieldgroups.create(title: "Einstellungen", position: "last_block", foldable: true, closed: true, expert: true, sorter: 4)
					a4.fields.create(fieldname: "frontend_tag_list", sorter: 10)
					a4.fields.create(fieldname: "url_name", sorter: 20)
					a4.fields.create(fieldname: "parent_id", sorter: 30)
					a4.fields.create(fieldname: "canonical_url", sorter: 40)
					a4.fields.create(fieldname: "active_since", sorter: 50)
					a4.fields.create(fieldname: "robots_no_index", sorter: 60)
					a4.fields.create(fieldname: "cacheable", sorter: 70)
					a4.fields.create(fieldname: "dynamic_redirection", sorter: 100)
					a4.fields.create(fieldname: "external_url_redirect", sorter: 110)
					a4.fields.create(fieldname: "redirect_link_title", sorter: 120)
					a4.fields.create(fieldname: "redirection_target_in_new_window", sorter: 130)
					a4.fields.create(fieldname: "author", sorter: 140)

					puts "Default Fieldoptions recreated for #{at.try(:name)}"
				end
			end
		end
	end
end
