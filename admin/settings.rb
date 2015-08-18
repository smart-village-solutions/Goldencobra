# encoding: utf-8

ActiveAdmin.register Goldencobra::Setting, :as => "Setting"  do
  menu :parent => I18n.t("settings", :scope => ["active_admin","menue"]), :label => I18n.t('active_admin.settings.as'), :if => proc{can?(:update, Goldencobra::Setting)}
  scope I18n.t('active_admin.settings.scope'), :with_values, :default => true, :show_count => false
  config.paginate = false

  form :html => { :enctype => "multipart/form-data" }  do |f|
    f.inputs I18n.t('active_admin.settings.form.general')  do
      f.input :title, :input_html => {:disabled => "disabled"}
      f.input :value
      f.input :data_type, :as => :select, :collection => Goldencobra::Setting::SettingsDataTypes, :include_blank => false
      f.input :parent_id, :as => :select, :collection => Goldencobra::Setting.all.map{|c| [c.title, c.id]}, :include_blank => true
    end
    f.actions
  end

  
  index as: ActiveAdmin::Views::IndexAsTree, :download_links => false do
    title :title do |setting|
      "#{setting.parent_names}.#{setting.title}"
    end
    value :value
    options [:edit,:destroy]
  end

  index do
    selectable_column
    column :id
    column :title do |setting|
      link_to "#{setting.parent_names}.#{setting.title}", edit_admin_setting_path(setting)
    end
    column :value
    column :data_type
    column "" do |setting|
      result = ""
      result += link_to(t(:edit), edit_admin_setting_path(setting), :class => "member_link edit_link edit", :title => "bearbeiten")
      raw(result)
    end
  end

  # index download_links: false, pagination_total: false do
  #   div do
  #     render :partial => "/goldencobra/admin/settings/index"
  #   end
  # end

  sidebar :overview, only: [:index]  do
    # render :partial => "/goldencobra/admin/shared/overview", 
    # :object => Goldencobra::Setting.roots, 
    # :locals => {:link_name => "title", :url_path => "setting" }

    render partial: "/goldencobra/admin/shared/react_overview",
       locals: {
         url: "/admin/settings/load_overviewtree_as_json",
         object_class: "Goldencobra::Setting",
         link_name: "title",
         url_path: "setting",
         order_by: "title",
         class_name: "settings"
       }

  end

  sidebar :goldencobra_info do
    div do
      p "Version: #{Gem.loaded_specs["goldencobra"].version.to_s}"
    end
  end

  collection_action :load_overviewtree_as_json do
    if params[:root_id].present?
      articles = Goldencobra::Setting.find(params[:root_id])
                   .children.order(:title).as_json(
                      only: [:id, :value, :title], 
                      methods: [:has_children])
    else
      articles = Goldencobra::Setting.order(:title)
                   .roots.as_json(only: [:id, :value, :title], methods: [:has_children])
    end
    render json: articles
  end

  batch_action :destroy, false

  member_action :revert do
    @version = PaperTrail::Version.find(params[:id])
    if @version.reify
      @version.reify.save!
    else
      @version.item.destroy
    end
    redirect_to :back, :notice => "#{I18n.t('active_admin.settings.notice.undid_event')} #{@version.event}"
  end

  action_item :undo, :only => :edit do
    if resource.versions.last
      link_to(I18n.t('active_admin.settings.action_item.link'), revert_admin_setting_path(:id => resource.versions.last), :class => "undo")
    end
  end
  action_item :prev_item, only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/prev_item'
  end

  action_item :next_item, only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/next_item'
  end

end
