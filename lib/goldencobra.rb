Gem.loaded_specs["goldencobra"].dependencies.each do |d|
  next if %w(wkhtmltopdf-binary rubyzip sinatra).include?(d.name)
  begin
    if d.name == "oa-oauth"
      require "omniauth/oauth"
    elsif d.name == "oa-openid"
      require "omniauth/openid"
    elsif d.name == "addressable"
      require 'addressable/uri'
    elsif d.name == "rack/showexceptions"
      require "rack/show_exceptions"
    elsif [
        "annotate", "guard-annotate", "pry", "pry-nav", "better_errors", "yard"
      ].include?(d.name)
      #nichts tun
    else
      require d.name
    end
  rescue LoadError
    # Some gem names are like this "rack-utf8_sanitizer". You'll get a LoadError. The require needs
    # to load the gem as "rack/utf8_sanitizer"
    require d.name.sub("-","/")
  end
end


require "goldencobra/engine"

module Goldencobra
end
