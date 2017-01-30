require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require
require "goldencobra"

module Dummy
  class Application < Rails::Application

    require 'pdfkit'
    config.middleware.use PDFKit::Middleware, :print_media_type => true

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Europe/Berlin'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :en
    config.i18n.default_locale = :de
    config.i18n.locale = :de

    config.before_configuration do
      I18n.load_path += Dir[Rails.root.join('config', 'locales','*.{rb,yml}').to_s]
      ::Rails::Engine.subclasses.map(&:instance).select{|a| a.engine_name.include?("goldencobra")}.each do |engine|
        I18n.load_path += Dir[engine.root.join('config', 'locales','*.{rb,yml}').to_s]
      end
      I18n.default_locale = :de
      I18n.locale = :de
      I18n.reload!
    end

    config.i18n.enforce_available_locales = false

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    # config.active_record.whitelist_attributes = true
    Date::DATE_FORMATS.merge!(:default => '%d.%m.%Y')
    Time::DATE_FORMATS.merge!(:default => '%d.%m.%Y %H:%M')

    # Enable the asset pipeline
    config.assets.enabled = true

    # Currently, Active Record suppresses errors raised within `after_rollback`/`after_commit`
    # callbacks and only print them to the logs. In the next version, these errors will no longer be suppressed.
    # Instead, the errors will propagate normally just like in other Active Record callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # config.after_initialize do |app|
    #   if defined?(ActiveAdmin) and ActiveAdmin.application
    #     # Try enforce reloading after app bootup
    #     Rails.logger.info("==== Reloading ActiveAdmin")
    #     ActiveAdmin.application.unload!
    #     I18n.reload!
    #     self.reload_routes!
    #   end
    #     Rails.logger.warn("==== Locale #{I18n.locale}")
    # end

    # belongs_to will now trigger a validation error by default if the association is not present.
    # This can be turned off per-association with optional: true.
    #
    # This default will be automatically configured in new applications. If existing application
    # want to add this feature it will need to be turned on in an initializer.
    config.active_record.belongs_to_required_by_default = true

    # Rails 5 now supports per-form CSRF tokens to mitigate against code-injection attacks with
    # forms created by JavaScript. With this option turned on, forms in your application will each
    # have their own CSRF token that is specified to the action and method for that form.
    config.action_controller.per_form_csrf_tokens = true

    # You can now configure your application to check if the HTTP Origin header should be checked
    # against the site's origin as an additional CSRF defense. Set the following in your config to
    # true:
    config.action_controller.forgery_protection_origin_check = true
  end
end

