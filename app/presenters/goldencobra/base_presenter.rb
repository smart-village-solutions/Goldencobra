module Goldencobra
  class BasePresenter
    include ActionController::Rendering

    def initialize(object, template, associated_object=nil)
      @object = object
      @template = template
    end

    def self.presents(name)
      define_method(name) do
        @object
      end
    end

    def h
      @template
    end
  end
end
