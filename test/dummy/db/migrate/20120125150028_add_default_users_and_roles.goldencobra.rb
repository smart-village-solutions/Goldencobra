# This migration comes from goldencobra (originally 20120124094000)
class AddDefaultUsersAndRoles < ActiveRecord::Migration
  def up
    admin = Goldencobra::Role.find_or_create_by_name("admin")
    guest = Goldencobra::Role.find_or_create_by_name("guest")
    user = User.create!(:email => "admin@goldencobra.de", :password => "administrator", :password_confirmation => "administrator")
    user.confirm!
    user.roles << admin
  end

  def down
    User.scoped.destroy_all
    Goldencobra::Role.scoped.destroy_all
  end
end
