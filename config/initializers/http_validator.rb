module HttpValidator
  def web_url(*attr_names)
    include InstanceMethods
    cattr_accessor :url_attribute_names_to_check
    self.url_attribute_names_to_check = attr_names
    before_save :rewrite_web_url
  end

  module InstanceMethods
    def rewrite_web_url
      self.url_attribute_names_to_check.each do |attr_name|
        if self.respond_to?(attr_name) && self.send(attr_name).present? && self.send(attr_name)[0..6] != "http://"
          self.send("#{attr_name.to_s}=", "http://#{self.send(attr_name)}")
        end
      end
    end
  end

end

ActiveRecord::Base.extend HttpValidator

