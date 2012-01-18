admin = Goldencobra::Role.create(:name => "admin")
guest = Goldencobra::Role.create(:name => "guest")
user = Goldencobra::User.create!(:email => "admin@goldencobra.de", :password => "YMdgDmhQwF83hw", :password_confirmation => "YMdgDmhQwF83hw")
user.confirm!
user.roles << admin
