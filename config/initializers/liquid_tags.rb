class PartialRenderer < Liquid::Tag
  #include ActionController::RequestForgeryProtection

  def initialize(tag_name, message, tokens)
    super
    @partial_name = message.split("|")[0].to_s.strip
    if message.split('|')[1].present? && message.split('|')[1].include?(":")
      @options = message.split('|')[1].split(', ').map{ |h| h1, h2 = h.split(":"); { h1.strip.to_sym => h2.strip } }.reduce(:merge)
    else
      @options = {}
    end
  end

  def render(context)
    @options = @options.merge(:context => context)
    ActionController::Base.new.render_to_string(:partial => @partial_name, :layout => false, :locals => @options )
  end
end

Liquid::Template.register_tag('render_partial', PartialRenderer)



# {% navigation_menue 3 | id: css_id_name, class_name: test %}
class NavigationRenderer < Liquid::Tag
  #include ActionController::RequestForgeryProtection

  def initialize(tag_name, message, tokens)
    super
    @menue_title = message.split("|")[0].to_s.strip
    if message.split('|')[1].present? && message.split('|')[1].include?(":")
    	@options = message.split('|')[1].split(', ').map{ |h| h1, h2 = h.split(":"); { h1.strip => h2.strip } }.reduce(:merge)
    else
    	@options = {}
    end
  end

  def render(context)
    ActionController::Base.new.render_to_string(:partial => "/goldencobra/articles/navigation_menue", :layout => false, :locals => { :context => context, :menue_title => @menue_title, :options => @options })
  end
end

Liquid::Template.register_tag('navigation_menue', NavigationRenderer)