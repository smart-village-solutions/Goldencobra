# == Schema Information
#
# Table name: users
#
#  id                     :integer(4)      not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer(4)      default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  password_salt          :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer(4)      default(0)
#  unlock_token           :string(255)
#  locked_at              :datetime
#  authentication_token   :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  gender                 :boolean(1)
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
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :lockable, :omniauthable, :registerable, :token_authenticatable
  acts_as_tagger
  # Setup accessible (or protected) attributes for your model
  validates_presence_of :firstname
  validates_presence_of :lastname
  liquid_methods :firstname, :lastname, :gender, :title, :function, :anrede

  attr_accessible :email, :password, :password_confirmation, :remember_me, :gender, :title, :firstname, :lastname, :function, :phone, :fax, :facebook, :twitter, :linkedin, :xing, :googleplus, :role_ids, :vita_steps
  has_and_belongs_to_many :roles, :join_table => "goldencobra_roles_users", :class_name => Goldencobra::Role, :include => [:permissions]
  has_many :vita_steps, :as => :loggable, :class_name => Goldencobra::Vita
  accepts_nested_attributes_for :vita_steps, allow_destroy: true, reject_if: lambda { |a| a[:description].blank? }

  before_save :ensure_authentication_token

  def has_role?(name)
    self.roles.include?(Goldencobra::Role.find_by_name(name))
  end

  def anrede
    if self.gender == true
      "Sehr geehrter Herr #{self.title} #{self.lastname}"
    else
      "Sehr geehrte Frau #{self.title} #{self.lastname}"
    end
  end

end
