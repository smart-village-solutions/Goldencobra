# == Schema Information
#
# Table name: goldencobra_trackings
#
#  id             :integer          not null, primary key
#  request        :text
#  session_id     :string(255)
#  referer        :string(255)
#  url            :string(255)
#  ip             :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_agent     :string(255)
#  language       :string(255)
#  path           :string(255)
#  page_duration  :string(255)
#  view_duration  :string(255)
#  db_duration    :string(255)
#  url_paremeters :string(255)
#  utm_source     :string(255)
#  utm_medium     :string(255)
#  utm_term       :string(255)
#  utm_content    :string(255)
#  utm_campaign   :string(255)
#  location       :string(255)
#

module Goldencobra
  class Tracking < ActiveRecord::Base
    attr_accessible :ip, :referer, :request, :session_id, :url, :user_agent, :language, :url_paremeters, :path, :page_duration, :view_duration, :db_duration
    attr_accessible :utm_source, :utm_medium, :utm_term, :utm_content, :utm_campaign, :location
    serialize :url_paremeters

    default_scope order("created_at DESC")

    def self.analytics(request, location=nil)
      if Goldencobra::Setting.for_key("goldencobra.analytics.active") == "true"
        self.create! do |t|
          t.utm_source = request.params["utm_source"]
          t.utm_medium = request.params["utm_medium"]
          t.utm_term = request.params["utm_term"]
          t.utm_content = request.params["utm_content"]
          t.utm_campaign = request.params["utm_campaign"]
          t.url_paremeters = request.params
          t.language = request.env["HTTP_ACCEPT_LANGUAGE"]
          t.user_agent = request.env["HTTP_USER_AGENT"]
          t.session_id = request.session_options[:id]
          t.referer = request.referer
          t.url = request.url
          t.ip = request.env['REMOTE_ADDR']
          t.location = location.try(:city)
        end
      end
    end

  end
end

#http://localhost:4000/?utm_source=quelle&utm_medium=medium&utm_term=begriff&utm_content=content&utm_campaign=name
