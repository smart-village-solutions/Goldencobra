require 'factory_girl'

Factory.define :article, :class => Goldencobra::Article do |u|
  u.title "Article Title"
  u.url_name "short-title"
  u.startpage false
end


Factory.define :menue, :class => Goldencobra::Menue do |u|
  u.title 'Nachrichten'
  u.target 'www.ikusei.de'
  u.active true
  u.css_class 'news'
end


Factory.define :admin_user, :class => User do |u|
  u.email 'admin@test.de'
  u.password 'secure12'
  u.password_confirmation 'secure12'
  u.confirmed_at "2012-01-09 14:28:58"
end

Factory.define :guest_user, :class => User do |u|
  u.email 'guest@test.de'
  u.password 'secure12'
  u.password_confirmation 'secure12'
end

Factory.define :startpage, :class => Goldencobra::Article do |u|
  u.title "Startseite"
  u.url_name "root"
end

Factory.define :role, :class => Goldencobra::Role do |r|
  r.name "admin"
end


Factory.define :admin_role, :class => Goldencobra::Role do |r|
  r.name "admin"
end

Factory.define :guest_role, :class => Goldencobra::Role do |r|
  r.name "guest"
end
