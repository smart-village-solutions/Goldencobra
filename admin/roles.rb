ActiveAdmin.register Goldencobra::Role, :as => "Role" do
    menu :parent => "Einstellungen", :if => proc{can?(:update, Goldencobra::Role)}
    controller.authorize_resource :class => Goldencobra::Role

  action_item only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/prev_item', locals: { resource: resource, url: '' }
  end

  action_item only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/next_item', locals: { resource: resource, url: '' }
  end

end