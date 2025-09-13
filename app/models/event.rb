class Event < ApplicationRecord
  # Enums
  enum :status, { draft: 0, published: 1, cancelled: 2, finished: 3 }

  # Associations
  belongs_to :user
  belongs_to :category
  has_many :reviews, dependent: :destroy
  has_many :event_images, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :user_event_interests, dependent: :destroy
  has_many :interested_users, through: :user_event_interests, source: :user

  # Validations
  validates :title, presence: true
  validates :description, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :latitude, :longitude, presence: true
  validates :address, presence: true
  validates :status, presence: true
  validate :end_date_after_start_date

  # Geocoding
  geocoded_by :address
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }

  # Scopes
  scope :published, -> { where(status: :published) }
  scope :upcoming, -> { where('start_date > ?', Time.current) }
  scope :current, -> { where('start_date <= ? AND end_date >= ?', Time.current, Time.current) }
  scope :past, -> { where('end_date < ?', Time.current) }
  scope :featured, -> { where(featured: true) }
  scope :by_category, ->(category_id) { where(category_id: category_id) }
  scope :near_location, ->(latitude, longitude, distance = 10) { near([latitude, longitude], distance) }

  def duration_in_hours
    return 0 unless start_date && end_date
    ((end_date - start_date) / 1.hour).round(2)
  end

  def is_upcoming?
    start_date > Time.current
  end

  def is_current?
    start_date <= Time.current && end_date >= Time.current
  end

  def average_rating
    reviews.average(:rating) || 0
  end

  def total_reviews
    reviews.count
  end

  private

  def end_date_after_start_date
    return unless start_date && end_date
    
    errors.add(:end_date, 'deve ser posterior à data de início') if end_date < start_date
  end
end
