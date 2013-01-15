class AddDefaultUsersAndRoles < ActiveRecord::Migration
  def up
    admin = Goldencobra::Role.find_or_create_by_name("admin")
    guest = Goldencobra::Role.find_or_create_by_name("guest")
    user = User.create!(:email => "admin@goldencobra.de", :password => "JejMU2bRcBX8uN", :password_confirmation => "JejMU2bRcBX8uN", :firstname => "Admin", :lastname => "Goldencobra")
    user.roles << admin
  end

  def down
    User.scoped.destroy_all
    Goldencobra::Role.scoped.destroy_all
  end
end
