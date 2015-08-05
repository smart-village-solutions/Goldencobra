#encoding: utf-8

ActiveAdmin.register Goldencobra::Widget, as: "Widget" do
  menu :parent => I18n.t('active_admin.widget.parent'), :label => I18n.t('active_admin.widget.as'), :if => proc{can?(:update, Goldencobra::Widget)}

  filter :title, :label => I18n.t('active_admin.widget.title')
  filter :css_name, :label => I18n.t('active_admin.widget.css_class')
  filter :id_name, :label => I18n.t('active_admin.widget.id')
  filter :sorter, :label => I18n.t('active_admin.widget.sorter')

  scope I18n.t('active_admin.widget.scope1'), :all, :default => true
  scope I18n.t('active_admin.widget.scope2'), :active
  scope I18n.t('active_admin.widget.scope3'), :inactive
  scope I18n.t('active_admin.widget.scope4'), :default

  if ActiveRecord::Base.connection.table_exists?("tags")
    Goldencobra::Widget.tag_counts_on(:tags).map(&:name).each do |wtag|
      scope(I18n.t(wtag, :scope => [:goldencobra, :widget_types], :default => wtag).capitalize){ |t| t.tagged_with(wtag) }
    end
  end

  form html: { enctype: "multipart/form-data" } do |f|
    f.actions
    f.inputs I18n.t('active_admin.widget.general'), :class => "foldable inputs" do
      f.input :title, :label => I18n.t('active_admin.widget.label1'), :hint => I18n.t('active_admin.widget.hint1')
      f.input :tag_list, :label => I18n.t('active_admin.widget.label2'), :hint => I18n.t('active_admin.widget.hint2')
      f.input :active, :label => I18n.t('active_admin.widget.label3'), :hint => I18n.t('active_admin.widget.hint3')
      f.input :default, :label => I18n.t('active_admin.widget.label4'), :hint => I18n.t('active_admin.widget.hint4')
    end
    f.inputs I18n.t('active_admin.widget.layout_web'), :class => "foldable inputs" do
      f.input :content, :label => I18n.t('active_admin.widget.label_web'), :hint => I18n.t('active_admin.widget.hint_web')
    end
    f.inputs I18n.t('active_admin.widget.layout_mobile'), :class => "foldable inputs closed" do
      f.input :mobile_content, :label => I18n.t('active_admin.widget.label_mobile'), :hint => I18n.t('active_admin.widget.hint_mobile')
    end
    f.inputs I18n.t('active_admin.widget.info'), :class => "foldable inputs closed"  do
      f.input :sorter, :label => I18n.t('active_admin.widget.label_info1'), :hint => I18n.t('active_admin.widget.label_hint1')
      f.input :css_name, :label => I18n.t('active_admin.widget.label_info2'), :hint => I18n.t('active_admin.widget.label_hint2')
      f.input :id_name, :label => I18n.t('active_admin.widget.label_info3'), :hint => I18n.t('active_admin.widget.label_hint3')
      f.input :teaser
      f.input :description, :label => I18n.t('active_admin.widget.label_info4'), :hint => I18n.t('active_admin.widget.label_hint4')
    end
    if Goldencobra::Setting.for_key("goldencobra.widgets.time_control") == "true"
      f.inputs I18n.t('active_admin.widget.time'), :class => "foldable inputs closed" do
        f.input :offline_time_active, :label => I18n.t('active_admin.widget.time_label1'), hint: I18n.t('active_admin.widget.time_hint1')
        f.input :offline_date_start, :label => I18n.t('active_admin.widget.time_label2'), :hint => I18n.t('active_admin.widget.time_hint2')
        f.input :offline_date_end, :label => I18n.t('active_admin.widget.time_label3'), :hint => I18n.t('active_admin.widget.time_hint3')
        f.input :offline_day, :label => I18n.t('active_admin.widget.time_label4'), as: :check_boxes, collection: Goldencobra::Widget::OfflineDays
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
    f.inputs I18n.t('active_admin.widget.access_rights'), :class => "foldable closed inputs" do
      f.has_many :permissions do |p|
        p.input :role, :include_blank => "Alle"
        p.input :action, :as => :select, :collection => Goldencobra::Permission::PossibleActions, :include_blank => false
        p.input :_destroy, :as => :boolean
      end
    end
    f.inputs I18n.t('active_admin.widget.article') do
      f.input :articles, :label => I18n.t('active_admin.widget.article_label'), :hint => I18n.t('active_admin.widget.article_hint'), :as => :select, :collection => Goldencobra::Article.find(:all, :order => "title ASC"), :input_html => { :class => 'chzn-select', "data-placeholder" => I18n.t('active_admin.widget.article_placeholder') }
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

  sidebar :help, only: [:edit, :show] do
    render "/goldencobra/admin/shared/help"
  end

  index :download_links => proc{ Goldencobra::Setting.for_key("goldencobra.backend.index.download_links") == "true" }.call do
    selectable_column
    column I18n.t('active_admin.widget.title'), :title, :sortable => :title do |widget|
      link_to(widget.title, edit_admin_widget_path(widget), :title => I18n.t('active_admin.widget.title1'))
    end
    column I18n.t('active_admin.widget.position'), :tag_list, :sortable => false
    column I18n.t('active_admin.widget.active'), :active, :sortable => :active do |widget|
      raw("<span class='#{widget.active ? I18n.t('active_admin.widget.online') : I18n.t('active_admin.widget.offline')}'>#{widget.active ? I18n.t('active_admin.widget.online') : I18n.t('active_admin.widget.offline')}</span>")
    end
    column I18n.t('active_admin.widget.sorternr'), :sorter
    column I18n.t('active_admin.widget.standard'), :default, :sortable => :default do |widget|
      widget.default ? "Ja" : "Nein"
    end
    column I18n.t('active_admin.widget.css_classes'), :css_name
    column I18n.t('active_admin.widget.id'), :id_name
    column I18n.t('active_admin.widget.access') do |widget|
      Goldencobra::Permission.restricted?(widget) ? raw("<span class='secured'>beschränkt</span>") : ""
    end
    column "" do |widget|
      result = ""
      result += link_to(t(:edit), edit_admin_widget_path(widget), :class => "member_link edit_link edit", :title => I18n.t('active_admin.widget.title_widget_edit'))
      result += link_to(t(:delete), admin_widget_path(widget), :method => :DELETE, :confirm => t("delete_article", :scope => [:goldencobra, :flash_notice]), :class => "member_link delete_link delete", :title => I18n.t('active_admin.widget.title_widget_delete'))
      raw(result)
    end
  end

  show :title => :title do
    panel I18n.t('active_admin.widget.widget') do
      attributes_table_for widget do
        [:title, :content, :css_name, :active].each do |a|
          row a
        end
      end
    end
    panel I18n.t('active_admin.widget.articles') do
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
    @version = PaperTrail::Version.find(params[:id])
    if @version.reify
      @version.reify.save!
    else
      @version.item.destroy
    end
    redirect_to :back, :notice => "#{I18n.t('active_admin.widget.revert_notice')} #{@version.event}"
  end

  batch_action :destroy, false

  action_item :only => :edit do
    if resource.versions.last
      link_to(I18n.t('active_admin.widget.undo'), revert_admin_widget_path(:id => resource.versions.last), :class => "undo")
    end
  end

  member_action :duplicate do
    original_widget = Goldencobra::Widget.find(params[:id])
    new_widget_id = original_widget.duplicate!
    if Goldencobra::Widget.find(new_widget_id)
      redirect_to admin_widget_path(id: new_widget_id),
                  notice: "#{I18n.t('active_admin.widget.success_duplicating_notice')}"
    else
      redirect_to :back, notice: "#{I18n.t('active_admin.widget.error_duplicating_notice')}"
    end
  end

  action_item only: :edit do
    link_to(I18n.t('active_admin.widget.duplicate'),
            duplicate_admin_widget_path(id: resource), class: "duplicate")
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
