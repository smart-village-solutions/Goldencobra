if RUBY_VERSION.include?("1.9.")
  require 'sidekiq/web'
end

Goldencobra::Engine.routes.draw do

  match "switch_language/:locale"       => "articles#switch_language", :as => :switch_language
  match "frontend_login/:usermodel"     => "sessions#login", :as => :frontend_login
  match "frontend_logout/:usermodel"    => "sessions#logout", :as => :frontend_logout
  match "frontend_register/:usermodel"  => "sessions#register", :as => :frontend_register
  match "manage/render_admin_menue"     => "manage#render_admin_menue"
  match "manage/article_visibility/:id" => "manage#article_visibility"
  match "call_for_support"              => "manage#call_for_support"

  if RUBY_VERSION.include?("1.9.")
    mount Sidekiq::Web => '/admin/background'
  end

  # post '/api/v1/tokens' => 'goldencobra/api/v1/tokens_controller#create'
  namespace "api" do
    namespace "v1" do
      resources :tokens, only: [:create]
    end

    namespace "v2" do
      get '/articles'                 => 'articles#index'
      get '/articles/search'          => 'articles#search'
      get '/articles/breadcrumb/*url' => 'articles#breadcrumb'
      get '/articles/*url'            => 'articles#show'
      get '/locale_string'            => 'locales#get_string'
      get '/setting_string'           => 'settings#get_string'
      get '/uploads'                  => 'uploads#index'
      match '/articles/create'        => 'articles#create'
      match '/articles/update'        => 'articles#update'
      get '/navigation_menus'         => 'navigation_menus#index'
      get '/navigation_menus/active'  => 'navigation_menus#active_ids'
    end
  end

  get 'sitemap', :to => 'articles#sitemap', :defaults => {:format => "xml"}

  devise_for :visitors, :controllers => { :omniauth_callbacks => "visitors/omniauth_callbacks" }
  devise_scope :visitors do
    get '/visitors/auth/:provider' => 'omniauth_callbacks#passthru'
  end

  #match "/*article_id.pdf", :to => "articles#convert_to_pdf"
  # match "/*article_id", :to => "articles#show"

  # root :to => 'articles#show', :defaults => {:startpage => true}
end
