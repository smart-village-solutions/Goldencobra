module Goldencobra
  class Tracking < ActiveRecord::Base
    attr_accessible :ip, :referer, :request, :session_id, :url, :user_agent, :language
  end
end
