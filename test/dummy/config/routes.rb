Rails.application.routes.draw do

  mount Goldencobra::Engine => "/"
end
#== Route Map
# Generated on 18 Jan 2012 16:51
#
# 
# Routes for Goldencobra::Engine:
#    admin_dashboard        /admin(.:format)                   goldencobra/admin/dashboard#index
#     admin_comments GET    /admin/comments(.:format)          goldencobra/admin/comments#index
#                    POST   /admin/comments(.:format)          goldencobra/admin/comments#create
#  new_admin_comment GET    /admin/comments/new(.:format)      goldencobra/admin/comments#new
# edit_admin_comment GET    /admin/comments/:id/edit(.:format) goldencobra/admin/comments#edit
#      admin_comment GET    /admin/comments/:id(.:format)      goldencobra/admin/comments#show
#                    PUT    /admin/comments/:id(.:format)      goldencobra/admin/comments#update
#                    DELETE /admin/comments/:id(.:format)      goldencobra/admin/comments#destroy
#                           /:id(.:format)                     goldencobra/articles#show
#               root        /                                  goldencobra/articles#show {:startpage=>true}
