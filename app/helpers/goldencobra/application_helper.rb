module Goldencobra
  module ApplicationHelper
    include Goldencobra::ArticlesHelper

    def s(name)
      if name.present?
        Goldencobra::Setting.for_key(name)
      end
    end

    def bugtracker
      user_mod = Goldencobra::Setting.for_key("goldencobra.bugherd.user")
      role_mod = Goldencobra::Setting.for_key("goldencobra.bugherd.role")
      bugherd_api = Goldencobra::Setting.for_key("goldencobra.bugherd.api")
      if bugherd_api.present? && user_mod.present? && role_mod.present? && eval("#{user_mod} && #{user_mod}.present? && #{user_mod}.has_role?('#{role_mod}')")
        render :partial => "goldencobra/articles/bugherd", :locals => {:bugherd_api => bugherd_api}
      end
    end

    def edit_article_link
      user_mod = Goldencobra::Setting.for_key("goldencobra.article.edit_link.user")
      role_mod = Goldencobra::Setting.for_key("goldencobra.article.edit_link.role")
      if user_mod.present? && role_mod.present? && eval("#{user_mod} && #{user_mod}.present? && #{user_mod}.has_role?('#{role_mod}')")
        render :partial => "goldencobra/articles/edit_article_link"
      end
    end

    def basic_goldencobra_headers(options={})
      render :partial => "/goldencobra/articles/headers", :locals => {:options => options}
    end
  end
end
