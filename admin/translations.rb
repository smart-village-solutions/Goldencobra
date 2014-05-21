# encoding: utf-8

ActiveAdmin.register Translation do
  menu :parent => I18n.t("settings", :scope => ["active_admin","menue"]), :label => I18n.t('active_admin.translations.as'), :if => proc{can?(:update, Translation)}

  controller.authorize_resource :class => Translation

  scope "Alle", :scoped
  scope :with_values
  scope :missing_values

  index do
    column :locale
    column :key
    column :value
    default_actions
  end

  form do |f|
    f.actions
    f.inputs I18n.t('active_admin.translations.general') do
      f.input :locale
      f.input :key
      f.input :value
    end
    f.actions
  end

end

