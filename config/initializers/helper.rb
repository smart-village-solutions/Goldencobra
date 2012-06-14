Rails.application.config.to_prepare do
  ActionView::Base.send :include, ApplicationHelper
  ActionView::Base.send :include, UrlHelper
end
