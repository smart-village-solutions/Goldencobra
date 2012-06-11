ActiveAdmin.register Goldencobra::Import, :as => "Import" do


  index do
    column :id
    column :target_model
    column :successful
    column :created_at
    column :updated_at
    column :status
    column "" do |import|
      links = []
      links << link_to("Starte Import", run_admin_import_path(import) )
      links << link_to("Bearbeiten", edit_admin_import_path(import))
      links << link_to("Loeschen", admin_import_path(import),:method => :delete, :confirm => "Destroy Import?")
      raw(links.join(" "))
    end
  end

  form :html => { :enctype => "multipart/form-data" }  do |f|  
    if f.object.new_record?
      f.inputs "Select File for #{f.object.target_model}" do
        f.input :target_model
        f.input :upload
        f.input :separator
      end
    else
      f.actions
      f.object.get_model_attributes.each do |model_attr|
        f.inputs "#{f.object.target_model} #{model_attr}" do
          f.input "assignment_#{model_attr}", :input_html => { :name => "import[assignment][#{model_attr}]" },:label => "#{model_attr.humanize}", :as => :select, :collection => f.object.analyze_csv
        end
      end
    end
    f.actions
  end

  member_action "run" do
    import = Goldencobra::Import.find(params[:id])
    import.run!
    flash[:notice] = "Dieser Import wurde gestartet"
    redirect_to :action => :index
  end

  controller do
    
    def new
      @import = Goldencobra::Import.new(:target_model => params[:target_model])
    end
    
    def show
      show! do |format|
         format.html { redirect_to edit_admin_import_path(@import), :flash => flash }
      end
    end
    
    def edit
      @import = Goldencobra::Import.find(params[:id])
      @import.analyze_csv
    end
  end

end