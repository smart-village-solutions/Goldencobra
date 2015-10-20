Rails.application.config.to_prepare do
  Goldencobra::Article.class_eval do
    has_one :<%= name.underscore %>, dependent: :destroy
    accepts_nested_attributes_for :<%= name.underscore %>

    after_create :init_default_<%= name.underscore %>

    def init_default_<%= name.underscore %>
      if (self.<%= name.underscore %>.blank? && self.article_type == "<%= name %> Show")
        self.<%= name.underscore %> = <%= name %>.new(article_id: self.id)
        self.save
      end
    end
  end
end
