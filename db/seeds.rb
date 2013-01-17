admin = Goldencobra::Role.find_or_create_by_name("admin")
guest = Goldencobra::Role.find_or_create_by_name("guest")
user = User.create!(:email => "admin@goldencobra.de", :password => "JejMU2bRcBX8uN", :password_confirmation => "JejMU2bRcBX8uN", :firstname => "Admin", :lastname => "Goldencobra")
user.confirm!
user.roles << admin

Goldencobra::Help.create!(:title => "Goldencobra", :description => "https://github.com/ikusei/Goldencobra")

Goldencobra::Article.create!(content: "Diese Seite existiert leider nicht.", url_name: "404", breadcrumb: "Seite nicht gefunden", title: "404")
Goldencobra::Article.create!(content: "", url_name: "search-results", breadcrumb: "Suchergebnisse", title: "Suchergebnisse")

Goldencobra::Permission.create(:sorter_id => 1, :role_id => Goldencobra::Role.find_by_name("admin").id, :action => "manage", :subject_class => ":all" )
Goldencobra::Permission.create(:sorter_id => 1, :role_id => Goldencobra::Role.find_by_name("guest").id, :action => "read", :subject_class => "Goldencobra::Article" )
Goldencobra::Permission.create(:sorter_id => 1, :role_id => Goldencobra::Role.find_by_name("guest").id, :action => "show", :subject_class => "User", :subject_id => "user.id" )
Goldencobra::Permission.create(:sorter_id => 1, :role_id => Goldencobra::Role.find_by_name("guest").id, :action => "update", :subject_class => "User", :subject_id => "user.id" )
Goldencobra::Permission.create(:sorter_id => 1, :role_id => Goldencobra::Role.find_by_name("guest").id, :action => "destroy", :subject_class => "User", :subject_id => "user.id" )