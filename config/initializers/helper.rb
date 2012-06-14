Rails.application.config.to_prepare do
  ActionView::Base.send :include, ApplicationHelper
  ActionView::Base.send :include, ActionView::Helpers::UrlHelper
  ActionView::Base.send :include, ActionView::Helpers::TextHelper
end
