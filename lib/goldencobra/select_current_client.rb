# Selects the client by hostname
module Goldencobra
  module SelectCurrentClient
    def self.included(base)
      base.class_eval do
        include InstanceMethods
        extend ClassMethods
        before_filter :determine_client
        before_filter :add_view_path_for_client
        helper_method :current_client
      end
    end

    module InstanceMethods
      def current_client
        @current_client
      end

      private

      def determine_client
        @current_client = Goldencobra::Domain.find_by_hostname(request.host) || Goldencobra::Domain.first
      end

      def add_view_path_for_client
        if @current_client.present?
          @_lookup_context.view_paths.unshift("app/views/#{@current_client.client}")
        end
      end
    end

    module ClassMethods
    end
  end
end

::ActionController::Base.send :include, Goldencobra::SelectCurrentClient