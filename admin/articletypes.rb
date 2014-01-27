# encoding: utf-8

ActiveAdmin.register Goldencobra::Articletype, :as => "Articletype" do
  menu :priority => 2, :parent => "Content-Management", :if => proc{can?(:update, Goldencobra::Article)}
  controller.authorize_resource :class => Goldencobra::Article

  index do
    selectable_column
    column :name
    column :default_template_file
    default_actions
  end

  form :html => { :enctype => "multipart/form-data" }  do |f|
    f.inputs "Allgemein" do
      f.input :default_template_file, :as => :select, :collection => Goldencobra::Article.templates_for_select, :include_blank => false
    end
    if File.exists?("#{::Rails.root}/app/views/articletypes/#{f.object.name.underscore.parameterize.downcase}/_edit_articletype.html.erb")
      render :partial => "articletypes/#{f.object.name.underscore.parameterize.downcase}/edit_articletype", :locals => {:f => f}
    end
	  Rails::Application::Railties.engines.select{|a| a.engine_name.include?("goldencobra")}.each do |engine|
	  	if File.exists?("#{engine.root}/app/views/layouts/#{engine.engine_name}/_edit_articletype.html.erb")
	  	  render :partial => "layouts/#{engine.engine_name}/edit_articletype", :locals => {:f => f, :engine => engine}
	  	end
		end
    f.actions
  end

end