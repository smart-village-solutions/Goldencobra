ActiveAdmin.register Goldencobra::Setting, :as => "Setting"  do
  
  menu :parent => "Einstellungen", :label => "Optionen", :if => proc{can?(:update, Goldencobra::Setting)}
  
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
  
  sidebar :overview, only: [:index]  do
    render :partial => "/goldencobra/admin/shared/overview", :object => Goldencobra::Setting.roots, :locals => {:link_name => "title", :url_path => "setting" }
  end
  
  
    
end
