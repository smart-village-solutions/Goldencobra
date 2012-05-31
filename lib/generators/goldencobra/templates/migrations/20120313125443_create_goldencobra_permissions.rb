class CreateGoldencobraPermissions < ActiveRecord::Migration
  def self.up
    create_table :goldencobra_permissions do |t|
      t.string :action
      t.string :subject_class
      t.string :subject_id
      t.integer :role_id

      t.timestamps
    end
    
    Goldencobra::Permission.create(:role_id => Goldencobra::Role.find_by_name("admin").id, :action => "manage", :subject_class => ":all" )
    Goldencobra::Permission.create(:role_id => Goldencobra::Role.find_by_name("guest").id, :action => "read", :subject_class => "Goldencobra::Article" ) 
    Goldencobra::Permission.create(:role_id => Goldencobra::Role.find_by_name("guest").id, :action => "show", :subject_class => "User", :subject_id => "user.id" )
    Goldencobra::Permission.create(:role_id => Goldencobra::Role.find_by_name("guest").id, :action => "update", :subject_class => "User", :subject_id => "user.id" )
    Goldencobra::Permission.create(:role_id => Goldencobra::Role.find_by_name("guest").id, :action => "destroy", :subject_class => "User", :subject_id => "user.id" )    
  end
  
  def self.down
    drop_table :goldencobra_permissions
  end
  
end
