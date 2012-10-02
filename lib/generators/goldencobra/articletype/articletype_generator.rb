module Goldencobra
  module Generators
    class ArticletypeGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)
      argument :model_attributes, type: :array, default: [], banner: "model:attributes"

      def create_articletype_files
        generate("model", "#{name} #{model_attributes.join(' ')}")
      end

      def create_partials
        copy_file 'index.html.erb', "app/views/articletypes/#{name.underscore}/_index.html.erb"
        copy_file 'show.html.erb', "app/views/articletypes/#{name.underscore}/_show.html.erb"
        template 'edit_show.html.erb', "app/views/articletypes/#{name.underscore}/_edit_show.html.erb"
        copy_file 'edit_index.html.erb', "app/views/articletypes/#{name.underscore}/_edit_index.html.erb"
      end

    end
  end
end
