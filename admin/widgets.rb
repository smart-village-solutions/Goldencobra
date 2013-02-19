#encoding: utf-8

ActiveAdmin.register Goldencobra::Widget, as: "Widget" do
  menu :priority => 3, parent: "Content-Management", :if => proc{can?(:read, Goldencobra::Widget)}

  scope "Alle", :scoped, :default => true
  scope "online", :active
  scope "offline", :inactive
  scope "defaults", :default

  if ActiveRecord::Base.connection.table_exists?("tags")
    Goldencobra::Widget.tag_counts_on(:tags).map(&:name).each do |wtag|
      scope(I18n.t(wtag, :scope => [:goldencobra, :widget_types], :default => wtag)){ |t| t.tagged_with(wtag) }
    end
  end

  form html: { enctype: "multipart/form-data" } do |f|
    f.actions
    f.inputs "Allgemein", :class => "foldable inputs" do
      f.input :title
      f.input :tag_list, :label => "Position"
      f.input :active
      f.input :default, :hint => "Bestimmt ob ein Widget immer und auf jeder Seite angezeigt wird oder nicht."
    end
    f.inputs "Layout - Default", :class => "foldable inputs" do
      f.input :content
    end
    f.inputs "Layout - Mobil", :class => "foldable inputs closed" do
      f.input :mobile_content
    end
    f.inputs "Zeitsteuerung", :class => "foldable inputs closed" do
      f.input :offline_time_active, hint: 'Soll dieses Widget zeitgesteuert sichtbar sein?'
      f.input :offline_date_start, :hint => "Ab diesem Datum wird dieses Widget jeden Mo,Di.. im Zeitraum von xx:xx Uhr bis xx:xx Uhr angezeigt. Wenn kein Datum angegeben ist, gilt die Zeitsteuerung an allen ausgewählten Tagen"
      f.input :offline_date_end, :hint => "Bis zu diesem Datum wird dieses Widget jeden Mo,Di.. im Zeitraum von xx:xx Uhr bis xx:xx Uhr angezeigt. Wenn kein Datum angegeben ist, gilt die Zeitsteuerung an allen ausgewählten Tagen"
      f.input :offline_day, as: :check_boxes, collection: Goldencobra::Widget::OfflineDays
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
      f.input :alternative_content, hint: 'Dieser Inhalt wird angezeigt, wenn das Widget offline ist.'
    end
    f.inputs "Erweiterte Infos", :class => "foldable inputs closed"  do
      f.input :sorter, :hint => "Nach dieser Nummer wird sortiert: Je h&ouml;her, desto weiter unten in der Ansicht"
      f.input :id_name
      f.input :css_name
      f.input :teaser
      f.input :description, :hint => "Interne Beschreibung dieses Widgets"
    end
    f.inputs "Zugewiesene Artikel" do
      f.input :articles, :as => :select, :collection => Goldencobra::Article.find(:all, :order => "title ASC"), :input_html => { :class => 'chzn-select'}
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
    column :id
    column :title
    column :id_name
    column :css_name
    column :active, :sortable => :active do |widget|
      widget.active ? "online" : "offline"
    end
    column :sorter
    column :tag_list, :sortable => false
    column :default, :sortable => :default do |widget|
      widget.default ? "default" : "no default"
    end
    column "" do |widget|
      result = ""
      result += link_to(t(:edit), edit_admin_widget_path(widget), :class => "member_link edit_link edit", :title => "bearbeiten")
      result += link_to(t(:delete), admin_widget_path(widget), :method => :DELETE, :confirm => t("delete_article", :scope => [:goldencobra, :flash_notice]), :class => "member_link delete_link delete", :title => "loeschen")
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
    render partial: '/goldencobra/admin/shared/prev_item', locals: { resource: resource, url: '' }
  end

  action_item only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/next_item', locals: { resource: resource, url: '' }
  end
end
