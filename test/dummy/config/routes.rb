# encoding: utf-8
require "inherited_resources"

Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  mount Goldencobra::Engine => "/"
end

#== Route Map
#                                    Prefix Verb       URI Pattern                                               Controller#Action
#                          new_user_session GET        /admin/login(.:format)                                    active_admin/devise/sessions#new
#                              user_session POST       /admin/login(.:format)                                    active_admin/devise/sessions#create
#                      destroy_user_session DELETE|GET /admin/logout(.:format)                                   active_admin/devise/sessions#destroy
#                             user_password POST       /admin/password(.:format)                                 active_admin/devise/passwords#create
#                         new_user_password GET        /admin/password/new(.:format)                             active_admin/devise/passwords#new
#                        edit_user_password GET        /admin/password/edit(.:format)                            active_admin/devise/passwords#edit
#                                           PATCH      /admin/password(.:format)                                 active_admin/devise/passwords#update
#                                           PUT        /admin/password(.:format)                                 active_admin/devise/passwords#update
#                  cancel_user_registration GET        /admin/cancel(.:format)                                   active_admin/devise/registrations#cancel
#                         user_registration POST       /admin(.:format)                                          active_admin/devise/registrations#create
#                     new_user_registration GET        /admin/sign_up(.:format)                                  active_admin/devise/registrations#new
#                    edit_user_registration GET        /admin/edit(.:format)                                     active_admin/devise/registrations#edit
#                                           PATCH      /admin(.:format)                                          active_admin/devise/registrations#update
#                                           PUT        /admin(.:format)                                          active_admin/devise/registrations#update
#                                           DELETE     /admin(.:format)                                          active_admin/devise/registrations#destroy
#                               user_unlock POST       /admin/unlock(.:format)                                   active_admin/devise/unlocks#create
#                           new_user_unlock GET        /admin/unlock/new(.:format)                               active_admin/devise/unlocks#new
#                                           GET        /admin/unlock(.:format)                                   active_admin/devise/unlocks#show
#                                admin_root GET        /admin(.:format)                                          admin/dashboard#index
#          change_articletype_admin_article POST       /admin/articles/:id/change_articletype(.:format)          admin/articles#change_articletype
#           mark_as_startpage_admin_article GET        /admin/articles/:id/mark_as_startpage(.:format)           admin/articles#mark_as_startpage
#     set_page_online_offline_admin_article GET        /admin/articles/:id/set_page_online_offline(.:format)     admin/articles#set_page_online_offline
#              update_widgets_admin_article POST       /admin/articles/:id/update_widgets(.:format)              admin/articles#update_widgets
#            run_link_checker_admin_article GET        /admin/articles/:id/run_link_checker(.:format)            admin/articles#run_link_checker
#                      revert_admin_article GET        /admin/articles/:id/revert(.:format)                      admin/articles#revert
#  load_overviewtree_as_json_admin_articles GET        /admin/articles/load_overviewtree_as_json(.:format)       admin/articles#load_overviewtree_as_json
#               batch_action_admin_articles POST       /admin/articles/batch_action(.:format)                    admin/articles#batch_action
#                            admin_articles GET        /admin/articles(.:format)                                 admin/articles#index
#                                           POST       /admin/articles(.:format)                                 admin/articles#create
#                         new_admin_article GET        /admin/articles/new(.:format)                             admin/articles#new
#                        edit_admin_article GET        /admin/articles/:id/edit(.:format)                        admin/articles#edit
#                             admin_article GET        /admin/articles/:id(.:format)                             admin/articles#show
#                                           PATCH      /admin/articles/:id(.:format)                             admin/articles#update
#                                           PUT        /admin/articles/:id(.:format)                             admin/articles#update
#                                           DELETE     /admin/articles/:id(.:format)                             admin/articles#destroy
#           batch_action_admin_articletypes POST       /admin/articletypes/batch_action(.:format)                admin/articletypes#batch_action
#                        admin_articletypes GET        /admin/articletypes(.:format)                             admin/articletypes#index
#                                           POST       /admin/articletypes(.:format)                             admin/articletypes#create
#                     new_admin_articletype GET        /admin/articletypes/new(.:format)                         admin/articletypes#new
#                    edit_admin_articletype GET        /admin/articletypes/:id/edit(.:format)                    admin/articletypes#edit
#                         admin_articletype GET        /admin/articletypes/:id(.:format)                         admin/articletypes#show
#                                           PATCH      /admin/articletypes/:id(.:format)                         admin/articletypes#update
#                                           PUT        /admin/articletypes/:id(.:format)                         admin/articletypes#update
#                                           DELETE     /admin/articletypes/:id(.:format)                         admin/articletypes#destroy
#                           admin_dashboard GET        /admin/dashboard(.:format)                                admin/dashboard#index
#                batch_action_admin_domains POST       /admin/domains/batch_action(.:format)                     admin/domains#batch_action
#                             admin_domains GET        /admin/domains(.:format)                                  admin/domains#index
#                                           POST       /admin/domains(.:format)                                  admin/domains#create
#                          new_admin_domain GET        /admin/domains/new(.:format)                              admin/domains#new
#                         edit_admin_domain GET        /admin/domains/:id/edit(.:format)                         admin/domains#edit
#                              admin_domain GET        /admin/domains/:id(.:format)                              admin/domains#show
#                                           PATCH      /admin/domains/:id(.:format)                              admin/domains#update
#                                           PUT        /admin/domains/:id(.:format)                              admin/domains#update
#                                           DELETE     /admin/domains/:id(.:format)                              admin/domains#destroy
#                        admin_linkcheckers GET        /admin/linkcheckers(.:format)                             admin/linkcheckers#index
#                        revert_admin_menue GET        /admin/menues/:id/revert(.:format)                        admin/menues#revert
# activate_deactivate_menu_item_admin_menue GET        /admin/menues/:id/activate_deactivate_menu_item(.:format) admin/menues#activate_deactivate_menu_item
#    load_overviewtree_as_json_admin_menues GET        /admin/menues/load_overviewtree_as_json(.:format)         admin/menues#load_overviewtree_as_json
#                 batch_action_admin_menues POST       /admin/menues/batch_action(.:format)                      admin/menues#batch_action
#                              admin_menues GET        /admin/menues(.:format)                                   admin/menues#index
#                                           POST       /admin/menues(.:format)                                   admin/menues#create
#                           new_admin_menue GET        /admin/menues/new(.:format)                               admin/menues#new
#                          edit_admin_menue GET        /admin/menues/:id/edit(.:format)                          admin/menues#edit
#                               admin_menue GET        /admin/menues/:id(.:format)                               admin/menues#show
#                                           PATCH      /admin/menues/:id(.:format)                               admin/menues#update
#                                           PUT        /admin/menues/:id(.:format)                               admin/menues#update
#                                           DELETE     /admin/menues/:id(.:format)                               admin/menues#destroy
#            batch_action_admin_permissions POST       /admin/permissions/batch_action(.:format)                 admin/permissions#batch_action
#                         admin_permissions GET        /admin/permissions(.:format)                              admin/permissions#index
#                                           POST       /admin/permissions(.:format)                              admin/permissions#create
#                      new_admin_permission GET        /admin/permissions/new(.:format)                          admin/permissions#new
#                     edit_admin_permission GET        /admin/permissions/:id/edit(.:format)                     admin/permissions#edit
#                          admin_permission GET        /admin/permissions/:id(.:format)                          admin/permissions#show
#                                           PATCH      /admin/permissions/:id(.:format)                          admin/permissions#update
#                                           PUT        /admin/permissions/:id(.:format)                          admin/permissions#update
#                                           DELETE     /admin/permissions/:id(.:format)                          admin/permissions#destroy
#            batch_action_admin_redirectors POST       /admin/redirectors/batch_action(.:format)                 admin/redirectors#batch_action
#                         admin_redirectors GET        /admin/redirectors(.:format)                              admin/redirectors#index
#                                           POST       /admin/redirectors(.:format)                              admin/redirectors#create
#                      new_admin_redirector GET        /admin/redirectors/new(.:format)                          admin/redirectors#new
#                     edit_admin_redirector GET        /admin/redirectors/:id/edit(.:format)                     admin/redirectors#edit
#                          admin_redirector GET        /admin/redirectors/:id(.:format)                          admin/redirectors#show
#                                           PATCH      /admin/redirectors/:id(.:format)                          admin/redirectors#update
#                                           PUT        /admin/redirectors/:id(.:format)                          admin/redirectors#update
#                                           DELETE     /admin/redirectors/:id(.:format)                          admin/redirectors#destroy
#                  batch_action_admin_roles POST       /admin/roles/batch_action(.:format)                       admin/roles#batch_action
#                               admin_roles GET        /admin/roles(.:format)                                    admin/roles#index
#                                           POST       /admin/roles(.:format)                                    admin/roles#create
#                            new_admin_role GET        /admin/roles/new(.:format)                                admin/roles#new
#                           edit_admin_role GET        /admin/roles/:id/edit(.:format)                           admin/roles#edit
#                                admin_role GET        /admin/roles/:id(.:format)                                admin/roles#show
#                                           PATCH      /admin/roles/:id(.:format)                                admin/roles#update
#                                           PUT        /admin/roles/:id(.:format)                                admin/roles#update
#                                           DELETE     /admin/roles/:id(.:format)                                admin/roles#destroy
#                      revert_admin_setting GET        /admin/settings/:id/revert(.:format)                      admin/settings#revert
#  load_overviewtree_as_json_admin_settings GET        /admin/settings/load_overviewtree_as_json(.:format)       admin/settings#load_overviewtree_as_json
#               batch_action_admin_settings POST       /admin/settings/batch_action(.:format)                    admin/settings#batch_action
#                            admin_settings GET        /admin/settings(.:format)                                 admin/settings#index
#                                           POST       /admin/settings(.:format)                                 admin/settings#create
#                         new_admin_setting GET        /admin/settings/new(.:format)                             admin/settings#new
#                        edit_admin_setting GET        /admin/settings/:id/edit(.:format)                        admin/settings#edit
#                             admin_setting GET        /admin/settings/:id(.:format)                             admin/settings#show
#                                           PATCH      /admin/settings/:id(.:format)                             admin/settings#update
#                                           PUT        /admin/settings/:id(.:format)                             admin/settings#update
#                                           DELETE     /admin/settings/:id(.:format)                             admin/settings#destroy
#           batch_action_admin_translations POST       /admin/translations/batch_action(.:format)                admin/translations#batch_action
#                        admin_translations GET        /admin/translations(.:format)                             admin/translations#index
#                                           POST       /admin/translations(.:format)                             admin/translations#create
#                     new_admin_translation GET        /admin/translations/new(.:format)                         admin/translations#new
#                    edit_admin_translation GET        /admin/translations/:id/edit(.:format)                    admin/translations#edit
#                         admin_translation GET        /admin/translations/:id(.:format)                         admin/translations#show
#                                           PATCH      /admin/translations/:id(.:format)                         admin/translations#update
#                                           PUT        /admin/translations/:id(.:format)                         admin/translations#update
#                                           DELETE     /admin/translations/:id(.:format)                         admin/translations#destroy
#                   unzip_file_admin_upload GET        /admin/uploads/:id/unzip_file(.:format)                   admin/uploads#unzip_file
#                batch_action_admin_uploads POST       /admin/uploads/batch_action(.:format)                     admin/uploads#batch_action
#                             admin_uploads GET        /admin/uploads(.:format)                                  admin/uploads#index
#                                           POST       /admin/uploads(.:format)                                  admin/uploads#create
#                          new_admin_upload GET        /admin/uploads/new(.:format)                              admin/uploads#new
#                         edit_admin_upload GET        /admin/uploads/:id/edit(.:format)                         admin/uploads#edit
#                              admin_upload GET        /admin/uploads/:id(.:format)                              admin/uploads#show
#                                           PATCH      /admin/uploads/:id(.:format)                              admin/uploads#update
#                                           PUT        /admin/uploads/:id(.:format)                              admin/uploads#update
#                                           DELETE     /admin/uploads/:id(.:format)                              admin/uploads#destroy
#                  batch_action_admin_users POST       /admin/users/batch_action(.:format)                       admin/users#batch_action
#                               admin_users GET        /admin/users(.:format)                                    admin/users#index
#                                           POST       /admin/users(.:format)                                    admin/users#create
#                            new_admin_user GET        /admin/users/new(.:format)                                admin/users#new
#                           edit_admin_user GET        /admin/users/:id/edit(.:format)                           admin/users#edit
#                                admin_user GET        /admin/users/:id(.:format)                                admin/users#show
#                                           PATCH      /admin/users/:id(.:format)                                admin/users#update
#                                           PUT        /admin/users/:id(.:format)                                admin/users#update
#                                           DELETE     /admin/users/:id(.:format)                                admin/users#destroy
#                       revert_admin_widget GET        /admin/widgets/:id/revert(.:format)                       admin/widgets#revert
#                    duplicate_admin_widget GET        /admin/widgets/:id/duplicate(.:format)                    admin/widgets#duplicate
#                batch_action_admin_widgets POST       /admin/widgets/batch_action(.:format)                     admin/widgets#batch_action
#                             admin_widgets GET        /admin/widgets(.:format)                                  admin/widgets#index
#                                           POST       /admin/widgets(.:format)                                  admin/widgets#create
#                          new_admin_widget GET        /admin/widgets/new(.:format)                              admin/widgets#new
#                         edit_admin_widget GET        /admin/widgets/:id/edit(.:format)                         admin/widgets#edit
#                              admin_widget GET        /admin/widgets/:id(.:format)                              admin/widgets#show
#                                           PATCH      /admin/widgets/:id(.:format)                              admin/widgets#update
#                                           PUT        /admin/widgets/:id(.:format)                              admin/widgets#update
#                                           DELETE     /admin/widgets/:id(.:format)                              admin/widgets#destroy
#                            admin_comments GET        /admin/comments(.:format)                                 admin/comments#index
#                                           POST       /admin/comments(.:format)                                 admin/comments#create
#                             admin_comment GET        /admin/comments/:id(.:format)                             admin/comments#show
#                                           DELETE     /admin/comments/:id(.:format)                             admin/comments#destroy
#                               goldencobra            /                                                         Goldencobra::Engine

