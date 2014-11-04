# encoding: utf-8

ActiveAdmin.register Goldencobra::Redirector, :as => "Redirector" do
  menu :parent => I18n.t("settings", :scope => ["active_admin","menue"]), :label => I18n.t('active_admin.redirector.as'), :if => proc{can?(:update, Goldencobra::Redirector)}

  controller.authorize_resource :class => Goldencobra::Redirector


end