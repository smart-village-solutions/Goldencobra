class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    user.roles.each do |role|
      role.permissions.each do |permission|
        if permission.subject_class == ":all"          
          can permission.action.to_sym, :all
        elsif permission.subject_id.nil?
          can permission.action.to_sym, permission.subject_class.constantize          
        else
          can permission.action.to_sym, permission.subject_class.constantize, :id => eval(permission.subject_id)
        end
      end
    end
  end

end
