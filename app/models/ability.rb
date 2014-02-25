# encoding: utf-8

class Ability
  include CanCan::Ability

  def initialize(operator=nil)
    can :read, Goldencobra::Article
    can :read, Goldencobra::Menue
    can :read, Goldencobra::Widget

    #Rechte die alle betreffen
    Goldencobra::Permission.where("action IS NOT NULL").where("role_id IS NULL OR role_id = ''").each do |permission|
      set_permission(permission)
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
          else
            set_permission(permission)
          end
        end
      end
    end
  end

  def set_permission(permission)
    able = 'can'
    action_name = permission.action.to_sym
    model_name = permission.subject_class.constantize

    if permission.action.include?("not_")
      action_name = permission.action.gsub("not_", "").to_sym
      able = 'cannot'
    end

    if permission.subject_id.present?
      set_ability(able, action_name, model_name, permission.subject_id.to_i)
      set_child_permissions(able, action_name, model_name, permission.subject_id.to_i)
    else
      set_ability(able, action_name, model_name)
    end
  end

  def set_ability(able, action_name, model_name, id_name=nil)
    if id_name.present?
      send(able, action_name, model_name, id: id_name)
    else
      send(able, action_name, model_name)
    end
  end

  def set_child_permissions(able, action_name, model_name,id_name)
    if %w(can cannot).include?(able) && model_name.new.respond_to?(:descendant_ids) && object = model_name.find_by_id(id_name)
      object.descendant_ids.each do |child_id|
        set_ability(able, action_name, model_name, child_id)
      end
    end
  end
end