class PartialRenderer < Liquid::Tag
  #include ActionController::RequestForgeryProtection

  def initialize(tag_name, message, tokens)
    super
    @message = message
  end

  def render(context)
    ActionController::Base.new.render_to_string(:partial => @message.strip, :layout => false, :locals => {:context => context})
  end
end

Liquid::Template.register_tag('render_partial', PartialRenderer)



# {% navigation_menue 3 | id: css_id_name, class_name: test %}
class NavigationRenderer < Liquid::Tag
  #include ActionController::RequestForgeryProtection

  def initialize(tag_name, message, tokens)
    super
    @menue_id = message.split("|")[0].to_s.strip
    if message.split('|')[1].present? && message.split('|')[1].include?(":")
    	@options = message.split('|')[1].split(', ').map{|h| h1,h2 = h.split(":"); {h1.strip => h2.strip}}.reduce(:merge)
    else
    	@options = {}
    end
  end

  def render(context)
    ActionController::Base.new.render_to_string(:partial => "/goldencobra/articles/navigation_menue", :layout => false, :locals => {:context => context, :menue_id => @menue_id, :options => @options })
  end
end

Liquid::Template.register_tag('navigation_menue', NavigationRenderer)