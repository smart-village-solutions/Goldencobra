Gem.loaded_specs['goldencobra'].dependencies.each do |d|
  next if d.name == "rubyzip"
  if d.name == "oa-oauth"
    require "omniauth/oauth"
  elsif d.name == "oa-openid"
    require "omniauth/openid"
  elsif d.name == "i18n-active_record"
    require "i18n/active_record"
  else
    require d.name
  end
end

require "goldencobra/engine"
module Goldencobra
end
