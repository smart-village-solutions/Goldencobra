require "addressable/uri"

module Goldencobra
  class ArticleAdapter
    class << self

      # Alias method for find_by_url
      # @param url [String] "http://www.IkusEI.de/asdf/?asAAAa=12"
      # @param options = {} Options of method find_by_url
      #
      # @return [Integer] ArticleID
      def find(url, options = {})
        find_by_url(url, options)
      end

      # find an article id by a given url
      # @param url [String] "http://www.IkusEI.de/asdf/?asAAAa=12"
      # @param follow_redirection [Boolean] default: false
      #
      # If you use this method in a controller,
      # the controller should redirect to a redirection.
      #
      # If you use this method somewhere else, you should activate
      # follow_redirection:true to be sure you get the right article
      #
      # @return [Integer] ID of an article
      def find_by_url(url, follow_redirection: false)
        url_to_search = cleanup_url(url)
        url_to_search = follow_redirections(url_to_search) if follow_redirection
        Goldencobra::ArticleUrl.where(url: url_to_search).pluck(:article_id).first
      end

      # find an url by a given ID
      # @param search_id [Integer]
      #
      # @return [Array] list of urls
      def find_by_id(search_id)
        Goldencobra::ArticleUrl.where(article_id: search_id).pluck(:url)
      end

      private

      # return url to search for
      # @param url [String] "http://www.IkusEI.de/afasdf/?asAAAa=12"
      #
      # @return [String] "http://www.ikusei.de/afasdf/foo"
      def cleanup_url(url)
        uri = Addressable::URI.parse(url.strip).normalize
        # removes last '/' if one exists
        uri_path = uri.path.chomp("/")
        uri_host = uri.port == 80 ? uri.host : "#{uri.host}:#{uri.port}"
        URI.join("#{uri.scheme}://#{uri_host}", uri_path).to_s
      rescue
        nil
      end

      # follow redirections
      # @param url [String]
      #
      # @return [String] Found in table of redirections
      def follow_redirections(url)
        redirect_url, _redirect_code = Goldencobra::Redirector.get_by_request(url)
        redirect_url.present? ? redirect_url : url
      end
    end
  end
end