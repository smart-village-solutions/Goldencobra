# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  password_salt          :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0)
#  unlock_token           :string(255)
#  locked_at              :datetime
#  authentication_token   :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  gender                 :boolean
#  title                  :string(255)
#  firstname              :string(255)
#  lastname               :string(255)
#  function               :string(255)
#  phone                  :string(255)
#  fax                    :string(255)
#  facebook               :string(255)
#  twitter                :string(255)
#  linkedin               :string(255)
#  xing                   :string(255)
#  googleplus             :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable,
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :lockable, :registerable, :token_authenticatable
  acts_as_tagger
  # Setup accessible (or protected) attributes for your model
  validates_presence_of :firstname
  validates_presence_of :lastname
  liquid_methods :firstname, :lastname, :gender, :title, :function, :anrede, :gender_anrede

  attr_accessible :email, :password, :password_confirmation, :remember_me, :gender, :title, :firstname, :lastname, :function, :phone, :fax, :facebook, :twitter, :linkedin, :xing, :googleplus, :role_ids, :vita_steps_attributes
  has_and_belongs_to_many :roles, :join_table => "goldencobra_roles_users", :class_name => Goldencobra::Role, :include => [:permissions]
  has_many :vita_steps, :as => :loggable, :class_name => Goldencobra::Vita
  accepts_nested_attributes_for :vita_steps, allow_destroy: true, reject_if: lambda { |a| a[:description].blank? }

  before_save :ensure_authentication_token

  def has_role?(name)
    if name.class == String
      self.roles.include?(Goldencobra::Role.find_by_name(name))
    end
    if name.class == Array
      (self.roles & Goldencobra::Role.find_all_by_name(name)).any?
    end
  end

  def anrede
    if self.lastname == "n.v."
      r = "Sehr geehrte Damen und Herren"
    else
      if self.gender == true
        r = "Sehr geehrter Herr"
      else
        r = "Sehr geehrte Frau"
      end
      r << " #{self.title}" if self.title.present?
      r << " #{self.lastname}"
    end
    return r
  end

  def title
    "#{self.firstname} #{self.lastname} - #{self.email}"
  end

  def gender_anrede
    if self.gender == true
      "Sehr geehrter Herr"
    else
      "Sehr geehrte Frau"
    end
  end

end
