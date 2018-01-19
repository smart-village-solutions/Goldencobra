require "sidekiq/web" if RUBY_VERSION.to_f >= 1.9

Goldencobra::Engine.routes.draw do
  get "switch_language/:locale"        => "articles#switch_language", as: :switch_language
  get "frontend_logout/:usermodel"     => "sessions#logout", as: :frontend_logout
  get "manage/render_admin_menue"      => "manage#render_admin_menue"
  get "call_for_support"               => "manage#call_for_support"
  post "frontend_login/:usermodel"     => "sessions#login", as: :frontend_login
  post "frontend_register/:usermodel"  => "sessions#register", as: :frontend_register
  post "manage/article_visibility/:id" => "manage#article_visibility"

  mount Sidekiq::Web => "/admin/background" if RUBY_VERSION.to_f >= 1.9

  # post "/api/v1/tokens" => "goldencobra/api/v1/tokens_controller#create"
  namespace "api" do
    namespace "v1" do
      resources :tokens, only: [:create, :show]
    end

    namespace "v2" do
      get "/articles"                 => "articles#index", defaults: { format: "json" }
      get "/articles/search"          => "articles#search", defaults: { format: "json" }
      get "/articles/breadcrumb/*url" => "articles#breadcrumb", defaults: { format: "json" }
      get "/articles/*url"            => "articles#show", defaults: { format: "json" }
      get "/locale_string"            => "locales#get_string", defaults: { format: "json" }
      get "/setting_string"           => "settings#get_string", defaults: { format: "json" }
      get "/uploads"                  => "uploads#index", defaults: { format: "json" }
      post "/articles/create"         => "articles#create", defaults: { format: "json" }
      post "/articles/update"         => "articles#update", defaults: { format: "json" }
      get "/navigation_menus"         => "navigation_menus#index", defaults: { format: "json" }
      get "/navigation_menus/active"  => "navigation_menus#active_ids", defaults: { format: "json" }

    end
  end

  get "sitemap", to: "articles#sitemap", defaults: { format: "xml" }

  devise_for :visitors, controllers: { omniauth_callbacks: "visitors/omniauth_callbacks" }
  devise_scope :visitors do
    get "/visitors/auth/:provider" => "omniauth_callbacks#passthru"
  end

  # match "/*article_id.pdf", to: "articles#convert_to_pdf"

  # php requests results in MimeType:Null-Object Github #47
  get "/*article_id",
      to: "articles#show",
      constraints: ->(req) { req.format.to_sym != :php && req.format.to_sym != :js }
  get "/*path", to: redirect("/404")

  root to: "articles#show", defaults: { startpage: true }
end
