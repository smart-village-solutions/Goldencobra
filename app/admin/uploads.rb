ActiveAdmin.register Goldencobra::Upload, :as => "Upload"  do
  
  form :html => { :enctype => "multipart/form-data" }  do |f|
    f.inputs "Allgemein" do
      f.input :source
      f.input :rights
      f.input :description, :input_html => { :class =>"tinymce"}
      f.input :image, :as => :file
    end
    f.buttons
  end
  
end
