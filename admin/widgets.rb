ActiveAdmin.register Goldencobra::Widget, as: "Widget" do
  menu parent: "Content-Management", :if => proc{can?(:read, Goldencobra::Widget)}

  scope "Alle", :scoped, :default => true
  scope "online", :active
  scope "offline", :inactive
  scope "defaults", :default
  Goldencobra::Widget.tag_counts_on(:tags).map(&:name).each do |wtag|
    scope(I18n.t(wtag, :scope => [:goldencobra, :widget_types], :default => wtag)){ |t| t.tagged_with(wtag) }
  end

  form html: { enctype: "multipart/form-data" } do |f|
    f.actions
    f.inputs "Allgemein" do
      f.input :title
      f.input :content
      f.input :mobile_content
      f.input :id_name
      f.input :css_name
      f.input :teaser
      f.input :sorter, :hint => "Nach dieser Nummer wird sortiert: Je h&ouml;her, desto weiter unten in der Ansicht"
      f.input :tag_list
      f.input :active
    end

    f.inputs "Admin" do
      if(proc{can?(:read, Goldencobra::Widget)})
        f.input :default, :hint => "Bestimmt ob ein Widget immer und auf jeder Seite angezeigt wird oder nicht."
      end
      f.input :description
    end
    f.inputs "Artikel" do
      f.input :articles, :as => :check_boxes, :collection => Goldencobra::Article.find(:all, :order => "title ASC")
    end
    f.actions
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
    column :tag_list
    column :default, :sortable => :default do |widget|
      widget.default ? "default" : "no default"
    end
    default_actions
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
    _widget = @_assigns['widget']
    if _widget.versions.last
      link_to("Undo", revert_admin_widget_path(:id => _widget.versions.last), :class => "undo")
    end
  end

  controller do
    def show
      show! do |format|
         format.html { redirect_to edit_admin_widget_path(@widget), :flash => flash }
      end
    end
  end


end
