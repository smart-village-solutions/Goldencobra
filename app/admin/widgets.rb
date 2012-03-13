ActiveAdmin.register Goldencobra::Widget, as: "Widget" do
  menu parent: "Content-Management", label: "Widget"

  form html: { enctype: "multipart/form-data" } do |f|
    f.inputs "Allgemein" do
      f.input :title
      f.input :content
      f.input :css_name
      f.input :active
    end

    f.inputs "Artikel" do
      f.input :articles, :as => :check_boxes, :collection => Goldencobra::Article.find(:all, :order => "title ASC")
    end
    f.inputs "" do
      f.actions
    end
  end

  show :title => :title do
    panel "Widget" do
      attributes_table_for widget do
        [:title, :content, :css_name, :active].each do |a|
          row a
        end
      end
    end
    panel "Articles" do
      table do
        tr do
          ["Title", "url_name"].each do |ta|
            th ta
          end
        end
        widget.articles.each do |wa|
          [wa.title, wa.url_name].each do |watd|
            td watd
          end
        end
      end
    end
  end
end
