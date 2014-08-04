# encoding: utf-8

# # encoding: utf-8

# # encoding: utf-8

# ActiveAdmin.register Goldencobra::Import, :as => "Import" do
#   menu :parent => I18n.t("settings", :scope => ["active_admin","menue"]), :if => proc{can?(:update, Goldencobra::Import)}

#   index do
#     column :id
#     column :target_model
#     column "Filename" do |import|
#       import.try(:upload).try(:image_file_name)
#     end
#     column :successful
#     column :created_at
#     column :updated_at
#     column :status
#     column "" do |import|
#       links = []
#       links << link_to(I18n.t('active_admin.imports.link_to.start_import'), run_admin_import_path(import), :class => "import", :title => I18n.t('active_admin.imports.title.start_import'))
#       links << link_to(I18n.t('active_admin.imports.link_to.edit'), edit_admin_import_path(import), :class => "edit", :title => I18n.t('active_admin.imports.title.edit'))
#       links << link_to(I18n.t('active_admin.imports.link_to.delete'), admin_import_path(import),:method => :delete, :confirm => "Destroy Import?", :class => "delete", :title => I18n.t('active_admin.imports.title.delete'))
#       links << link_to(I18n.t('active_admin.imports.link_to.allocation'), assignment_admin_import_path(import))
#       raw(links.join(" "))
#     end
#   end

#   form :html => { :enctype => "multipart/form-data" } do |f|
#     f.actions
#     f.inputs "#{I18n.t('active_admin.imports.form.select_file')} #{f.object.target_model}" do
#       f.input :target_model, as: :select, collection: ActiveRecord::Base.descendants.map(&:name), include_blank: false
#       f.inputs I18n.t('active_admin.imports.form.upload'), :class=> "inputs" do
#         f.fields_for :upload do |u|
#           u.inputs "" do
#             u.input :image, :as => :file, :label => I18n.t('active_admin.imports.form.csv_file'), :hint => "#{I18n.t('active_admin.imports.form.hint')} #{u.object.try(:image_file_name)}"
#           end
#         end
#       end
#       f.input :separator
#       f.input :encoding_type, :as => :select, :collection => Goldencobra::Import::EncodingTypes
#     end
#     f.actions
#   end

#   member_action "run" do
#     import = Goldencobra::Import.find(params[:id])
#     import.run!
#     flash[:notice] = I18n.t('active_admin.imports.flash.member_action.run')
#     redirect_to :action => :index
#   end

#   member_action :assignment do
#     @importer = Goldencobra::Import.find(params[:id])
#     if @importer
#       render 'goldencobra/imports/attributes', layout: 'active_admin'
#     else
#       render nothing: true
#     end
#   end

#   action_item :only => [:show, :edit, :assignment] do
#     link_to(I18n.t('active_admin.imports.link_to.start_import'), run_admin_import_path(resource.id))
#   end

#   action_item :only => [:assignment] do
#     link_to(I18n.t('active_admin.imports.link_to.edit_import'), edit_admin_import_path(resource.id))
#   end

#   controller do
#     def new
#       @import = Goldencobra::Import.new(:target_model => params[:target_model])
#     end

#     def show
#       show! do |format|
#          format.html { redirect_to assignment_admin_import_path(@import), :flash => flash }
#       end
#     end

#     def edit
#       @import = Goldencobra::Import.find(params[:id])
#       @import.analyze_csv
#     end
#   end
# end

