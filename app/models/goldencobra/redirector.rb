# encoding: utf-8

module Goldencobra
  class Redirector < ActiveRecord::Base
    attr_accessible :active, :redirection_code, :source_url, :target_url, :ignore_url_params, :include_subdirs, :import_csv_data

    attr_accessor :import_csv_data

    validates_presence_of :source_url, :if => proc { |obj| obj.import_csv_data.blank? }
    validates_presence_of :target_url, :if => proc { |obj| obj.active == true && obj.import_csv_data.blank? }

    validates_uniqueness_of :source_url

    web_url :source_url, :target_url

    scope :active, where(:active => true)

    validate :check_csv_data
    after_create :create_multiples_from_csv_data


    # Creates multiple new Redirections based on 'import_csv_data'
    # and deletes this single, new, invalid record afterwards  
    # 
    # @return [Goldencobra::Redirector] 
    def create_multiples_from_csv_data
      if import_csv_data.present?
          data = CSV.parse(import_csv_data, { :col_sep => "," })
          Goldencobra::Redirector.transaction do
            data.each do |row|
              Goldencobra::Redirector.create(source_url: row[0].strip, target_url: row[1].strip, redirection_code: redirection_code, active: active, ignore_url_params: ignore_url_params )
            end
          end
          self.destroy
      end
    end

    def check_csv_data
      if import_csv_data.present?
        begin
          all_source_urls = Goldencobra::Redirector.where(:active => true).pluck(:source_url)
          data = CSV.parse(import_csv_data, { :col_sep => "," })
          source_urls_from_data = data.map{|a| a[0].strip}
          if source_urls_from_data.length != source_urls_from_data.uniq.length
            errors.add(:import_csv_data, "Die CSV Daten enthalten mehrere Zeilen mit gleichen Source URLs<br>" )
          end
          data.each_with_index do |row, index|
            if row.length != 2
              errors.add(:import_csv_data, "Format der CSV Datei hat nicht 2 Spalten in Zeile #{index + 1}<br>" )
            end
            if all_source_urls.include?(row[0].strip)
              errors.add(:import_csv_data, "Source URL in Zeile #{index + 1} existiert bereits<br>" )
            end
          end
        rescue 
          errors.add(:import_csv_data, "Die CSV Daten sind leider ungültig")
        end
      end
    end
    
    # 
    # Returns a target url where to redirect of a given url
    # @param request_original_url [String] SourceURl of Request
    # 
    # @return [Array] target url to rewrite to | status code for redirection
    def self.get_by_request(request_original_url)
      begin
        uri = URI.parse(request_original_url)
      rescue
        uri = nil
      end
      if uri.present?
        uri_params = Rack::Utils.parse_nested_query(uri.query.to_s)
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
              source_params = Rack::Utils.parse_nested_query(redirecter_source_uri.query.to_s)
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
      else
        return nil
      end
    end


    # Helper Method for rewriting urls
    # @param uri_params [String] foo=bar&test=12
    # 
    # @return [String] TargetURl of given Redirector merged with source params
    def rewrite_target_url(uri_params)
      Goldencobra::Redirector.add_param_to_url(self.target_url, uri_params)
    end

    # Add a url-params tu an url
    # @param url [string] "http://www.test.de" || "http://www.test.de?test=a"
    # @param uri_params [string] "foo=bar"
    # 
    # @return [string] "http://www.test.de?test=a&foo=bar"
    def self.add_param_to_url(url, uri_params)
      target_uri = URI.parse(url)
      target_params = Rack::Utils.parse_nested_query(target_uri.query.to_s)
      request_params = Rack::Utils.parse_nested_query(uri_params)
      merged_params = target_params.merge(request_params)
      if merged_params.present?
        return "#{target_uri.scheme}://#{target_uri.host}#{target_uri.path}?#{merged_params.to_param}"
      else
        return "#{target_uri.scheme}://#{target_uri.host}#{target_uri.path}"
      end
    end

  end
end
