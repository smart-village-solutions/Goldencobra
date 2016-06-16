require "addressable/uri"

module Goldencobra
  class ArticleAdapter
    class << self

      # find an article ID by an given url
      # @param url [String] "http://www.IkusEI.de/afasdf/?asAAAa=12"
      # @param follow_redirection [Boolean] default: false
      #
      # If you use this method in an controller,
      # the controller should redirect to a redirection.
      #
      # If you use this method somewhere else, you should activate
      # follow_redirection:true to be sure you get the right article
      #
      # @return [Integer] ID of an article
      def find(url, follow_redirection: false)
        url_to_search = cleanup_url(url)
        url_to_search = follow_redirections(url_to_search) if follow_redirection
        Goldencobra::ArticleUrl.where(url: url_to_search).pluck(:article_id).first
      end

      private
      # return url to search for
      # @param url [String] "http://www.IkusEI.de/afasdf/?asAAAa=12"
      #
      # @return [String] "http://www.ikusei.de/afasdf/foo"
      def cleanup_url(url)
        uri = Addressable::URI.parse(url.strip).normalize
        # removes first and last '/' if one exists
        uri_path = uri.path.reverse.chomp("/").reverse.chomp("/")
        "#{uri.scheme}://#{uri.host}/#{uri_path}"
      end

      # follow redirections
      # @param url [String]
      #
      # @return [Striing] Found in tabel of redirections
      def follow_redirections(url)
        redirect_url, _redirect_code = Goldencobra::Redirector.get_by_request(url)
        return redirect_url if redirect_url.present?
        url
      end
    end
  end
end