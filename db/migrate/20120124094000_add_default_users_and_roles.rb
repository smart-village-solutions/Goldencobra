class AddDefaultUsersAndRoles < ActiveRecord::Migration
  def up
    admin = Goldencobra::Role.find_or_create_by_name("admin")
    guest = Goldencobra::Role.find_or_create_by_name("guest")
    user = User.create!(:email => "admin@goldencobra.de", :password => "administrator", :password_confirmation => "administrator", :firstname => "Admin", :lastname => "Goldencobra")
    user.confirm!
    user.roles << admin
  end

  def down
    User.scoped.destroy_all
    Goldencobra::Role.scoped.destroy_all
  end
end
