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