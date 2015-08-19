# encoding: utf-8

ActiveAdmin.register Goldencobra::Role, :as => "Role" do
  menu :parent => I18n.t("settings", :scope => ["active_admin","menue"]), :label => I18n.t('active_admin.roles.as'), :if => proc{can?(:update, Goldencobra::Role)}

  filter :name

  action_item :prev_item, only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/prev_item'
  end

  action_item :next_item, only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/next_item'
  end

end