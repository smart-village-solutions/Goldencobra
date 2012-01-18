require 'factory_girl'

FactoryGirl.define do
  factory :article do
    title "Article Title"
    url_name "Short Title"
    startpage false
  end

  factory :role do 
    name "admin" 
  end
  
  factory :menue do
    title "Nachrichten"
    target "www.ikusei.de"
    active true
    css_class "news"
  end

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
  #u.confirmed_at "2012-01-09 14:28:58"
end

Factory.define :startpage, :class => Article do |u|
  u.title "Startseite"
end

Factory.define :admin_role, :class => Role do |r|
  r.name "admin"
end

Factory.define :guest_role, :class => Role do |r|
  r.name "guest"
end
