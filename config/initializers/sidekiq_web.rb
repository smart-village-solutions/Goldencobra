if RUBY_VERSION.to_f >= 1.9
  require "sidekiq/web"
  # Make Sinatra and Rails share a session to prevent CSRF errors when using Sidekiq web
  # interface: https://github.com/mperham/sidekiq/issues/1289#issuecomment-232330804
  Sidekiq::Web.set(:session_secret, Rails.application.secrets[:secret_key_base])
end

