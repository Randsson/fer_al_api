class Review < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :event

  # Validations
  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :comment, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :user_id, uniqueness: { scope: :event_id, message: 'já avaliou este evento' }

  # Scopes
  scope :ordered, -> { order(created_at: :desc) }
  scope :by_rating, ->(rating) { where(rating: rating) }
  scope :recent, -> { where('created_at > ?', 1.week.ago) }
end
