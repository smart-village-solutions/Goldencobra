ActiveAdmin.register Goldencobra::Import, :as => "Import" do
  menu :parent => "Einstellungen", :if => proc{can?(:update, Goldencobra::Import)}

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
      links << link_to("Zuweisungen", assignment_admin_import_path(import))
      raw(links.join(" "))
    end
  end

  form :html => { :enctype => "multipart/form-data" }  do |f|  
    f.inputs "Select File for #{f.object.target_model}" do
      f.input :target_model
      f.input :upload
      f.input :separator
    end
    f.actions
  end

  member_action "run" do
    import = Goldencobra::Import.find(params[:id])
    import.run!
    flash[:notice] = "Dieser Import wurde gestartet"
    redirect_to :action => :index
  end
  
  member_action :assignment do
    @importer = Goldencobra::Import.find(params[:id])
    if @importer
      render 'goldencobra/imports/attributes', layout: 'active_admin'
    else
      render nothing: true
    end
  end
  

  controller do
    
    def new
      @import = Goldencobra::Import.new(:target_model => params[:target_model])
    end
    
    def show
      show! do |format|
         format.html { redirect_to assignment_admin_import_path(@import), :flash => flash }
      end
    end
    
    def edit
      @import = Goldencobra::Import.find(params[:id])
      @import.analyze_csv
    end
  end

end