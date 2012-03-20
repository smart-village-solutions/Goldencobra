class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :read, Goldencobra::Article
    user.roles.each do |role|
      role.permissions.each do |permission|
        if permission.subject_class == ":all"   
          if permission.action.include?("not_")
            cannot permission.action.gsub("not_", "").to_sym, :all
          else
            can permission.action.to_sym, :all
          end
        elsif permission.subject_id.nil?
          if permission.action.include?("not_")
            cannot permission.action.gsub("not_", "").to_sym, permission.subject_class.constantize          
          else
            can permission.action.to_sym, permission.subject_class.constantize          
          end
        else
          if permission.action.include?("not_")
            cannot permission.action.gsub("not_", "").to_sym, permission.subject_class.constantize, :id => eval(permission.subject_id)
          else
            can permission.action.to_sym, permission.subject_class.constantize, :id => eval(permission.subject_id)
          end
        end
      end
    end
  end

end
