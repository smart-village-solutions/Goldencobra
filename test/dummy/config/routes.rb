Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users, ActiveAdmin::Devise.config
  mount Goldencobra::Engine => "/"
end
#== Route Map
# Generated on 25 Jan 2012 16:22
#
#                  admin_comments GET        /admin/comments(.:format)                       admin/comments#index
#                                 POST       /admin/comments(.:format)                       admin/comments#create
#               new_admin_comment GET        /admin/comments/new(.:format)                   admin/comments#new
#              edit_admin_comment GET        /admin/comments/:id/edit(.:format)              admin/comments#edit
#                   admin_comment GET        /admin/comments/:id(.:format)                   admin/comments#show
#                                 PUT        /admin/comments/:id(.:format)                   admin/comments#update
#                                 DELETE     /admin/comments/:id(.:format)                   admin/comments#destroy
# mark_as_startpage_admin_article GET        /admin/articles/:id/mark_as_startpage(.:format) admin/articles#mark_as_startpage
#                  admin_articles GET        /admin/articles(.:format)                       admin/articles#index
#                                 POST       /admin/articles(.:format)                       admin/articles#create
#               new_admin_article GET        /admin/articles/new(.:format)                   admin/articles#new
#              edit_admin_article GET        /admin/articles/:id/edit(.:format)              admin/articles#edit
#                   admin_article GET        /admin/articles/:id(.:format)                   admin/articles#show
#                                 PUT        /admin/articles/:id(.:format)                   admin/articles#update
#                                 DELETE     /admin/articles/:id(.:format)                   admin/articles#destroy
#                    admin_menues GET        /admin/menues(.:format)                         admin/menues#index
#                                 POST       /admin/menues(.:format)                         admin/menues#create
#                 new_admin_menue GET        /admin/menues/new(.:format)                     admin/menues#new
#                edit_admin_menue GET        /admin/menues/:id/edit(.:format)                admin/menues#edit
#                     admin_menue GET        /admin/menues/:id(.:format)                     admin/menues#show
#                                 PUT        /admin/menues/:id(.:format)                     admin/menues#update
#                                 DELETE     /admin/menues/:id(.:format)                     admin/menues#destroy
#                new_user_session GET        /admin/login(.:format)                          active_admin/devise/sessions#new
#                    user_session POST       /admin/login(.:format)                          active_admin/devise/sessions#create
#            destroy_user_session DELETE|GET /admin/logout(.:format)                         active_admin/devise/sessions#destroy
#          user_omniauth_callback            /admin/auth/:action/callback(.:format)          devise/omniauth_callbacks#(?-mix:(?!))
#                   user_password POST       /admin/password(.:format)                       active_admin/devise/passwords#create
#               new_user_password GET        /admin/password/new(.:format)                   active_admin/devise/passwords#new
#              edit_user_password GET        /admin/password/edit(.:format)                  active_admin/devise/passwords#edit
#                                 PUT        /admin/password(.:format)                       active_admin/devise/passwords#update
#        cancel_user_registration GET        /admin/cancel(.:format)                         devise/registrations#cancel
#               user_registration POST       /admin(.:format)                                devise/registrations#create
#           new_user_registration GET        /admin/sign_up(.:format)                        devise/registrations#new
#          edit_user_registration GET        /admin/edit(.:format)                           devise/registrations#edit
#                                 PUT        /admin(.:format)                                devise/registrations#update
#                                 DELETE     /admin(.:format)                                devise/registrations#destroy
#               user_confirmation POST       /admin/confirmation(.:format)                   devise/confirmations#create
#           new_user_confirmation GET        /admin/confirmation/new(.:format)               devise/confirmations#new
#                                 GET        /admin/confirmation(.:format)                   devise/confirmations#show
#                     user_unlock POST       /admin/unlock(.:format)                         devise/unlocks#create
#                 new_user_unlock GET        /admin/unlock/new(.:format)                     devise/unlocks#new
#                                 GET        /admin/unlock(.:format)                         devise/unlocks#show
#                     goldencobra            /                                               Goldencobra::Engine
# 
# Routes for Goldencobra::Engine:
#       /*article_id(.:format) goldencobra/articles#show
# root  /                      goldencobra/articles#show {:startpage=>true}
