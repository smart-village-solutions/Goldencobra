admin = Goldencobra::Role.find_or_create_by_name("admin")
guest = Goldencobra::Role.find_or_create_by_name("guest")
user = User.create!(:email => "admin@goldencobra.de", :password => "administrator", :password_confirmation => "administrator")
user.confirm!
user.roles << admin
