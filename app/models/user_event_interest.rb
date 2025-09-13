class UserEventInterest < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :event

  # Validations
  validates :user_id, uniqueness: { scope: :event_id }

  # Scopes
  scope :interested, -> { where(interested: true) }
  scope :reminded, -> { where(reminded: true) }
  scope :pending_reminder, -> { where(interested: true, reminded: false) }
end
