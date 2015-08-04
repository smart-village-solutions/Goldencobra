# encoding: utf-8

ActiveAdmin.register Goldencobra::Redirector, :as => "Redirector" do
  menu :parent => I18n.t("settings", :scope => ["active_admin","menue"]), :label => I18n.t('active_admin.redirector.as'), :if => proc{can?(:update, Goldencobra::Redirector)}

  form html: { enctype: "multipart/form-data" }  do |f|
    f.actions
      f.inputs "Einzelne Weiterleitung einrichten", :class => "foldable inputs" do
        f.input :source_url, :as => :string, :hint => "Bitte absolute Adressen angeben in der Form: http://www.von_url.de"
        f.input :target_url, :as => :string, :hint => "Bitte absolute Adressen angeben in der Form: http://www.nach_url.de"
      end
      if f.object.new_record? || f.object.errors.any?
        f.inputs "Mehrere Weiterleitung per CSV-Daten einrichten", :class => "foldable #{f.object.errors.any? ? '' : 'closed'} inputs" do
          f.input :import_csv_data, :as => :text, :input_html => {:rows => 5, :placeholder => "source_url, target_url" }, :hint => raw("CSV Daten müssen in folgender Form eingegeben werden: <b>source_url, target_url</b> <br>Wenn dieses Feld ausgefüllt ist, werden die Einzelfelder 'Source Url' und 'Target Url' ignoriert. Für alle Einträge in 'Import CSV Data' gelten weiterhin die Einstellungen unter 'Allgemein'")
        end
      end
      f.inputs "Allgemein" do
        f.input :redirection_code, :hint => raw("Welcher Weiterleitungscode soll dabei gesetzt werden? <a href='http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html' target='_blank'>Mögliche HTML-Codes</a> ")
        f.input :ignore_url_params, :hint => "Sind die URL Parameter bei Source Url relevant für die Weiterleitung"
        f.input :active, :hint => "Ist diese Weiterleitung aktiv?"
      end
    f.actions
  end


  controller do

    def show
      show! do |format|
         format.html { redirect_to edit_admin_redirector_path(@redirector.id), :flash => flash }
      end
    end

    def create
      create! do |format|
         format.html { redirect_to admin_redirectors_path() }
      end
    end


  end


end