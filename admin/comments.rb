# encoding: utf-8

ActiveAdmin.register Goldencobra::Comment, :as => "article_comment" do
  menu :parent => "Content-Management", :if => proc{can?(:read, Goldencobra::Comment)}

  form :html => { :enctype => "multipart/form-data" }  do |f|
    f.actions
    f.inputs do
      f.input :content
      f.input :active
      f.input :approved
      f.input :reported
      f.input :parent, :as => :select, :collection => Goldencobra::Comment.scoped
      f.input :article, :as => :select, :collection => Goldencobra::Article.scoped
      f.input :commentator, :as => :select, :collection => Goldencobra::Setting.for_key("goldencobra.comments.commentator").constantize.scoped
    end
    f.actions
  end

  index do
    selectable_column
    column :content
    column :active
    column :approved
    column :reported
    column :article do |comment|
      link_to 'Anzeigen', comment.article.public_url if comment.article.present?
    end
    column :created_at do |comment|
      comment.created_at.strftime('%d.%m.%Y %H:%M Uhr')
    end
    column "" do |comment|
      result = ""
      result += link_to(t(:edit), "/admin/article_comments/#{comment.id}/edit", :class => "member_link edit_link edit", :title => "bearbeiten")
      result += link_to(t(:delete), admin_comment_path(comment.id), :method => :DELETE, :confirm => "Kommentar löschen?", :class => "member_link delete_link delete", :title => "loeschen")
      raw(result)
    end
  end

  action_item only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/prev_item', locals: { resource: resource, url: 'article_comments' }
  end

  action_item only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/next_item', locals: { resource: resource, url: 'article_comments' }
  end

end