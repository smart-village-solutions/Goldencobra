ActiveAdmin.register Goldencobra::Comment, :as => "article_comment" do

  menu :if => proc{can?(:update, Goldencobra::Comment)}

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

end