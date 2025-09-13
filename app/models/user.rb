class User < ApplicationRecord
  has_secure_password

  # Enums
  enum :user_type, { visitor: 0, organizer: 1, admin: 2 }

  # Associations
  has_many :events, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :user_event_interests, dependent: :destroy
  has_many :interested_events, through: :user_event_interests, source: :event

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :user_type, presence: true
  validates :latitude, :longitude, presence: true, if: :organizer?

  # Geocoding
  geocoded_by :address
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }

  # Scopes
  scope :organizers, -> { where(user_type: :organizer) }
  scope :visitors, -> { where(user_type: :visitor) }
  scope :admins, -> { where(user_type: :admin) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def can_create_events?
    organizer? || admin?
  end
end
