ActiveAdmin.register Goldencobra::Template, as: "Template" do
  menu parent: I18n.t("settings", scope: ["active_admin","menue"]),
       label: I18n.t("active_admin.template.as"), if: proc{can?(:update, Goldencobra::Article)}
end
