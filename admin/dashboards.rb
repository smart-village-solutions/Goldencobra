# encoding: utf-8

ActiveAdmin.register_page "Dashboard" do
  menu priority: 0

  content do
    render(partial: "goldencobra/admin/dashboard/base_dashboard")


  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render "recent_posts" # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end

  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section 'last_updated_articles', priority: 1
  #   section "Recent User", priority: 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.
  end
end
