# encoding: utf-8

module Goldencobra
  class Redirector < ActiveRecord::Base
    attr_accessible :active, :redirection_code, :source_url, :target_url, :ignore_url_params, :include_subdirs

    validates_presence_of :source_url
    validates_presence_of :target_url

    web_url :source_url, :target_url

    scope :active, where(:active => true)

    def self.get_by_request(request_original_url)
      uri = URI.parse(request_original_url)
      uri_params = CGI::parse(uri.query)
      request_path = "#{uri.scheme}://#{uri.host}#{uri.path}"
      redirects = Goldencobra::Redirector.active.where("source_url LIKE '?%'", request_path)
      if redirects.any?
        redirect = redirects.first
        redirecter_source_uri = URI.parse(redirect.source_url)
        if redirect.include_subdirs
          return redirect
        else
          if redirecter_source_uri.path == uri.path
            return redirect
          else
            return nil
          end
        end

        #Wenn die url parameter egal sind
        if redirect.ignore_url_params
          return redirect
        else
          #wenn die urlparameter nicht egal sind und identisch sind
          if uri_params == CGI::parse(redirecter_source_uri.query)
            return redirect
          else
            return nil
          end
        end
      else
        return nil
      end
    end

  end
end
