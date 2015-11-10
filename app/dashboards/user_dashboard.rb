require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    owned_taggings: Field::HasMany.with_options(class_name: "::ActsAsTaggableOn::Tagging"),
    owned_tags: Field::HasMany.with_options(class_name: "::ActsAsTaggableOn::Tag"),
    role_users: Field::HasMany.with_options(class_name: "Goldencobra::RoleUser"),
    roles: Field::HasMany.with_options(class_name: "Goldencobra::Role"),
    vita_steps: Field::HasMany.with_options(class_name: "Goldencobra::Vita"),
    id: Field::Number,
    email: Field::String,
    encrypted_password: Field::String,
    reset_password_token: Field::String,
    reset_password_sent_at: Field::DateTime,
    remember_created_at: Field::DateTime,
    sign_in_count: Field::Number,
    current_sign_in_at: Field::DateTime,
    last_sign_in_at: Field::DateTime,
    current_sign_in_ip: Field::String,
    last_sign_in_ip: Field::String,
    password_salt: Field::String,
    confirmation_token: Field::String,
    confirmed_at: Field::DateTime,
    confirmation_sent_at: Field::DateTime,
    unconfirmed_email: Field::String,
    failed_attempts: Field::Number,
    unlock_token: Field::String,
    locked_at: Field::DateTime,
    authentication_token: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    gender: Field::Boolean,
    position: Field::String,
    firstname: Field::String,
    lastname: Field::String,
    function: Field::String,
    phone: Field::String,
    fax: Field::String,
    facebook: Field::String,
    twitter: Field::String,
    linkedin: Field::String,
    xing: Field::String,
    googleplus: Field::String,
    enable_expert_mode: Field::Boolean,
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :owned_taggings,
    :owned_tags,
    :role_users,
    :roles,
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = ATTRIBUTE_TYPES.keys

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :owned_taggings,
    :owned_tags,
    :role_users,
    :roles,
    :vita_steps,
    :email,
    :encrypted_password,
    :reset_password_token,
    :reset_password_sent_at,
    :remember_created_at,
    :sign_in_count,
    :current_sign_in_at,
    :last_sign_in_at,
    :current_sign_in_ip,
    :last_sign_in_ip,
    :password_salt,
    :confirmation_token,
    :confirmed_at,
    :confirmation_sent_at,
    :unconfirmed_email,
    :failed_attempts,
    :unlock_token,
    :locked_at,
    :authentication_token,
    :gender,
    :position,
    :firstname,
    :lastname,
    :function,
    :phone,
    :fax,
    :facebook,
    :twitter,
    :linkedin,
    :xing,
    :googleplus,
    :enable_expert_mode,
  ]
end
