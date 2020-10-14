class Client < ApplicationRecord
  has_one :enroll, -> { order(created_at: :desc) }, inverse_of: :client
  has_many :order_appointments, dependent: :destroy
  include PartnerClient
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :cpf, presence: true
  validates :cpf, uniqueness: true
  validate :cpf_validation
  before_validation :clean_cpf

  def domain
    email.split('@')[1]
  end

  def already_enrolled?
    enroll.present?
  end

  private

  def cpf_validation
    return if CPF.valid?(cpf)

    errors.add(:cpf, :cpf_invalid)
  end

  def clean_cpf
    self[:cpf] = CPF.new(cpf).stripped
  end
end
