ActiveAdmin.register Goldencobra::Articletype, :as => "Articletype" do
  menu :parent => I18n.t("active_admin.articles.parent"), :label => I18n.t('active_admin.articletypes.as'), :if => proc{can?(:update, Goldencobra::Article)}

  config.clear_action_items!

  index :download_links => proc{ Goldencobra::Setting.for_key("goldencobra.backend.index.download_links") == "true" }.call do
    selectable_column
    column :name
    column :default_template_file
    actions
  end

  form :html => { :enctype => "multipart/form-data" }  do |f|
    f.inputs I18n.t('active_admin.articletypes.general') do
      f.input :default_template_file, :as => :select, :collection => Goldencobra::Article.templates_for_select, :include_blank => false
    end
    f.inputs I18n.t('active_admin.articletypes.article_fields'), :class => "foldable inputs" do
      f.has_many :fieldgroups do |fg|
        fg.input :title
        fg.input :position, :as => :select, :collection => [["First Block","first_block"], ["Last Block","last_block"]], :include_blank => false, :hint => I18n.t('active_admin.articletypes.position_hint')
        fg.input :foldable, :hint => I18n.t('active_admin.articletypes.foldable_hint')
        fg.input :closed, :hint => I18n.t('active_admin.articletypes.closed_hint')
        fg.input :expert, :hint => I18n.t('active_admin.articletypes.expert_hint')
        fg.input :sorter, :hint => I18n.t('active_admin.articletypes.sorter_hint')
        fg.input :_destroy, :as => :boolean
        fg.has_many :fields do |fo|
          fo.input :fieldname, :as => :select, :collection => Goldencobra::Articletype::ArticleFieldOptions.keys, :include_blank => false
          fo.input :sorter
          fo.input :_destroy, :as => :boolean
        end
      end
    end
    if f.object.present? && !f.object.new_record? && File.exists?("#{::Rails.root}/app/views/articletypes/#{f.object.name.underscore.parameterize.downcase}/_edit_articletype.html.erb")
      render :partial => "articletypes/#{f.object.name.underscore.parameterize.downcase}/edit_articletype", :locals => {:f => f}
    end
	  ::Rails::Engine.subclasses.map(&:instance).select{|a| a.engine_name.include?("goldencobra")}.each do |engine|
	  	if File.exists?("#{engine.root}/app/views/layouts/#{engine.engine_name}/_edit_articletype.html.erb")
	  	  render :partial => "layouts/#{engine.engine_name}/edit_articletype", :locals => {:f => f, :engine => engine}
	  	end
		end
    f.actions
  end

end
