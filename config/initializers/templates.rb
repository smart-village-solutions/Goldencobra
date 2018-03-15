Rails.application.config.to_prepare do
  if ActiveRecord::Base.connection.table_exists?("goldencobra_templates")
    # Beim starten der Application wird das Verzeichnis /app/views/layouts durchsucht nach
    # neuen Templatefiles und erzeugt für diese dann eine Goldencobra::Template
    Goldencobra::Template.layouts_for_select.each do |template_file_name|
      template = Goldencobra::Template.where(layout_file_name: template_file_name).first
      unless template
        template = Goldencobra::Template.create(layout_file_name: template_file_name, title: template_file_name)
        Goldencobra::Articletype.all.each do |at|
          at.templates << template
        end
      end
    end
  end
end
