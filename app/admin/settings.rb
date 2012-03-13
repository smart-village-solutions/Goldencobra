ActiveAdmin.register Goldencobra::Setting, :as => "Setting"  do
  
  menu :parent => "Einstellungen", :label => "Optionen"
  
  controller.authorize_resource :class => Goldencobra::Setting
  
  form :html => { :enctype => "multipart/form-data" }  do |f|
    f.inputs "Allgemein" do
      f.input :title
      f.input :value
      f.input :parent_id, :as => :select, :collection => Goldencobra::Setting.all.map{|c| [c.title, c.id]}, :include_blank => true
    end
    f.inputs "" do
      f.actions
    end
  end
  
    
end
