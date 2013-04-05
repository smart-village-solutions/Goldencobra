module Goldencobra
  class Tracking < ActiveRecord::Base
    attr_accessible :ip, :referer, :request, :session_id, :url, :user_agent, :language, :url_paremeters, :path, :page_duration, :view_duration, :db_duration
    attr_accessible :utm_source, :utm_medium, :utm_term, :utm_content, :utm_campaign
    serialize :url_paremeters

    default_scope order("created_at DESC")

    def self.analytics(request)
      if Goldencobra::Setting.for_key("goldencobra.analytics.active") == "true"
        self.create!(:utm_source => request.params["utm_source"],
                     :utm_medium => request.params["utm_medium"],
                     :utm_term => request.params["utm_term"],
                     :utm_content => request.params["utm_content"],
                     :utm_campaign => request.params["utm_campaign"],
                     :url_paremeters => request.params,
                     :language => request.env["HTTP_ACCEPT_LANGUAGE"],
                     :user_agent => request.env["HTTP_USER_AGENT"],
                     :session_id => request.session_options[:id],
                     :referer => request.referer,
                     :url => request.url,
                     :ip => request.env['REMOTE_ADDR'] )
      end
    end

  end
end

#http://localhost:4000/?utm_source=quelle&utm_medium=medium&utm_term=begriff&utm_content=content&utm_campaign=name