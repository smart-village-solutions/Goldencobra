class Ability
  include CanCan::Ability

  def initialize(operator=nil)
    can :read, Goldencobra::Article

    #Rechte die alle betreffen
    Goldencobra::Permission.where("role_id IS NULL OR role_id = ''").each do |permission|
      if permission.subject_id.blank?
        if permission.action.include?("not_")
          cannot permission.action.gsub("not_", "").to_sym, permission.subject_class.constantize
        else
          can permission.action.to_sym, permission.subject_class.constantize
        end
      else
        if permission.action.include?("not_")
          cannot permission.action.gsub("not_", "").to_sym, permission.subject_class.constantize, :id => permission.subject_id.to_i
        else
          can permission.action.to_sym, permission.subject_class.constantize, :id => permission.subject_id.to_i
          #check for parent
        end
      end
    end

    #Rechte, die nur bestimmte nutzerrollen betreffen
    if operator && operator.respond_to?(:roles)
      operator.roles.each do |role|
        role.permissions.each do |permission|

          if permission.subject_class == ":all"
            if permission.action.include?("not_")
              cannot permission.action.gsub("not_", "").to_sym, :all
            else
              can permission.action.to_sym, :all
            end
          end

          if !permission.subject_class.include?(":all") && permission.subject_id.blank?
            if permission.action.include?("not_")
              cannot permission.action.gsub("not_", "").to_sym, permission.subject_class.constantize
            else
              can permission.action.to_sym, permission.subject_class.constantize
            end
          end

          if !permission.subject_class.include?(":all") && permission.subject_id.present?
            if permission.action.include?("not_")
              cannot permission.action.to_s.gsub("not_", "").to_sym, permission.subject_class.constantize, :id => permission.subject_id.to_i
            else
              can permission.action.to_sym, permission.subject_class.constantize, :id => permission.subject_id.to_i
              #check for parent
            end
          end
        end
      end
    end

  end
end
