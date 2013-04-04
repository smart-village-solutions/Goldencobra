module Goldencobra
  class Tracking < ActiveRecord::Base
    attr_accessible :ip, :referer, :request, :session_id, :url
    serialize :request
  end
end