# Routes for Goldencobra::Engine:
#                switch_language GET      /switch_language/:locale(.:format)         goldencobra/articles#switch_language
#                frontend_logout GET      /frontend_logout/:usermodel(.:format)      goldencobra/sessions#logout
#      manage_render_admin_menue GET      /manage/render_admin_menue(.:format)       goldencobra/manage#render_admin_menue
#               call_for_support GET      /call_for_support(.:format)                goldencobra/manage#call_for_support
#                 frontend_login POST     /frontend_login/:usermodel(.:format)       goldencobra/sessions#login
#              frontend_register POST     /frontend_register/:usermodel(.:format)    goldencobra/sessions#register
#                                POST     /manage/article_visibility/:id(.:format)   goldencobra/manage#article_visibility
#                    sidekiq_web          /admin/background                          Sidekiq::Web
#                  api_v1_tokens POST     /api/v1/tokens(.:format)                   goldencobra/api/v1/tokens#create
#                   api_v1_token GET      /api/v1/tokens/:id(.:format)               goldencobra/api/v1/tokens#show
#                api_v2_articles GET      /api/v2/articles(.:format)                 goldencobra/api/v2/articles#index
#         api_v2_articles_search GET      /api/v2/articles/search(.:format)          goldencobra/api/v2/articles#search
#                         api_v2 GET      /api/v2/articles/breadcrumb/*url(.:format) goldencobra/api/v2/articles#breadcrumb
#                                GET      /api/v2/articles/*url(.:format)            goldencobra/api/v2/articles#show
#           api_v2_locale_string GET      /api/v2/locale_string(.:format)            goldencobra/api/v2/locales#get_string
#          api_v2_setting_string GET      /api/v2/setting_string(.:format)           goldencobra/api/v2/settings#get_string
#                 api_v2_uploads GET      /api/v2/uploads(.:format)                  goldencobra/api/v2/uploads#index
#         api_v2_articles_create POST     /api/v2/articles/create(.:format)          goldencobra/api/v2/articles#create
#         api_v2_articles_update POST     /api/v2/articles/update(.:format)          goldencobra/api/v2/articles#update
#        api_v2_navigation_menus GET      /api/v2/navigation_menus(.:format)         goldencobra/api/v2/navigation_menus#index
# api_v2_navigation_menus_active GET      /api/v2/navigation_menus/active(.:format)  goldencobra/api/v2/navigation_menus#active_ids
#                        sitemap GET      /sitemap(.:format)                         goldencobra/articles#sitemap {:format=>"xml"}
#            new_visitor_session GET      /visitors/sign_in(.:format)                goldencobra/sessions#new
#                visitor_session POST     /visitors/sign_in(.:format)                goldencobra/sessions#create
#        destroy_visitor_session DELETE   /visitors/sign_out(.:format)               goldencobra/sessions#destroy
#     visitor_omniauth_authorize GET|POST /visitors/auth/:provider(.:format)         visitors/omniauth_callbacks#passthru {:provider=>/(?!)/}
#      visitor_omniauth_callback GET|POST /visitors/auth/:action/callback(.:format)  visitors/omniauth_callbacks#(?-mix:(?!))
#               visitor_password POST     /visitors/password(.:format)               goldencobra/passwords#create
#           new_visitor_password GET      /visitors/password/new(.:format)           goldencobra/passwords#new
#          edit_visitor_password GET      /visitors/password/edit(.:format)          goldencobra/passwords#edit
#                                PATCH    /visitors/password(.:format)               goldencobra/passwords#update
#                                PUT      /visitors/password(.:format)               goldencobra/passwords#update
#    cancel_visitor_registration GET      /visitors/cancel(.:format)                 goldencobra/registrations#cancel
#           visitor_registration POST     /visitors(.:format)                        goldencobra/registrations#create
#       new_visitor_registration GET      /visitors/sign_up(.:format)                goldencobra/registrations#new
#      edit_visitor_registration GET      /visitors/edit(.:format)                   goldencobra/registrations#edit
#                                PATCH    /visitors(.:format)                        goldencobra/registrations#update
#                                PUT      /visitors(.:format)                        goldencobra/registrations#update
#                                DELETE   /visitors(.:format)                        goldencobra/registrations#destroy
#                 visitor_unlock POST     /visitors/unlock(.:format)                 goldencobra/unlocks#create
#             new_visitor_unlock GET      /visitors/unlock/new(.:format)             goldencobra/unlocks#new
#                                GET      /visitors/unlock(.:format)                 goldencobra/unlocks#show
#                                GET      /visitors/auth/:provider(.:format)         goldencobra/omniauth_callbacks#passthru
#                                GET      /*article_id(.:format)                     goldencobra/articles#show
#                           root GET      /                                          goldencobra/articles#show {:startpage=>true}
