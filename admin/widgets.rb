#encoding: utf-8

ActiveAdmin.register Goldencobra::Widget, as: "Widget" do
  menu :priority => 3, parent: "Content-Management", :if => proc{can?(:read, Goldencobra::Widget)}

  filter :title, :label => "Titel"
  filter :css_name, :label => "CSS Klasse"
  filter :id_name, :label => "ID Name"
  filter :sorter, :label => "Sortiernummer"

  scope "Alle", :scoped, :default => true
  scope "Aktiv", :active
  scope "Nicht aktiv", :inactive
  scope "Standards", :default

  if ActiveRecord::Base.connection.table_exists?("tags")
    Goldencobra::Widget.tag_counts_on(:tags).map(&:name).each do |wtag|
      scope(I18n.t(wtag, :scope => [:goldencobra, :widget_types], :default => wtag).capitalize){ |t| t.tagged_with(wtag) }
    end
  end

  form html: { enctype: "multipart/form-data" } do |f|
    f.actions
    f.inputs "Allgemein", :class => "foldable inputs" do
      f.input :title, :label => "Titel", :hint => "Name des Schnipsels"
      f.input :tag_list, :label => "Position", :hint => "Name der Bezeichnung der Position im Seitenlayout"
      f.input :active, :label => "Aktiv?", :hint => "Soll dieses Schnipsel im System aktiv und online sichtbar sein?"
      f.input :default, :label => "Standard?", :hint => "Bestimmt, ob ein Schnipsel immer und auf jeder Seite angezeigt wird oder nicht"
    end
    f.inputs "Layout - Website", :class => "foldable inputs" do
      f.input :content, :label => "Haupt-Textfeld", :hint => "Inhalt des Schnipsels für die Website, auch HTML möglich"
    end
    f.inputs "Layout - Mobil", :class => "foldable inputs closed" do
      f.input :mobile_content, :label => "Mobil-Textfeld", :hint => "Alternativer Inhalt des Schnipsels für mobile Seiten, auch HTML möglich"
    end
    f.inputs "Erweiterte Informationen", :class => "foldable inputs closed"  do
      f.input :sorter, :label => "Sortiernummer", :hint => "Nach dieser Nummer wird sortiert, je höher, desto weiter unten in der Ansicht"
      f.input :css_name, :label => "CSS Klassen", :hint => "Styleklassen für den Menüpunkt per Leerzeichen getrennt - Besonderheit: 'hidden' macht den Menüpunkt unsichtbar"
      f.input :id_name, :label => "ID Name", :hint => "Eindeutige Bezeichnung dieses Elements innerhalb der Website"
      f.input :teaser
      f.input :description, :label => "Beschreibung", :hint => "Interne Beschreibung dieses Schnipsels"
    end
    if Goldencobra::Setting.for_key("goldencobra.widgets.time_control") == "true"
      f.inputs "Zeitsteuerung", :class => "foldable inputs closed" do
        f.input :offline_time_active, :label => "Zeitgesteuert?", hint: 'Soll dieses Schnipsel zeitgesteuert sichtbar sein?'
        f.input :offline_date_start, :label => "Startdatum", :hint => "Ab diesem Datum wird das Schnipsel jeden Mo, Di, .. im Zeitraum von xx:xx Uhr bis xx:xx Uhr angezeigt. Wenn kein Datum angegeben ist, gilt die Zeitsteuerung an allen ausgewählten Tagen"
        f.input :offline_date_end, :label => "Enddatum", :hint => "Bis zu diesem Datum wird das Schnipsel jeden Mo, Di, .. im Zeitraum von xx:xx Uhr bis xx:xx Uhr angezeigt. Wenn kein Datum angegeben ist, gilt die Zeitsteuerung an allen ausgewählten Tagen"
        f.input :offline_day, :label => "Tage, an denen alternativer Inhalt angezeigt werden soll", as: :check_boxes, collection: Goldencobra::Widget::OfflineDays
        f.input :offline_time_start_mo, as: :string, placeholder: I18n.t(:offline_time_start_hint, scope: [:activerecord, :attributes, 'goldencobra/widget']), input_html: { value: (f.object.get_offline_time_start_mo) }
        f.input :offline_time_end_mo, as: :string, placeholder:  I18n.t(:offline_time_end_hint, scope: [:activerecord, :attributes, 'goldencobra/widget']), input_html: { value: (f.object.get_offline_time_end_mo) }
        f.input :offline_time_start_tu, as: :string, placeholder: I18n.t(:offline_time_start_hint, scope: [:activerecord, :attributes, 'goldencobra/widget']), input_html: { value: (f.object.get_offline_time_start_tu) }
        f.input :offline_time_end_tu, as: :string, placeholder:  I18n.t(:offline_time_end_hint, scope: [:activerecord, :attributes, 'goldencobra/widget']), input_html: { value: (f.object.get_offline_time_end_tu) }
        f.input :offline_time_start_we, as: :string, placeholder: I18n.t(:offline_time_start_hint, scope: [:activerecord, :attributes, 'goldencobra/widget']), input_html: { value: (f.object.get_offline_time_start_we) }
        f.input :offline_time_end_we, as: :string, placeholder:  I18n.t(:offline_time_end_hint, scope: [:activerecord, :attributes, 'goldencobra/widget']), input_html: { value: (f.object.get_offline_time_end_we) }
        f.input :offline_time_start_th, as: :string, placeholder: I18n.t(:offline_time_start_hint, scope: [:activerecord, :attributes, 'goldencobra/widget']), input_html: { value: (f.object.get_offline_time_start_th) }
        f.input :offline_time_end_th, as: :string, placeholder:  I18n.t(:offline_time_end_hint, scope: [:activerecord, :attributes, 'goldencobra/widget']), input_html: { value: (f.object.get_offline_time_end_th) }
        f.input :offline_time_start_fr, as: :string, placeholder: I18n.t(:offline_time_start_hint, scope: [:activerecord, :attributes, 'goldencobra/widget']), input_html: { value: (f.object.get_offline_time_start_fr) }
        f.input :offline_time_end_fr, as: :string, placeholder:  I18n.t(:offline_time_end_hint, scope: [:activerecord, :attributes, 'goldencobra/widget']), input_html: { value: (f.object.get_offline_time_end_fr) }
        f.input :offline_time_start_sa, as: :string, placeholder: I18n.t(:offline_time_start_hint, scope: [:activerecord, :attributes, 'goldencobra/widget']), input_html: { value: (f.object.get_offline_time_start_sa) }
        f.input :offline_time_end_sa, as: :string, placeholder:  I18n.t(:offline_time_end_hint, scope: [:activerecord, :attributes, 'goldencobra/widget']), input_html: { value: (f.object.get_offline_time_end_sa) }
        f.input :offline_time_start_su, as: :string, placeholder: I18n.t(:offline_time_start_hint, scope: [:activerecord, :attributes, 'goldencobra/widget']), input_html: { value: (f.object.get_offline_time_start_su) }
        f.input :offline_time_end_su, as: :string, placeholder:  I18n.t(:offline_time_end_hint, scope: [:activerecord, :attributes, 'goldencobra/widget']), input_html: { value: (f.object.get_offline_time_end_su) }
        f.input :alternative_content, :label => "Alternativer Inhalt", hint: 'Dieser Inhalt wird angezeigt, wenn das Schnipsel offline ist, HTML möglich.'
      end
    end
    f.inputs "Zugriffsrechte", :class => "foldable closed inputs" do
      f.has_many :permissions do |p|
        p.input :role, :include_blank => "Alle"
        p.input :action, :as => :select, :collection => Goldencobra::Permission::PossibleActions, :include_blank => false
        p.input :_destroy, :as => :boolean
      end
    end
    f.inputs "Zugewiesene Artikel" do
      f.input :articles, :label => "Artikel", :hint => "Auswahl aller Artikel, auf denen das Schnipsel erscheint", :as => :select, :collection => Goldencobra::Article.find(:all, :order => "title ASC"), :input_html => { :class => 'chzn-select', "data-placeholder" => "Bitte wählen" }
    end
    f.actions
  end

  sidebar :layout_positions, :only => [:edit] do
    ul do
      Goldencobra::Widget.tag_counts_on(:tags).map(&:name).each do |wtag|
        li do
          wtag
        end
      end
    end
  end

  index do
    selectable_column
    column "Titel", :title, :sortable => :title do |widget|
      link_to(widget.title, edit_admin_widget_path(widget), :title => "Schnipsel bearbeiten")
    end
    column "Position", :tag_list, :sortable => false
    column "Aktiv?", :active, :sortable => :active do |widget|
      raw("<span class='#{widget.active ? 'online' : 'offline'}'>#{widget.active ? 'online' : 'offline'}</span>")
    end
    column "Sortiernr", :sorter
    column "Standard?", :default, :sortable => :default do |widget|
      widget.default ? "Ja" : "Nein"
    end
    column "CSS Klassen", :css_name
    column "ID Name", :id_name
    column "Zugriff" do |widget|
      Goldencobra::Permission.restricted?(widget) ? raw("<span class='secured'>beschränkt</span>") : ""
    end
    column "" do |widget|
      result = ""
      result += link_to(t(:edit), edit_admin_widget_path(widget), :class => "member_link edit_link edit", :title => "Schnipsel bearbeiten")
      result += link_to(t(:delete), admin_widget_path(widget), :method => :DELETE, :confirm => t("delete_article", :scope => [:goldencobra, :flash_notice]), :class => "member_link delete_link delete", :title => "Schnipsel löschen")
      raw(result)
    end
  end

  show :title => :title do
    panel "Widget" do
      attributes_table_for widget do
        [:title, :content, :css_name, :active].each do |a|
          row a
        end
      end
    end
    panel "Articles" do
      table do
        tr do
          ["Title", "url_name"].each do |ta|
            th ta
          end
        end
        widget.articles.each do |wa|
          tr do
            [wa.title, wa.url_name].each do |watd|
              td watd
            end
          end
        end
      end
    end
  end

  member_action :revert do
    @version = Version.find(params[:id])
    if @version.reify
      @version.reify.save!
    else
      @version.item.destroy
    end
    redirect_to :back, :notice => "Undid #{@version.event}"
  end

  batch_action :destroy, false

  action_item :only => :edit do
    if resource.versions.last
      link_to("Undo", revert_admin_widget_path(:id => resource.versions.last), :class => "undo")
    end
  end

  controller do
    def show
      show! do |format|
         format.html { redirect_to edit_admin_widget_path(@widget), :flash => flash }
      end
    end
  end

  action_item only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/prev_item'
  end

  action_item only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/next_item'
  end
end
