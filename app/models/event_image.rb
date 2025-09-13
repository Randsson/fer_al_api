class EventImage < ApplicationRecord
  # Associations
  belongs_to :event

  # Validations
  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }
  validates :caption, length: { maximum: 255 }

  # Scopes
  scope :ordered, -> { order(:created_at) }
end
