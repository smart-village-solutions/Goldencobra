# encoding: utf-8

ActiveAdmin.register Goldencobra::Upload, :as => "Upload"  do

  menu :priority => 4, :parent => "Content-Management", :if => proc{can?(:read, Goldencobra::Upload)}

  controller.authorize_resource :class => Goldencobra::Upload

  if ActiveRecord::Base.connection.table_exists?("tags")
    Goldencobra::Upload.tag_counts_on(:tags).each do |utag|
      if(utag.count > 5)
        scope(I18n.t(utag.name, :scope => [:goldencobra, :widget_types], :default => utag.name)){ |t| t.tagged_with(utag.name) }
      end
    end
  end

  filter :id
  filter :source
  filter :rights
  filter :description
  filter :image_file_name
  filter :image_file_type
  filter :image_file_size
  filter :updated_at
  filter :created_at
  filter :alt_text
  filter :sorter_number

  form :html => { :enctype => "multipart/form-data" }  do |f|
    f.actions
    f.inputs "File" do
      f.input :image, :as => :file, hint: "Upload a new picture for this ressource, if the file name is the same!"
    end
    f.inputs "Preview" do
      image_tag(f.object.image(:large), :id => "image_crop") if f.object && f.object.image.present?
    end
    f.inputs "Bild beschneiden" do
      f.input :crop_image, :as => :boolean, :hint => "Make a selection in the preview image above before saving"
    end
    f.inputs "Dateiname" do
      f.object.image_file_name
    end
    f.inputs "Allgemein" do
      f.input :source
      f.input :rights
      f.input :tag_list, :hint => "Tags sind komma-getrennte Werte, mit denen sich ein Artikel verschlagworten l&auml;sst", :label => "Liste von Tags"
      f.input :description, :input_html => { :class =>"tinymce", :rows => 3}
      f.input :alt_text
      f.input :sorter_number
      f.input :crop_x, :as => :hidden
      f.input :crop_y, :as => :hidden
      f.input :crop_w, :as => :hidden
      f.input :crop_h, :as => :hidden
    end
    f.inputs "JS-Scripts", :style => "display:none"  do
      render partial: '/goldencobra/admin/uploads/jcrop'
    end
  end

  index do
    selectable_column
    column :id
    column "url" do |upload|
      result = ""
      result << upload.image.url
    end
    # column :source, sortable: :source do |upload|
    # 	truncate(upload.source, length: 20)
    # end
    column t("preview") do |upload|
      image_tag(upload.image(:mini))
    end
    column :created_at, sortable: :created_at do |upload|
    	l(upload.created_at, format: :short)
	  end
    column :sorter_number
    column "Tags" do |upload|
      upload.tag_list
    end
	  column "zip" do |upload|
	    if upload.image_file_name && upload.image_file_name.include?(".zip")
	      link_to(raw("entpacken"), unzip_file_admin_upload_path(upload))
      else
        "-"
	    end
	  end
    column "" do |upload|
      result = ""
      result += link_to(t(:view), admin_upload_path(upload), :class => "member_link edit_link view", :title => "Vorschau")
      result += link_to(t(:edit), edit_admin_upload_path(upload), :class => "member_link edit_link edit", :title => "bearbeiten")
      result += link_to(t(:delete), admin_upload_path(upload), :method => :DELETE, :confirm => t("delete_article", :scope => [:goldencobra, :flash_notice]), :class => "member_link delete_link delete", :title => "loeschen")
      raw(result)
    end
  end

  show do
    attributes_table do
      row "Vorschau" do
          image_tag(upload.image(:thumb))
      end
      row "original" do
        link_to("http://#{Goldencobra::Setting.for_key("goldencobra.url").html_safe}" + upload.image(:original),upload.image(:original), :target => "_blank" )
      end
      Goldencobra::Upload.attachment_definitions[:image][:styles].keys.each do |image_size|
        row "#{image_size}" do
          link_to("http://#{Goldencobra::Setting.for_key("goldencobra.url").html_safe}" + upload.image(image_size),upload.image(image_size), :target => "_blank" )
        end
      end
      row :source
      row :rights
      row :description
      row :tag_list
      row :image_file_name
      row :image_content_type
      row :image_file_size
      row :created_at
      row :updated_at
    end
  end

  sidebar :image_formates do
    ul do
      li "original => AxB>"
      li "large => 900x900>"
      li "big => 600x600>"
      li "medium => 300x300>"
      li "px250 => 250x250>"
      li "px200 => 200x200>"
      li "px150 => 150x150>"
      li "thumb => 100x100>"
      li "mini => 50x50>"
    end
  end

  #batch_action :destroy, false

  member_action :unzip_file do
    upload = Goldencobra::Upload.find(params[:id])
    upload.unzip_files
    redirect_to :action => :index, :notice => "File unzipped"
  end

  action_item :only => [:edit, :show] do
    if resource.image_file_name && resource.image_file_name.include?(".zip")
      link_to('Zip-Datei entpacken', unzip_file_admin_upload_path(resource), :target => "_blank")
    end
   end

  action_item only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/prev_item'
  end

  action_item only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/next_item'
  end
end
