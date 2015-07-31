module Goldencobra
  class ArticleCustomSerializer < ArticleSerializer
    root false

    # Includes all defined methods
    def attributes
      data = {}
      if scope
        scope.split(",").each do |field|
          next unless whitelist_attributes.include?(field.to_sym)
          data[field.to_sym] = object.send(field.to_sym)
        end
      end
      data[:child_ids] = object.send(:child_ids)
      data
    end

    private

      def whitelist_attributes
        Goldencobra::Article.attribute_names.map(&:to_sym)
      end
  end
end
