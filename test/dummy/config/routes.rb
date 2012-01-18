Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  mount Goldencobra::Engine => "/"
end
#== Route Map
# Generated on 18 Jan 2012 18:10
#
#             user_session POST       /admin/login(.:format)                 active_admin/devise/sessions#create
#     destroy_user_session DELETE|GET /admin/logout(.:format)                active_admin/devise/sessions#destroy
#   user_omniauth_callback            /admin/auth/:action/callback(.:format) devise/omniauth_callbacks#(?-mix:(?!))
#            user_password POST       /admin/password(.:format)              active_admin/devise/passwords#create
#        new_user_password GET        /admin/password/new(.:format)          active_admin/devise/passwords#new
#       edit_user_password GET        /admin/password/edit(.:format)         active_admin/devise/passwords#edit
#                          PUT        /admin/password(.:format)              active_admin/devise/passwords#update
# cancel_user_registration GET        /admin/cancel(.:format)                devise/registrations#cancel
#        user_registration POST       /admin(.:format)                       devise/registrations#create
#    new_user_registration GET        /admin/sign_up(.:format)               devise/registrations#new
#   edit_user_registration GET        /admin/edit(.:format)                  devise/registrations#edit
#                          PUT        /admin(.:format)                       devise/registrations#update
#                          DELETE     /admin(.:format)                       devise/registrations#destroy
#        user_confirmation POST       /admin/confirmation(.:format)          devise/confirmations#create
#    new_user_confirmation GET        /admin/confirmation/new(.:format)      devise/confirmations#new
#                          GET        /admin/confirmation(.:format)          devise/confirmations#show
#              user_unlock POST       /admin/unlock(.:format)                devise/unlocks#create
#          new_user_unlock GET        /admin/unlock/new(.:format)            devise/unlocks#new
#                          GET        /admin/unlock(.:format)                devise/unlocks#show
#              goldencobra            /                                      Goldencobra::Engine
# 
# Routes for Goldencobra::Engine:
#                 admin_dashboard        /admin(.:format)                                goldencobra/admin/dashboard#index
#                  admin_comments GET    /admin/comments(.:format)                       goldencobra/admin/comments#index
#                                 POST   /admin/comments(.:format)                       goldencobra/admin/comments#create
#               new_admin_comment GET    /admin/comments/new(.:format)                   goldencobra/admin/comments#new
#              edit_admin_comment GET    /admin/comments/:id/edit(.:format)              goldencobra/admin/comments#edit
#                   admin_comment GET    /admin/comments/:id(.:format)                   goldencobra/admin/comments#show
#                                 PUT    /admin/comments/:id(.:format)                   goldencobra/admin/comments#update
#                                 DELETE /admin/comments/:id(.:format)                   goldencobra/admin/comments#destroy
# mark_as_startpage_admin_article GET    /admin/articles/:id/mark_as_startpage(.:format) goldencobra/admin/articles#mark_as_startpage
#                  admin_articles GET    /admin/articles(.:format)                       goldencobra/admin/articles#index
#                                 POST   /admin/articles(.:format)                       goldencobra/admin/articles#create
#               new_admin_article GET    /admin/articles/new(.:format)                   goldencobra/admin/articles#new
#              edit_admin_article GET    /admin/articles/:id/edit(.:format)              goldencobra/admin/articles#edit
#                   admin_article GET    /admin/articles/:id(.:format)                   goldencobra/admin/articles#show
#                                 PUT    /admin/articles/:id(.:format)                   goldencobra/admin/articles#update
#                                 DELETE /admin/articles/:id(.:format)                   goldencobra/admin/articles#destroy
#        admin_goldencobra_menues GET    /admin/goldencobra_menues(.:format)             goldencobra/admin/goldencobra_menues#index
#                                 POST   /admin/goldencobra_menues(.:format)             goldencobra/admin/goldencobra_menues#create
#     new_admin_goldencobra_menue GET    /admin/goldencobra_menues/new(.:format)         goldencobra/admin/goldencobra_menues#new
#    edit_admin_goldencobra_menue GET    /admin/goldencobra_menues/:id/edit(.:format)    goldencobra/admin/goldencobra_menues#edit
#         admin_goldencobra_menue GET    /admin/goldencobra_menues/:id(.:format)         goldencobra/admin/goldencobra_menues#show
#                                 PUT    /admin/goldencobra_menues/:id(.:format)         goldencobra/admin/goldencobra_menues#update
#                                 DELETE /admin/goldencobra_menues/:id(.:format)         goldencobra/admin/goldencobra_menues#destroy
#                                        /:id(.:format)                                  goldencobra/articles#show
#                            root        /                                               goldencobra/articles#show {:startpage=>true}
