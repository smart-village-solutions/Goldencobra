ActiveAdmin.register Goldencobra::Menue, :as => "Menue" do

  form do |f|
    f.inputs "Allgemein" do
      f.input :title
      f.input :target
      f.input :parent_id, :as => :select, :collection => Goldencobra::Menue.all.map{|c| [c.title, c.id]}, :include_blank => true
    end
    f.inputs "Optionen" do
      f.input :active
      f.input :css_class
    end
    f.buttons
  end
  
  index do
    column :id
    column :title
    column :target
    column :active
    column "" do |menue|
      result = ""
      result += link_to("New Submenu", new_admin_menue_path(:parent => menue), :class => "member_link edit_link")
      result += link_to("View", admin_menue_path(menue), :class => "member_link view_link")
      result += link_to("Edit", edit_admin_menue_path(menue), :class => "member_link edit_link")
      result += link_to("Delete", admin_menue_path(menue), :method => :DELETE, :confirm => "Realy want to delete this Menuitem?", :class => "member_link delete_link")
      raw(result)
    end
  end
  
  controller do 
    def new 
      @menue = Goldencobra::Menue.new
      if params[:parent] && params[:parent].present? 
        @parent = Goldencobra::Menue.find(params[:parent])
        @menue.parent_id = @parent.id
      end
    end 
  end
  
  
end
