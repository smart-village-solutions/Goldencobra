#Goldencobra

[![Build Status](https://secure.travis-ci.org/[ikusei]/[Goldencobra].png)](http://travis-ci.org/[ikusei]/[Goldencobra])

This Project is under development

#Powered by
- ActiveAdmin

#Installation
    gem 'goldencobra', :git => "git://github.com/ikusei/Goldencobra.git"  

And then  

    rails generate goldencobra:install`

This installs all necessary files and creates sensible defaults.
        
        
#Settings
        
        We have a quite flexible settings system in place.
        In the admin backend you have many values you can customize for your installation.  
        
        Important values are 
        * Goldencobra-Facebook-AppId
        * Goldencobra-url  


When creating articles, a default value is set for open graph image url. Please make sure you provide a default open graph image at "/assets/open-graph.png"
        

#Usage
        
##Navigation Menu
call in any view_template:  

    navigation_menu(manue_id, option={})
    
`option:
    :depth => integer`  
0 = unlimited, 1 = self, 2 = self and children 1. grades, 3 = self and up to children 2.grades,   default = 0`


**example:**

- `<%= navigation_menu(1, :depth => 1) %>`  
renders Menue startign with id 1 and only childs of first grade  
- `<%= navigation_menu(2) %>`  
 renders Menue startign with id 2 and all children as a nested list  
        
##Rendering content in layouts
    <%= yield(:article_content) %>  
    <%= yield(:article_title) %>    
    <%= yield(:article_subtitle) %>                         
    <%= yield(:article_teaser) %>  
        
##Include social media sharing buttons where applicable  
    
    <div id="social_sharing_buttons" class="bottom_buttons">  
      <%= yield(:social_sharing_buttons) %>  
    </div>  
  

##Render an image gallery inside article content      
    <%= render_article_image_gallery %>  

