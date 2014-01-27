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
    f.actions
  end

end