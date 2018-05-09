ActiveAdmin.register Goldencobra::ArticleUrl, as: "ArticleUrl" do
  menu parent: I18n.t("settings", scope: ["active_admin","menue"]), label: I18n.t('active_admin.article_url.as'), if: proc{can?(:update, Goldencobra::ArticleUrl)}

  config.clear_action_items!

  form html: { enctype: "multipart/form-data" }  do |f|
    f.actions
      f.inputs "Einzelne Weiterleitung einrichten", class: "foldable inputs" do
        f.input :url, as: :string, hint: "Bitte absolute Adressen angeben in der Form: http://www.von_url.de"
        f.input :article_id, as: :number, hint: "Bitte ID des Artikels angeben"
      end
    f.actions
  end

  index as: :table, download_links: proc{ Goldencobra::Setting.for_key("goldencobra.backend.index.download_links") == "true" }.call do
    selectable_column
    column :id
    column :url
    column :article_id do |au|
      link_to au.article_id, edit_admin_article_path(id: au.article_id)
    end
    column :created_at
    column :updated_at
    actions defaults: false do |post|
      item "Delete", admin_article_url_path(post), method: :delete
    end
  end

  action_item :rewrite_urls, only: [:index] do
    link_to I18n.t('active_admin.article_url.rewrite_urls'), rewrite_urls_admin_article_urls_path()
  end

  collection_action :rewrite_urls do
    Goldencobra::ArticleUrl.recreate_all_urls
    flash[:notice] = I18n.t('active_admin.article_url.batch_action.flash.rewrite_urls')
    redirect_to action: :index
  end

  batch_action :rewrite_urls, "data-confirm" => I18n.t('active_admin.article_url.batch_action.flash.rewrite_urls') do |selection|
    Goldencobra::ArticleUrl.where(id: selection).each do |goldencobra_article_url|
      goldencobra_article_url.destroy
      goldencobra_article_url.article.save
    end
    flash[:notice] = I18n.t('active_admin.article_url.batch_action.flash.rewrite_urls')
    redirect_to action: :index
  end

  controller do
    def show
      show! do |format|
         format.html { redirect_to edit_admin_article_url_path(@article_url.id)}
      end
    end

    def create
      create! do |format|
         format.html { redirect_to admin_article_urls_path() }
      end
    end
  end
end
