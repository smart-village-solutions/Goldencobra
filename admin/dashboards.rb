ActiveAdmin::Dashboards.build do

  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.

  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
   section I18n.t('last_updated_articles', scope: [:dashboard_sections, :active_admin]), priority: 1, :if => proc{can?(:update, Goldencobra::Article)} do
    table do
      tr do
        [t(:title, scope: [:activerecord, :attributes, "goldencobra/article"]), t(:updated_at, scope: [:activerecord, :attributes, "goldencobra/article"]), t(:edit, scope: :active_admin)].each do |sa|
          th sa
        end
      end

      Goldencobra::Article.recent(5).collect do |article|
        tr do
          td article.title
          td l(article.updated_at, format: :short)
          td link_to(t(:edit), admin_article_path(article))
        end
      end
    end
   end

  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end

  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section 'last_updated_articles', :priority => 1
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.

end
