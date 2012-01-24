admin = Goldencobra::Role.find_or_create_by_name("admin")
guest = Goldencobra::Role.find_or_create_by_name("guest")
user = User.create!(:email => "admin@goldencobra.de", :password => "YMdgDmhQwF83hw", :password_confirmation => "YMdgDmhQwF83hw")
user.confirm!
user.roles << admin
