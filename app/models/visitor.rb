# == Schema Information
#
# Table name: visitors
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
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string(255)
#  last_name              :string(255)
#  provider               :string(255)
#  uid                    :string(255)
#  agb                    :boolean          default(FALSE)
#  newsletter             :boolean
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer
#  unlock_token           :string(255)
#  locked_at              :datetime
#  authentication_token   :string(255)
#  username               :string(255)
#

class Visitor < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :token_authenticatable, :lockable

  has_many :comments, :class_name => Goldencobra::Comment, :as => :commentator

  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :provider, :uid, :agb, :newsletter, :username, :loginable

  validates_acceptance_of :agb, :accept => true
  has_many :role_users, :as => :operator, :class_name => Goldencobra::RoleUser
  has_many :roles, :through => :role_users, :class_name => Goldencobra::Role
  belongs_to :loginable, :polymorphic => true

  before_save :reset_authentication_token
  after_create :send_confirmation_mail


  scope :latest, lambda{ |counter| order("created_at DESC").limit(counter)}

  def title
    if self.username.present?
      self.username
    elsif self.first_name.present? && self.last_name.present?
      "#{self.first_name} #{self.last_name[0]}."
    else
      self.email
    end
  end

  def send_confirmation_mail
    if self.email.present? && Goldencobra::Setting.for_key('visitors.send_confirmation_mail') == 'true'
      Goldencobra::ConfirmationMailer.send_confirmation_mail(self.email).deliver!
    end
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    #logger.error auth.inspect
    visitor = Visitor.where(:provider => auth.provider, :uid => auth.uid).first
    unless visitor
      visitor = Visitor.find_by_email(auth.info.email)
      if visitor.present?
        visitor.provider = auth.provider
        visitor.uid = auth.uid
        visitor.save
      else
        pass = Devise.friendly_token[0,20]
        visitor = Visitor.create(username: auth.info.name,
                           provider: auth.provider    ,
                           uid: auth.uid              ,
                           email: auth.info.email     ,
                           password: pass             ,
                           password_confirmation: pass,
                           agb: true
                           )
      end
      logger.error "*"*20
      logger.error visitor.errors.inspect
    end
    visitor
  end

  # if you want to allow your users to cancel sign up with Facebook, you can redirect them to "cancel_user_registration_path"
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.user_data"] && session["devise.user_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
