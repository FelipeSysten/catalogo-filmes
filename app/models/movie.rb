class Movie < ApplicationRecord

  belongs_to :user 
  has_many :comments, dependent: :destroy 
  has_one_attached :poster

 
  has_many :movie_genres, dependent: :destroy 
  has_many :genres, through: :movie_genres

 
  validates :cast, length: { minimum: 2 }, allow_blank: true 
  validates :title, presence: true, length: { minimum: 2 }
  validates :synopsis, presence: true, length: { minimum: 10 }
  validates :release_year, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1800, less_than_or_equal_to: Date.current.year + 5 }
  validates :duration, presence: true, numericality: { only_integer: true, greater_than: 0 } # Duração em minutos
  validates :director, presence: true
  validates :poster,
    content_type: { in: ['image/png', 'image/jpeg'], message: 'deve ser PNG ou JPEG' },
    size: { less_than: 5.megabytes, message: 'deve ser menor que 5MB' },
    presence: false

  validates :cast, presence: true, length: { minimum: 2 }, allow_blank: true


  def self.search_movies(query)
    where("LOWER(title) LIKE ? OR LOWER(director) LIKE ? OR LOWER(\"cast\") LIKE ?", 
          "%#{query.downcase}%", "%#{query.downcase}%", "%#{query.downcase}%")
  end

  
  scope :by_genre, ->(genre_name) { joins(:genres).where(genres: { name: genre_name }) if genre_name.present? }
  scope :by_release_year, ->(year) { where(release_year: year) if year.present? }

end