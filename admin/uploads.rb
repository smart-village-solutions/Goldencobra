ActiveAdmin.register Goldencobra::Upload, as: "Upload" do
  menu parent: I18n.t("active_admin.articles.parent"),
       label: I18n.t("active_admin.uploads.as"),
       if: proc { can?(:read, Goldencobra::Upload) }

  if ActiveRecord::Base.connection.table_exists?("tags")
    Goldencobra::Upload.tag_counts_on(:tags).each do |utag|
      if utag.count > 5
        scope(
          I18n.t(utag.name, scope: [:goldencobra, :widget_types], default: utag.name),
          show_count: false
        ) { |t| t.tagged_with(utag.name) }
      end
    end
  end

  filter :id
  filter :image_file_name
  filter :image_content_type
  filter :image_file_size
  filter :source
  filter :rights
  filter :description
  filter :alt_text
  filter :created_at
  filter :updated_at

  form html: { enctype: "multipart/form-data" } do |f|
    f.actions
    f.inputs I18n.t("active_admin.uploads.file") do
      f.input :image, as: :file, hint: I18n.t("active_admin.uploads.file_hint")
      f.input :image_url, hint: I18n.t("active_admin.uploads.file_url_hint")
      if f.object && f.object.image_content_type.present?
        f.input :image_content_type, hint: I18n.t("active_admin.uploads.content_type_hint")
      end
      f.input :id, as: :hidden
    end
    f.inputs I18n.t("active_admin.uploads.preview") do
      image_tag(f.object.image(:large), id: "image_crop") if f.object && f.object.image.present?
    end
    f.inputs I18n.t("active_admin.uploads.photo") do
      f.input :crop_image, as: :boolean, hint: I18n.t("active_admin.uploads.photo_hint")
    end
    f.inputs I18n.t("active_admin.uploads.data") do
      f.object.image_file_name
    end
    f.inputs I18n.t("active_admin.uploads.general") do
      f.input :source
      f.input :rights
      f.input :tag_list,
              hint: I18n.t("active_admin.uploads.general_hint"),
              label: I18n.t("active_admin.uploads.general_label")
      f.input :description, input_html: { class: "html-textarea", rows: 3 }
      f.input :alt_text
      f.input :sorter_number
      f.input :crop_x, as: :hidden
      f.input :crop_y, as: :hidden
      f.input :crop_w, as: :hidden
      f.input :crop_h, as: :hidden
    end
    f.inputs I18n.t("active_admin.uploads.js"), class: "hide" do
      render partial: "/goldencobra/admin/uploads/jcrop"
    end
    f.actions
  end

  index download_links: proc { Goldencobra::Setting.for_key("goldencobra.backend.index.download_links") == "true" }.call do
    selectable_column
    column t(I18n.t("active_admin.uploads.preview")) do |upload|
      if upload.image_content_type.present?
        link_to(
          upload.image_content_type.match(/image|pdf/) ? image_tag(upload.image(:thumb)) : "",
          admin_upload_path(upload),
          class: "member_link edit_link",
          title: I18n.t("active_admin.uploads.title1")
        )
      end
    end
    column I18n.t("active_admin.uploads.url") do |upload|
      result = content_tag(
        :p,
        link_to(
          upload.image_file_name,
          edit_admin_upload_path(upload),
          class: "member_link edit_link",
          title: I18n.t("active_admin.uploads.title2")
        ),
        style: "margin-bottom: 15px;"
      )
      result << upload.image.url
    end
    column I18n.t("active_admin.uploads.tags") do |upload|
      upload.tag_list
    end
    column :image_content_type
    column :image_file_size do |upload|
      file_size_mb = "%.02f" % (upload.image_file_size.to_f / 1000 / 1000)
      "#{file_size_mb} MB"
    end
    column I18n.t("active_admin.uploads.zip") do |upload|
      if upload.image_file_name && upload.image_file_name.include?(".zip")
        link_to(
          I18n.t("active_admin.uploads.pack"),
          unzip_file_admin_upload_path(upload),
          title: I18n.t("active_admin.uploads.pack")
        )
      end
    end
    column :created_at do |upload|
    	l(upload.created_at, format: :date)
	  end
    column "" do |upload|
      result = ""
      result += link_to(
        t(:view),
        admin_upload_path(upload),
        class: "member_link edit_link view",
        title: I18n.t("active_admin.uploads.title1")
      )
      result += link_to(
        t(:edit),
        edit_admin_upload_path(upload),
        class: "member_link edit_link edit",
        title: I18n.t("active_admin.uploads.title2")
      )
      result += link_to(
        t(:delete),
        admin_upload_path(upload),
        method: :DELETE,
        "data-confirm" => t("delete_article", scope: [:goldencobra, :flash_notice]),
        class: "member_link delete_link delete",
        title: I18n.t("active_admin.uploads.title3")
      )
      raw(result)
    end
  end

  index as: :grid, columns: 6 do |upload|
    link_to(
      image_tag(upload.image(:px200), alt: upload.image_file_name),
      admin_upload_path(upload),
      class: "member_link edit_link",
      title: I18n.t("active_admin.uploads.title1")
    )
  end

  show do
    attributes_table do
      row I18n.t("active_admin.uploads.original_row") do
        link_to(
          "#{Goldencobra::Url}#{upload.image(:original)}",
          upload.image(:original),
          target: "_blank"
        )
      end
      if ActiveRecord::Base.connection.table_exists?("goldencobra_uploads")
        Goldencobra::Upload.attachment_definitions[:image][:styles].keys.each do |image_size|
          row image_size do
            result = content_tag(
              :div,
              image_tag(upload.image(image_size))
            )
            result += link_to(
              "#{Goldencobra::Url}#{upload.image(image_size)}",
              upload.image(image_size),
              target: "_blank"
            )
          end
        end
      end
    end

    attributes_table do
      row :image_file_name
      row :image_content_type
      row :image_file_size do |upload|
        file_size_mb = "%.02f" % (upload.image_file_size.to_f / 1000 / 1000)
        "Original: #{file_size_mb} MB"
      end
      row :tag_list
      row :source
      row :rights
      row :description
      row :alt_text
      row "Artikel" do |upload|
        result = ""
        upload.articles.map do |article|
          result += content_tag(
            :p,
            link_to(
              article.title,
              edit_admin_article_path(article.id),
              title: t(:edit)
            )
          )
        end
        raw(result)
      end
      row :created_at
      row :updated_at
    end
  end

  sidebar :image_formates do
    ul do
      li I18n.t("active_admin.uploads.format_original")
      li I18n.t("active_admin.uploads.format_large")
      li I18n.t("active_admin.uploads.format_big")
      li I18n.t("active_admin.uploads.format_medium")
      li I18n.t("active_admin.uploads.format_px250")
      li I18n.t("active_admin.uploads.format_px200")
      li I18n.t("active_admin.uploads.format_px150")
      li I18n.t("active_admin.uploads.format_thumb")
      li I18n.t("active_admin.uploads.format_mini")
    end
  end

  # batch_action :destroy, false

  member_action :unzip_file do
    upload = Goldencobra::Upload.find(params[:id])
    upload.unzip_files
    redirect_to action: :index, notice: I18n.t("active_admin.uploads.unzip_notice")
  end

  action_item :unzip, only: [:edit, :show] do
    if resource.image_file_name && resource.image_file_name.include?(".zip")
      link_to("Zip-Datei entpacken", unzip_file_admin_upload_path(resource), target: "_blank")
    end
   end

  action_item :prev_item, only: [:edit, :show] do
    render partial: "/goldencobra/admin/shared/prev_item"
  end

  action_item :next_item, only: [:edit, :show] do
    render partial: "/goldencobra/admin/shared/next_item"
  end

  controller do
    def create
      create! do |format|
        if @upload.blank?
          flash[:error] = "Entschuldigung, da gab es einen Fehler beim Hochladen."
          format.html { redirect_to(:back) }
        elsif @upload.errors.present? && @upload.errors.messages.any?
          flash[:error] = errors_flash
          format.html { redirect_to(:back) }
        end
        format.html { redirect_to admin_upload_path(@upload.id) }
      end
    end

    private

    def errors_flash
      headline = "<h3>Fehler beim Speichern</h3><ul>"
      flash = @upload.errors.messages.inject(headline) do |previous, message|
        attribute = t(message.first, scope: [:activerecord, :attributes, :profile])
        error = message.last.join(", ")
        previous + "<li><span>#{attribute}</span>: #{error}</li>"
      end
      raw(flash + "</ul>")
    end
  end
end
