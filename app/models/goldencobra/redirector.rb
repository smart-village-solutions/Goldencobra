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
      uri_params = CGI::parse(uri.query.to_s)
      request_path = "#{uri.scheme}://#{uri.host}#{uri.path}%"
      redirects = Goldencobra::Redirector.active.where("source_url LIKE ?", request_path)
      if redirects.any?
        #if multiple redirectors found, select the first
        redirect = redirects.first
        redirecter_source_uri = URI.parse(redirect.source_url)
        if redirecter_source_uri.path == uri.path
          #Wenn die url parameter egal sind
          if redirect.ignore_url_params
            return [redirect.rewrite_target_url(uri.query), redirect.redirection_code]
          else
            #wenn die urlparameter nicht egal sind und identisch sind
            source_params = CGI::parse(redirecter_source_uri.query.to_s)
            if !source_params.map{|k,v| uri_params[k] == v}.include?(false)
              return [redirect.rewrite_target_url(uri.query), redirect.redirection_code]
            else
              return nil
            end
          end
        end
      else
        return nil
      end
    end


    def rewrite_target_url(uri_params)
      target_uri = URI.parse(self.target_url)
      if uri_params.present?
        return "#{target_uri.scheme}://#{target_uri.host}#{target_uri.path}?#{uri_params}"
      else
        return "#{target_uri.scheme}://#{target_uri.host}#{target_uri.path}"
      end
    end

  end
end
