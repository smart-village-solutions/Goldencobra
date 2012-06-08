Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users, ActiveAdmin::Devise.config
  mount Goldencobra::Engine => "/"
end
#== Route Map
# Generated on 08 Jun 2012 09:54
#
#       mark_as_startpage_admin_article GET        /admin/articles/:id/mark_as_startpage(.:format)       admin/articles#mark_as_startpage
# set_page_online_offline_admin_article GET        /admin/articles/:id/set_page_online_offline(.:format) admin/articles#set_page_online_offline
#          update_widgets_admin_article POST       /admin/articles/:id/update_widgets(.:format)          admin/articles#update_widgets
#           batch_action_admin_articles POST       /admin/articles/batch_action(.:format)                admin/articles#batch_action
#                        admin_articles GET        /admin/articles(.:format)                             admin/articles#index
#                                       POST       /admin/articles(.:format)                             admin/articles#create
#                     new_admin_article GET        /admin/articles/new(.:format)                         admin/articles#new
#                    edit_admin_article GET        /admin/articles/:id/edit(.:format)                    admin/articles#edit
#                         admin_article GET        /admin/articles/:id(.:format)                         admin/articles#show
#                                       PUT        /admin/articles/:id(.:format)                         admin/articles#update
#                                       DELETE     /admin/articles/:id(.:format)                         admin/articles#destroy
#               admin_goldencobra_infos            /admin/goldencobra_infos(.:format)                    admin/goldencobra_infos#index
#             batch_action_admin_menues POST       /admin/menues/batch_action(.:format)                  admin/menues#batch_action
#                          admin_menues GET        /admin/menues(.:format)                               admin/menues#index
#                                       POST       /admin/menues(.:format)                               admin/menues#create
#                       new_admin_menue GET        /admin/menues/new(.:format)                           admin/menues#new
#                      edit_admin_menue GET        /admin/menues/:id/edit(.:format)                      admin/menues#edit
#                           admin_menue GET        /admin/menues/:id(.:format)                           admin/menues#show
#                                       PUT        /admin/menues/:id(.:format)                           admin/menues#update
#                                       DELETE     /admin/menues/:id(.:format)                           admin/menues#destroy
#        batch_action_admin_permissions POST       /admin/permissions/batch_action(.:format)             admin/permissions#batch_action
#                     admin_permissions GET        /admin/permissions(.:format)                          admin/permissions#index
#                                       POST       /admin/permissions(.:format)                          admin/permissions#create
#                  new_admin_permission GET        /admin/permissions/new(.:format)                      admin/permissions#new
#                 edit_admin_permission GET        /admin/permissions/:id/edit(.:format)                 admin/permissions#edit
#                      admin_permission GET        /admin/permissions/:id(.:format)                      admin/permissions#show
#                                       PUT        /admin/permissions/:id(.:format)                      admin/permissions#update
#                                       DELETE     /admin/permissions/:id(.:format)                      admin/permissions#destroy
#              batch_action_admin_roles POST       /admin/roles/batch_action(.:format)                   admin/roles#batch_action
#                           admin_roles GET        /admin/roles(.:format)                                admin/roles#index
#                                       POST       /admin/roles(.:format)                                admin/roles#create
#                        new_admin_role GET        /admin/roles/new(.:format)                            admin/roles#new
#                       edit_admin_role GET        /admin/roles/:id/edit(.:format)                       admin/roles#edit
#                            admin_role GET        /admin/roles/:id(.:format)                            admin/roles#show
#                                       PUT        /admin/roles/:id(.:format)                            admin/roles#update
#                                       DELETE     /admin/roles/:id(.:format)                            admin/roles#destroy
#           batch_action_admin_settings POST       /admin/settings/batch_action(.:format)                admin/settings#batch_action
#                        admin_settings GET        /admin/settings(.:format)                             admin/settings#index
#                                       POST       /admin/settings(.:format)                             admin/settings#create
#                     new_admin_setting GET        /admin/settings/new(.:format)                         admin/settings#new
#                    edit_admin_setting GET        /admin/settings/:id/edit(.:format)                    admin/settings#edit
#                         admin_setting GET        /admin/settings/:id(.:format)                         admin/settings#show
#                                       PUT        /admin/settings/:id(.:format)                         admin/settings#update
#                                       DELETE     /admin/settings/:id(.:format)                         admin/settings#destroy
#               unzip_file_admin_upload GET        /admin/uploads/:id/unzip_file(.:format)               admin/uploads#unzip_file
#            batch_action_admin_uploads POST       /admin/uploads/batch_action(.:format)                 admin/uploads#batch_action
#                         admin_uploads GET        /admin/uploads(.:format)                              admin/uploads#index
#                                       POST       /admin/uploads(.:format)                              admin/uploads#create
#                      new_admin_upload GET        /admin/uploads/new(.:format)                          admin/uploads#new
#                     edit_admin_upload GET        /admin/uploads/:id/edit(.:format)                     admin/uploads#edit
#                          admin_upload GET        /admin/uploads/:id(.:format)                          admin/uploads#show
#                                       PUT        /admin/uploads/:id(.:format)                          admin/uploads#update
#                                       DELETE     /admin/uploads/:id(.:format)                          admin/uploads#destroy
#              batch_action_admin_users POST       /admin/users/batch_action(.:format)                   admin/users#batch_action
#                           admin_users GET        /admin/users(.:format)                                admin/users#index
#                                       POST       /admin/users(.:format)                                admin/users#create
#                        new_admin_user GET        /admin/users/new(.:format)                            admin/users#new
#                       edit_admin_user GET        /admin/users/:id/edit(.:format)                       admin/users#edit
#                            admin_user GET        /admin/users/:id(.:format)                            admin/users#show
#                                       PUT        /admin/users/:id(.:format)                            admin/users#update
#                                       DELETE     /admin/users/:id(.:format)                            admin/users#destroy
#            batch_action_admin_widgets POST       /admin/widgets/batch_action(.:format)                 admin/widgets#batch_action
#                         admin_widgets GET        /admin/widgets(.:format)                              admin/widgets#index
#                                       POST       /admin/widgets(.:format)                              admin/widgets#create
#                      new_admin_widget GET        /admin/widgets/new(.:format)                          admin/widgets#new
#                     edit_admin_widget GET        /admin/widgets/:id/edit(.:format)                     admin/widgets#edit
#                          admin_widget GET        /admin/widgets/:id(.:format)                          admin/widgets#show
#                                       PUT        /admin/widgets/:id(.:format)                          admin/widgets#update
#                                       DELETE     /admin/widgets/:id(.:format)                          admin/widgets#destroy
#           batch_action_admin_comments POST       /admin/comments/batch_action(.:format)                admin/comments#batch_action
#                        admin_comments GET        /admin/comments(.:format)                             admin/comments#index
#                                       POST       /admin/comments(.:format)                             admin/comments#create
#                     new_admin_comment GET        /admin/comments/new(.:format)                         admin/comments#new
#                    edit_admin_comment GET        /admin/comments/:id/edit(.:format)                    admin/comments#edit
#                         admin_comment GET        /admin/comments/:id(.:format)                         admin/comments#show
#                                       PUT        /admin/comments/:id(.:format)                         admin/comments#update
#                                       DELETE     /admin/comments/:id(.:format)                         admin/comments#destroy
#                      new_user_session GET        /admin/login(.:format)                                active_admin/devise/sessions#new
#                          user_session POST       /admin/login(.:format)                                active_admin/devise/sessions#create
#                  destroy_user_session DELETE|GET /admin/logout(.:format)                               active_admin/devise/sessions#destroy
#                user_omniauth_callback            /admin/auth/:action/callback(.:format)                devise/omniauth_callbacks#(?-mix:(?!))
#                         user_password POST       /admin/password(.:format)                             active_admin/devise/passwords#create
#                     new_user_password GET        /admin/password/new(.:format)                         active_admin/devise/passwords#new
#                    edit_user_password GET        /admin/password/edit(.:format)                        active_admin/devise/passwords#edit
#                                       PUT        /admin/password(.:format)                             active_admin/devise/passwords#update
#              cancel_user_registration GET        /admin/cancel(.:format)                               devise/registrations#cancel
#                     user_registration POST       /admin(.:format)                                      devise/registrations#create
#                 new_user_registration GET        /admin/sign_up(.:format)                              devise/registrations#new
#                edit_user_registration GET        /admin/edit(.:format)                                 devise/registrations#edit
#                                       PUT        /admin(.:format)                                      devise/registrations#update
#                                       DELETE     /admin(.:format)                                      devise/registrations#destroy
#                           user_unlock POST       /admin/unlock(.:format)                               devise/unlocks#create
#                       new_user_unlock GET        /admin/unlock/new(.:format)                           devise/unlocks#new
#                                       GET        /admin/unlock(.:format)                               devise/unlocks#show
#                           goldencobra            /                                                     Goldencobra::Engine
# 
# Routes for Goldencobra::Engine:
# sitemap GET /sitemap(.:format)     goldencobra/articles#sitemap {:format=>"xml"}
#             /*article_id(.:format) goldencobra/articles#show
#    root     /                      goldencobra/articles#show {:startpage=>true}
