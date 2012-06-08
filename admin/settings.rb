ActiveAdmin.register Goldencobra::Setting, :as => "Setting"  do
  
  menu :parent => "Einstellungen", :if => proc{can?(:update, Goldencobra::Setting)}
  
  controller.authorize_resource :class => Goldencobra::Setting
  
  form :html => { :enctype => "multipart/form-data" }  do |f|
    f.inputs "Allgemein" do
      f.input :title
      f.input :value
      f.input :parent_id, :as => :select, :collection => Goldencobra::Setting.all.map{|c| [c.title, c.id]}, :include_blank => true
    end
    f.actions
  end
  
  sidebar :overview, only: [:index]  do
    render :partial => "/goldencobra/admin/shared/overview", :object => Goldencobra::Setting.roots, :locals => {:link_name => "title", :url_path => "setting" }
  end
  
  batch_action :destroy, false
  
  member_action :revert do
    @version = Version.find(params[:id])
    if @version.reify
      @version.reify.save!
    else
      @version.item.destroy
    end
    redirect_to :back, :notice => "Undid #{@version.event}"
  end
  
  action_item :only => :edit do
    _setting = @_assigns['setting']
    if _setting.versions.last
      link_to("Undo", revert_admin_setting_path(:id => _setting.versions.last), :class => "undo")
    end
  end
    
end
