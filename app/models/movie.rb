class Movie < ApplicationRecord
  belongs_to :user # Um filme pertence a um usuário
  has_many :comments, dependent: :destroy # Um filme tem muitos comentários

  # Validações (mantenha ou adicione as suas)
  validates :title, presence: true, length: { minimum: 2 }
  validates :synopsis, presence: true, length: { minimum: 10 }
  validates :release_year, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1800, less_than_or_equal_to: Date.current.year + 5 }
  validates :duration, presence: true, numericality: { only_integer: true, greater_than: 0 } # Duração em minutos
  validates :director, presence: true

  # Novos campos para filtros, se você decidir implementá-los no modelo:
  # genre_name (string): Para o filtro de gênero se não usar um modelo Genre
  validates :genre_name, presence: true, length: { minimum: 2 } # Exemplo de validação para genre_name

  # Campos booleanos para os checkboxes
  # Adicione estas linhas se você deseja que os checkboxes filtrem por atributos no filme
  # e certifique-se de ter rodado as migrações para adicionar essas colunas.
  attribute :watch_at_home, :boolean, default: false
  attribute :watch_in_cinemas, :boolean, default: false
  attribute :manequim_films, :boolean, default: false
  attribute :vitrine_session, :boolean, default: false

  # Se você estiver usando Active Storage para upload de pôsteres
  # has_one_attached :poster

  # Se você tiver um `poster_url` como um campo de string
  # validates :poster_url, format: URI::regexp(%w[http https]), allow_blank: true
end