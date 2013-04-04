module Goldencobra
  class Tracking < ActiveRecord::Base
    attr_accessible :ip, :referer, :request, :session_id, :url, :user_agent, :language

    def self.analytics(request)
      if Goldencobra::Setting.for_key("goldencobra.analytics.active") == "true"
        self.create!(:language => request.env["HTTP_ACCEPT_LANGUAGE"], :user_agent => request.env["HTTP_USER_AGENT"], :session_id => request.session_options[:id], :referer => request.referer, :url => request.url, :ip => request.env['REMOTE_ADDR'] )
      end
    end

  end
end
