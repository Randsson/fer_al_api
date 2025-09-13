class Notification < ApplicationRecord
  # Enums
  enum :notification_type, { event_reminder: 0, event_update: 1, new_review: 2, event_cancelled: 3, system_message: 4 }

  # Associations
  belongs_to :user
  belongs_to :event, optional: true

  # Validations
  validates :title, presence: true
  validates :message, presence: true
  validates :notification_type, presence: true

  # Scopes
  scope :unread, -> { where(read: false) }
  scope :read, -> { where(read: true) }
  scope :recent, -> { order(created_at: :desc) }
  scope :by_type, ->(type) { where(notification_type: type) }

  def mark_as_read!
    update!(read: true)
  end
end
