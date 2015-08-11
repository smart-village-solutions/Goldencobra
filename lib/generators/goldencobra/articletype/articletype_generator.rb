module Goldencobra
  module Generators
    class ArticletypeGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)
      argument :model_attributes, type: :array, default: [], banner: 'model:attributes'

      def create_articletype_files
        #TODO: Check if class name already exists and abort if true
        generate('model', "#{name} #{model_attributes.join(' ')} article_id:integer")
      end

      def create_partials
        #TODO: Check if class name already exists and abort if true
        copy_file 'index.html.erb', "app/views/articletypes/#{name.underscore}/_index.html.erb"
        copy_file 'show.html.erb', "app/views/articletypes/#{name.underscore}/_show.html.erb"
        template 'edit_show.html.erb', "app/views/articletypes/#{name.underscore}/_edit_show.html.erb"
        copy_file 'edit_articletype.html.erb', "app/views/articletypes/#{name.underscore}/_edit_articletype.html.erb"
        copy_file 'edit_index.html.erb', "app/views/articletypes/#{name.underscore}/_edit_index.html.erb"
        template 'initializer.rb', "config/initializers/goldencobra_#{name.underscore}.rb"
      end

      def updates_model
        inject_into_class "app/models/#{name.underscore}.rb", name.constantize do
          "belongs_to :article, class_name: Goldencobra::Article\nSortOptions = []\ndef fulltext_searchable_text\n''\nend\n"
        end
      end

    end
  end
end
