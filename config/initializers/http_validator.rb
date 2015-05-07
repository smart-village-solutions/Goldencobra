# encoding: utf-8

module HttpValidator
  def web_url(*attr_names)
    include InstanceMethods
    cattr_accessor :url_attribute_names_to_check
    self.url_attribute_names_to_check = [] if self.url_attribute_names_to_check.blank?
    self.url_attribute_names_to_check << attr_names
    before_save :rewrite_web_url
  end

  module InstanceMethods
    def rewrite_web_url
      self.url_attribute_names_to_check.flatten.each do |attr_name|
        if self.respond_to?(attr_name) && self.send(attr_name).present? && value_without_protocol?(attr_name)
          self.send("#{attr_name.to_s}=", "http://#{self.send(attr_name)}")
        end
      end
    end

    def value_without_protocol?(attr_name)
      self.send(attr_name)[0..7] != "https://" && self.send(attr_name)[0..6] != "http://"
    end
  end
end

ActiveRecord::Base.extend HttpValidator
