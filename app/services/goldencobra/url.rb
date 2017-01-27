class Goldencobra::Url
  class << self
    def to_s
      @url ||= build_url
    end

    def use_ssl?
      Goldencobra::Setting.for_key("goldencobra.use_ssl") == "true"
    end

    def protocol
      use_ssl? ? "https" : "http"
    end

    def host
      Goldencobra::Setting.for_key("goldencobra.url").gsub(/(http|https):\/\//, "")
    end

    private

    def build_url
      "#{protocol}://#{host}"
    end
  end
end
