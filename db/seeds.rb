User.delete_all
Goldencobra::Role.delete_all
admin = Goldencobra::Role.find_or_create_by_name("admin")
guest = Goldencobra::Role.find_or_create_by_name("guest")
user = User.create!(:email => "admin@goldencobra.de", :password => "2BTGAKJxukL6AB", :password_confirmation => "2BTGAKJxukL6AB", :firstname => "Admin", :lastname => "Goldencobra")
user.roles << admin

Goldencobra::Help.delete_all
Goldencobra::Help.create!(:title => "Goldencobra", :description => "https://github.com/ikusei/Goldencobra")

Goldencobra::Article.delete_all

Goldencobra::Article.create!(content: "Diese Seite existiert leider nicht.", url_name: "404", breadcrumb: "Seite nicht gefunden", title: "404",article_type: "Default Show")
Goldencobra::Article.create!(content: "kein Zugriff", url_name: "401", breadcrumb: "Kein Zugriff", title: "401",article_type: "Default Show")

Goldencobra::Permission.delete_all
Goldencobra::Permission.create(:sorter_id => 1, :role_id => Goldencobra::Role.find_by_name("admin").id, :action => "manage", :subject_class => ":all" )
Goldencobra::Permission.create(:sorter_id => 1, :role_id => Goldencobra::Role.find_by_name("guest").id, :action => "read", :subject_class => "Goldencobra::Article" )
Goldencobra::Permission.create(:sorter_id => 1, :role_id => Goldencobra::Role.find_by_name("guest").id, :action => "show", :subject_class => "User", :subject_id => "user.id" )
Goldencobra::Permission.create(:sorter_id => 1, :role_id => Goldencobra::Role.find_by_name("guest").id, :action => "update", :subject_class => "User", :subject_id => "user.id" )
Goldencobra::Permission.create(:sorter_id => 1, :role_id => Goldencobra::Role.find_by_name("guest").id, :action => "destroy", :subject_class => "User", :subject_id => "user.id" )

### START PAGE ###
puts "create start page article..."
start = Goldencobra::Article.find_by_title("Willkommen")
start = Goldencobra::Article.create!(title: "Willkommen", breadcrumb: "Willkommen", article_type: "Default Show", ancestry: nil, active: true, url_name: "willkommen", template_file: "application") if start.blank?
start.mark_as_startpage!