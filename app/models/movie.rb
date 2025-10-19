class Movie < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :synopsis, presence: true, length: { minimum: 10 }
  validates :release_year, presence: true, numericality: { only_integer: true, greater_than: 1800, less_than_or_equal_to: Date.current.year + 5 }
  validates :duration, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :director, presence: true
end
