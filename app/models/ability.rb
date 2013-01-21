class Ability
  include CanCan::Ability

  def initialize(operator)
    can :read, Goldencobra::Article
    #cannot :read, Goldencobra::Article, :id => 16

    #Wenn es keinen angemeldeten operator gibt
    #if operator.blank?
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
    #end

    # if operator.respond_to?(:roles)
      if operator
        operator.roles.each do |role|
          role.permissions.each do |permission|
            if permission.subject_class == ":all"
              if permission.action.include?("not_")
                cannot permission.action.gsub("not_", "").to_sym, :all
              else
                can permission.action.to_sym, :all
              end
            elsif permission.subject_id.blank?
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
        # end
      end
    end

  end
end
