module Goldencobra
  class UrlBuilder
    def initialize(article, with_prefix=false)
      @article = article
      @with_prefix = with_prefix
    end

    def article_path
      if @article.is_startpage?
        remove_trailing_double_slashes("#{prefix + '/'}")
      else
        prefix + ancestry_path
      end
    end

    def absolute_base_url
      if Goldencobra::Setting.for_key("goldencobra.use_ssl") == "true"
        "https://#{Goldencobra::Setting.for_key('goldencobra.url')}"
      else
        "http://#{Goldencobra::Setting.for_key('goldencobra.url')}"
      end
    end

    def absolute_public_url
      if Goldencobra::Setting.for_key("goldencobra.use_ssl") == "true"
        "https://#{Goldencobra::Setting.for_key('goldencobra.url')}#{@article.article_path}"
      else
        "http://#{Goldencobra::Setting.for_key('goldencobra.url')}#{@article.article_path}"
      end
    end

    private

    def ancestry_path
      @article.path.select([:ancestry, :url_name, :startpage]).inject(String.new) do |string, article|
        unless article.startpage
          string + article.url_name + '/'
        end
      end
    end

    def prefix
      if @with_prefix
        "#{Goldencobra::Domain.current.try(:url_prefix)}/"
      else
        ''
      end
    end

    def remove_trailing_double_slashes(input)
      input.gsub(/\/\/$/,'/')
    end
  end
end