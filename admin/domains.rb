# encoding: utf-8

ActiveAdmin.register Goldencobra::Domain, :as => "Domain" do
  menu :parent => "Einstellungen", :label => "Domains", :if => proc{can?(:update, Goldencobra::Domain)}

  index do
  	selectable_column
    column :id
    column :title
    column :hostname
    column :client
    column :url_prefix
    column :main do |d|
      d.main ? "X" : ""
    end
    default_actions
  end

  form html: { enctype: "multipart/form-data" }  do |f|
    f.actions
      f.inputs do
        f.input :title
        f.input :hostname
        f.input :client
        f.input :url_prefix
        f.input :main, :hint => "Diese Domain wird als Hauptdomain eingerichtet, alle Canonical URLS haben diesen Prefix", :label => "Main Domain?"
      end
    f.actions
  end

end