Gem.loaded_specs['goldencobra'].dependencies.each do |d|
  next if %w(wkhtmltopdf-binary rubyzip).include?(d.name)

  begin 
    if d.name == "oa-oauth"
      require "omniauth/oauth"
    elsif d.name == "oa-openid"
      require "omniauth/openid"
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
