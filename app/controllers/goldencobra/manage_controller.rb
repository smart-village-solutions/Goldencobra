module Goldencobra
  class ManageController < Goldencobra::ApplicationController

    def render_admin_menue
      user_mod = Goldencobra::Setting.for_key("goldencobra.article.edit_link.user")
      role_mod = Goldencobra::Setting.for_key("goldencobra.article.edit_link.role")
      if user_mod.present? && role_mod.present? && eval("#{user_mod} && #{user_mod}.present? && #{user_mod}.has_role?('#{role_mod}')")
        article = Goldencobra::Article.find_by_id(params[:id])
        @operator = current_user || current_visitor
        a = Ability.new(@operator)
        if a.can?(:manage, article)
          @article = article
        end
      end
    end

    def article_visibility
      @article_saved = false
      @operator = current_user || current_visitor
      if current_user
        article = Goldencobra::Article.find(params[:id])
        ability = Ability.new(current_user)
        if ability.can?(:update, article)
          article.active = !article.active
          article.save
          @article = article
          @article_saved = true
        end
      end
    end

    def call_for_support
      if current_user || current_visitor
        Goldencobra::ConfirmationMailer.send_support_mail(params[:link]).deliver
        render :text => "200"
      else
        render :text => "401"
      end
    end

  end
end
