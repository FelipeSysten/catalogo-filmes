class Movie < ApplicationRecord
  # --- Associações ---
  belongs_to :user # Um filme pertence a um usuário
  has_many :comments, dependent: :destroy # Um filme tem muitos comentários
  has_one_attached :poster # Para upload do pôster usando Active Storage

  # Associações para Gêneros:
  # Você precisará de um modelo 'MovieGenre' (e sua tabela 'movie_genres') para a relação many-to-many.
  # Esta é a tabela intermediária que conecta filmes a gêneros.
  has_many :movie_genres, dependent: :destroy # Exemplo: movie_genres (tabela intermediária)
  has_many :genres, through: :movie_genres # Um filme tem muitos gêneros através de MovieGenre

  # --- Validações ---
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

  # Validação para o campo 'cast' (elenco), conforme discutimos para a busca.
  # Lembre-se de adicionar a coluna 'cast' (string ou text) à sua tabela `movies` via migração.
  # Ex: add_column :movies, :cast, :string
  validates :cast, presence: true, length: { minimum: 2 }, allow_blank: true


  # --- REMOÇÕES E EXPLICAÇÕES IMPORTANTES ---

  # REMOVIDO: `validates :genre_name, presence: true, length: { minimum: 2 }`
  # EXPLICAÇÃO: Com a criação do modelo `Genre` separado e as associações `has_many :genres, through: :movie_genres`,
  # o modelo `Movie` não precisa mais de uma coluna `genre_name` própria. A validação para o nome
  # do gênero agora pertence ao modelo `Genre` (em `app/models/genre.rb`).

  # REMOVIDO: `attribute :watch_at_home, :boolean, default: false` e linhas similares.
  # EXPLICAÇÃO: Estas declarações (`attribute :nome_do_campo, :tipo`) são usadas para atributos virtuais
  # ou para sobrescrever o tipo de colunas de banco de dados existentes.
  # Se 'watch_at_home', 'watch_in_cinemas', 'manequim_films' e 'vitrine_session' são
  # campos de filtro que você deseja persistir no banco de dados, eles DEVEM ser
  # colunas BOOLEANAS REAIS na sua tabela `movies`.
  #
  # Para adicionar essas colunas, você precisará gerar e executar uma migração. Exemplo:
  #
  #   rails generate migration AddFilterBooleansToMovies watch_at_home:boolean:default_false watch_in_cinemas:boolean:default_false manequim_films:boolean:default_false vitrine_session:boolean:default_false
  #   # Após gerar, pode ser necessário ajustar a migração para adicionar `null: false` se desejar.
  #
  #   # Conteúdo da migração (exemplo):
  #   class AddFilterBooleansToMovies < ActiveRecord::Migration[7.0]
  #     def change
  #       add_column :movies, :watch_at_home, :boolean, default: false, null: false
  #       add_column :movies, :watch_in_cinemas, :boolean, default: false, null: false
  #       add_column :movies, :manequim_films, :boolean, default: false, null: false
  #       add_column :movies, :vitrine_session, :boolean, default: false, null: false
  #     end
  #   end
  #   # E então, `rails db:migrate`
  #
  # Uma vez que estas colunas existam no banco de dados, o ActiveRecord irá automaticamente
  # mapeá-las para o seu modelo `Movie`, e você NÃO precisa declará-las com `attribute :name, :type`.


  # --- Métodos de Escopo (Exemplos, se as colunas existirem) ---
  # Estes são exemplos de como você pode usar as novas colunas booleanas para filtros
  # no seu controlador ou em outras partes da aplicação.
  
  # Exemplo de busca geral por Título, Diretor ou Elenco
  def self.search_movies(query)
    where("title ILIKE :query OR director ILIKE :query OR cast ILIKE :query", query: "%#{query}%")
  end

  # Escopos para os filtros de checkbox (assumindo que as colunas existem no DB)
  # scope :watch_at_home_eligible, -> { where(watch_at_home: true) }
  # scope :watch_in_cinemas_eligible, -> { where(watch_in_cinemas: true) }
  # scope :manequim_films_eligible, -> { where(manequim_films: true) }
  # scope :vitrine_session_eligible, -> { where(vitrine_session: true) }
  
  # Escopos para gênero e ano (se você quiser métodos mais limpos)
  scope :by_genre, ->(genre_name) { joins(:genres).where(genres: { name: genre_name }) if genre_name.present? }
  scope :by_release_year, ->(year) { where(release_year: year) if year.present? }


  # --- Lembretes Importantes para o Controller ---
  # Se você estiver usando `collection_check_boxes` para selecionar os gêneros,
  # certifique-se de configurar os strong parameters no seu controller para incluir `genre_ids: []`.
  # Exemplo: `params.require(:movie).permit(..., genre_ids: [])`
end