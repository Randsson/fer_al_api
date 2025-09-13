class Category < ApplicationRecord
  # Associations
  has_many :events, dependent: :destroy

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :color, presence: true, format: { with: /\A#[0-9A-Fa-f]{6}\z/, message: "deve ser um código hexadecimal válido" }
  validates :icon, presence: true

  # Scopes
  scope :ordered, -> { order(:name) }
end
