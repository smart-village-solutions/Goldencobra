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

  form :html => { :enctype => "multipart/form-data" }  do |f|
    f.actions
    f.inputs "File" do
      f.input :image, :as => :file
    end
    f.inputs "Allgemein" do
      f.input :source
      f.input :rights
      f.input :tag_list, :hint => "Tags sind komma-getrennte Werte, mit denen sich ein Artikel verschlagworten l&auml;sst", :label => "Liste von Tags"
      f.input :description, :input_html => { :class =>"tinymce", :rows => 3}
      f.input :alt_text
    end
  end

  index do
    selectable_column
    column "url" do |upload|
      result = ""
      result << upload.image.url
    end
    column :source, sortable: :source do |upload|
    	truncate(upload.source, length: 20)
    end
    column t("preview") do |upload|
      image_tag(upload.image(:mini))
    end
    column :created_at, sortable: :created_at do |upload|
    	l(upload.created_at, format: :short)
	end
	  column "" do |upload|
	    if upload.image_file_name && upload.image_file_name.include?(".zip")
	      link_to(raw("entpacken"), unzip_file_admin_upload_path(upload))
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
        upload.image(:original)
      end
      row "large" do
        upload.image(:large)
      end
      row "big" do
        upload.image(:big)
      end
      row "medium" do
        upload.image(:medium)
      end
      row "thumb" do
        upload.image(:thumb)
      end
      row "mini" do
        upload.image(:mini)
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
end
