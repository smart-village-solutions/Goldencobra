# encoding: utf-8

ActiveAdmin.register Goldencobra::Articletype, as: "Articletype" do
  menu parent: I18n.t("settings", scope: ["active_admin","menue"]),
       label: I18n.t("active_admin.articletypes.as"), if: proc{can?(:update, Goldencobra::Article)}

  config.clear_action_items!

  index download_links: proc{ Goldencobra::Setting.for_key("goldencobra.backend.index.download_links") == "true" }.call do
    selectable_column
    column :name
    column :default_template_file
    actions
  end

  form html: { enctype: "multipart/form-data" }  do |f|
    f.actions
    f.inputs I18n.t("active_admin.articletypes.general") do
      f.input :default_template_file, as: :select,
              collection: Goldencobra::Template.all.map { |t| [t.title, t.layout_file_name]}, include_blank: false,
              label: I18n.t("active_admin.articletypes.default_template")
      f.input :templates, as: :check_boxes, collection: Goldencobra::Template.all.map { |t| [t.title, t.id]}, label: I18n.t("active_admin.articletypes.templates")
    end
    f.inputs I18n.t("active_admin.articletypes.article_fields"), class: "foldable" do
      f.has_many :fieldgroups, heading: "", new_record: "+ Feldgruppe hinzufügen" do |fg|
        fg.input :title, label: "Titel"
        fg.input :position, as: :select,
                 collection: [["Erster Block", "first_block"], ["Letzter Block", "last_block"]],
                 include_blank: false, hint: I18n.t("active_admin.articletypes.position_hint")
        fg.input :foldable, hint: I18n.t("active_admin.articletypes.foldable_hint")
        fg.input :closed, hint: I18n.t("active_admin.articletypes.closed_hint")
        fg.input :sorter, hint: I18n.t("active_admin.articletypes.sorter_hint"), label: "Sortierung"
        fg.input :_destroy, as: :boolean
        fg.has_many :fields, sortable: :sorter, heading: "", new_record: "+ Artikelfeld hinzufügen" do |fo|
          fo.input :fieldname, as: :select,
                   collection: Goldencobra::Articletype::ArticleFieldOptions.select{
                     |a| (!a.to_s.starts_with?("index__") || f.object.name.include?(" Index"))
                   }, include_blank: false, label: "Artikelfeld"
          fo.hidden_field :sorter
          fo.input :_destroy, as: :boolean, label: "Löschen"
        end
      end
    end
    if f.object.present? && !f.object.new_record? &&
       File.exists?("#{::Rails.root}/app/views/articletypes/#{f.object.name.underscore.parameterize.downcase}/_edit_articletype.html.erb")
      render partial: "articletypes/#{f.object.name.underscore.parameterize.downcase}/edit_articletype", locals: { f: f }
    end
    ::Rails::Engine.subclasses.map(&:instance).select{|a| a.engine_name.include?("goldencobra")}.each do |engine|
      if File.exists?("#{engine.root}/app/views/layouts/#{engine.engine_name}/_edit_articletype.html.erb")
        render partial: "layouts/#{engine.engine_name}/edit_articletype", locals: { f: f, engine: engine }
      end
    end
    f.actions
  end

  controller do
    def show
      show! do |format|
         format.html { redirect_to edit_admin_articletype_path(@articletype)}
      end
    end
  end

end
