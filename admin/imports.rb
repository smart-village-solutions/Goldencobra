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
      links << link_to("Starte Import", run_admin_import_path(import), :class => "import", :title => "Starte Import" )
      links << link_to("Bearbeiten", edit_admin_import_path(import), :class => "edit", :title => "bearbeiten")
      links << link_to("Loeschen", admin_import_path(import),:method => :delete, :confirm => "Destroy Import?", :class => "delete", :title => "loeschen")
      links << link_to("Zuweisungen", assignment_admin_import_path(import))
      raw(links.join(" "))
    end
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.actions
    f.inputs "Select File for #{f.object.target_model}" do
      f.input :target_model, as: :select, collection: ActiveRecord::Base.descendants.map(&:name), include_blank: false
      f.inputs "Upload", :class=> "inputs" do
        f.fields_for :upload do |u|
          u.inputs "" do
            u.input :image, :as => :file, :label => "CSV Datei"
          end
        end
      end
      f.input :separator
      f.input :encoding_type, :as => :select, :collection => Goldencobra::Import::EncodingTypes
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

  action_item :only => [:show, :edit, :assignment] do
    link_to('Starte Import', run_admin_import_path(resource.id))
  end

  action_item :only => [:assignment] do
    link_to("Import Bearbeiten", edit_admin_import_path(resource.id))
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