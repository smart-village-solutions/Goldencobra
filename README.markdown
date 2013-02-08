#Goldencobra

[![Build Status](https://secure.travis-ci.org/ikusei/Goldencobra.png)](http://travis-ci.org/ikusei/Goldencobra)

This Project is under development

#Powered by
- ActiveAdmin

Installation of Goldencobra into a fresh Ruby on Rails project:

#Requirements
* Ruby 1.9.2-p180+ (recommended 1.9.3-p286)
* Rails 3.2.8
* Mysql 5.5.x (tested with e.g. 5.5.19)


#Guided Installation wit rvm,git,capistrano and server deploy
```ruby
rails new PROJECTNAME -m https://raw.github.com/ikusei/goldencobra-installer/master/template.rb -d mysql
```

#OR Manual Installation: Create new project
``` ruby
rails new PROJECTNAME -d mysql
```

#Install Goldencobra gem
Add the following to file "PROJECTNAME/Gemfile":
``` ruby
gem 'goldencobra', git: 'git://github.com/ikusei/Goldencobra.git'
gem 'activeadmin', :git => 'git://github.com/ikusei/active_admin.git', :require => 'activeadmin'
```

```ruby
bundle install
```

#Create database
```ruby
rake db:create
```

#Install prerequisites for Goldencobra
```ruby
rake goldencobra:install:migrations
rails generate goldencobra:install
rake db:migrate db:test:prepare
```

#Setup Goldencobra

If you want to use Batch Actions in Goldencobra (set a batch of articles offline), you need to uncomment the line `# config.batch_actions = true` in config/initializers/active_admin.rb

This would also be the place where you can override stylesheets and javascripts. Just put them inside the block `# == Register Stylesheets & Javascripts`.

#Create new article types
Nearly every site in Goldencobra is an article. If the default article isn't enough for your needs you can create new article types. There's a generator for that:
`rails generate goldencobra:articletype Thing name:string`

Where "Thing" would be your associated model and "name:string" are the usual ruby attributes.

This will create:
```ruby
    generate model Thing # Your associated model
    generate /app/views/articletypes
    generate /app/views/articletypes/thing # View folder
    # Necessary view files
    generate /app/views/articletypes/thing/_index.html.erb
    generate /app/views/articletypes/thing/_show.html.erb
    generate /app/views/articletypes/thing/_edit_show.html.erb
    generate /app/views/articletypes/thing/_edit_index.html.erb
```
The index and show partials are for fronted display of your article type. The "_edit" partials are for the ActiveAdmin.

"Index" is always the index view of articles of this article_type. The _edit_index enables you to set certain tags to filter your index view. Of course everything is customizable by you.

"Show" is an individual article of this article_type. The "_edit_show" gives you control over the models attributes.


#Settings

We have a quite flexible settings system in place.
In the admin backend you have many values you can customize for your installation.

Important values are
* Goldencobra-Facebook-AppId
* Goldencobra-url (should be set without http:// in front)
* Commentator: If you have a different frontend user model (like 'Visitor') you can set this here. Default is User.
* Bugherd: If you use [Bugherd.com](http://www.bugherd.com) for tracking frontend problems for your website you should enter the project's API key here. You can further decide wich User should be logged in to be able to track bugs.
* You have can enable or disable Solr Search Server and decide wether you want to recreate all menues and widgets after updating them. This might be useful for caching.


When creating articles, a default value is set for open graph image url. Please make sure you provide a default open graph image at "/assets/open-graph.png"


#Usage

##Basic Headers
call in head-section of any view_template to include stylesheets, javascripts (jquery, jqueryui, jquery.tools ...), bugtracker, metatags, airbrake and article_administration element:

```ruby
basic_goldencobra_headers(option={})

# option: {:exclude => ["stylesheets", "javascripts", "bugtracker", "metatags", "article_administration", "airbrake"]}
```

**example:**

```erb
<%= basic_goldencobra_headers(:exclude => ["javascripts","stylesheets"]) %>
```

##Only Activate Bugtracker in Application Layout
place this code in your application layout in header section:
`<%= bugtracker %>`


##Navigation Menu
call in any view_template:

```ruby
navigation_menu(menue_id, option={})

# option: { depth: integer }
#
# 0 = unlimited
# 1 = self
# 2 = self and children 1st grade
# 3 = self and up to children 2nd grade
# default = 0
```


**example:**

```ruby
<%= navigation_menu(1, :depth => 1) %>
# renders menue starting with id 1 and only childs of first grade
```

```ruby
<%= navigation_menu(2) %>
# renders menue starting with id 2 and all children as a nested list
```

```ruby
<%= navigation_menu("MainNavigation") %>
# renders menue starting with first Menuitem including title 'MainNavigation' and all children as a nested list
```

##Rendering content in layouts
```erb
<% # Renders contents of different article types %>
<% if @article %>
  <%= render_article_type_content() %>
<% end %>

<%= yield(:article_content) %>
<%= yield(:article_title) %>
<%= yield(:article_subtitle) %>
<%= yield(:article_teaser) %>
```

##Render widgets
```erb
<%= render_article_widgets(tagged_with: "slider", wrapper: "div", class: "slide-content") %>
#
```


##Include social media sharing buttons where applicable
```erb
<div id="social_sharing_buttons" class="bottom_buttons">
  <%= yield(:social_sharing_buttons) %>
</div>
```

##Render an image gallery inside article content
```erb
<%= render_article_image_gallery %>
```

