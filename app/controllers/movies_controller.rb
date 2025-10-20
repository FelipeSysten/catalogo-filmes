# app/controllers/movies_controller.rb
class MoviesController < ApplicationController
  # before_action para métodos que precisam de um filme específico (show, edit, update, destroy)
  before_action :set_movie, only: %i[ show edit update destroy ]
  # before_action para garantir que o usuário está logado para certas ações.
  # `authenticate_user!` é fornecido pelo Devise.
  # Excluímos :index e :show para que usuários não logados possam ver o catálogo e os detalhes.
  before_action :authenticate_user!, except: [:index, :show]
  # before_action para garantir que o usuário só edita/apaga seus próprios filmes.
  before_action :correct_user, only: [:edit, :update, :destroy]

  # GET /movies
  # Exibe a lista de filmes, aplicando busca e filtros.
  def index
    # Começa com todos os filmes, ordenados do mais novo para o mais antigo.
    @movies = Movie.all.order(release_year: :desc, created_at: :desc)

    # Lógica de Busca por Título, Diretor, Sinopse (usando ILIKE para case-insensitive)
    if params[:search].present?
      search_term = "%#{params[:search]}%" # Adiciona % para busca parcial
      @movies = @movies.where("title ILIKE ? OR director ILIKE ? OR synopsis ILIKE ?",
                              search_term, search_term, search_term)
      # Se você tiver um campo de elenco (cast), adicione a condição OR aqui:
      # @movies = @movies.or(@movies.where("cast ILIKE ?", search_term))
    end

    # Lógica de Filtro por Gênero
    # Esta implementação assume que você tem um atributo `genre_name` (string) no modelo Movie.
    # Se você tiver um modelo `Genre` separado e uma associação, a lógica seria diferente
    # (ex: `Movie.joins(:genres).where(genres: { id: params[:genre] })` ).
    if params[:genre].present? && params[:genre] != ""
      @movies = @movies.where("genre_name ILIKE ?", "%#{params[:genre]}%")
    end

    # Lógica de Filtro por Ano de Lançamento
    if params[:year].present? && params[:year] != ""
      @movies = @movies.where(release_year: params[:year])
    end

    # Lógica de Filtro para Checkboxes (Assista em casa, Assista nos Cinemas, etc.)
    # Isso exige que você tenha campos booleanos correspondentes no seu modelo `Movie`
    # (ex: `watch_at_home:boolean`, `watch_in_cinemas:boolean`, etc.).
    if params[:watch_at_home].present? && params[:watch_at_home] == "1"
      @movies = @movies.where(watch_at_home: true)
    end
    if params[:watch_in_cinemas].present? && params[:watch_in_cinemas] == "1"
      @movies = @movies.where(watch_in_cinemas: true)
    end
    if params[:manequim_films].present? && params[:manequim_films] == "1"
      @movies = @movies.where(manequim_films: true)
    end
    if params[:vitrine_session].present? && params[:vitrine_session] == "1"
      @movies = @movies.where(vitrine_session: true)
    end

    # Paginação: aplica a paginação após todos os filtros.
    # 'page(params[:page])' usa o número da página da URL.
    # '.per(6)' define que haverá 6 filmes por página.
    @movies = @movies.page(params[:page]).per(6)
  end

  # GET /movies/1
  # Exibe os detalhes de um filme específico.
  def show
    # @movie já foi carregado por `set_movie`
    @comment = @movie.comments.build # Instancia um novo comentário para o formulário na view
    @comments = @movie.comments.order(created_at: :desc) # Carrega os comentários existentes para exibir
  end

  # GET /movies/new
  # Exibe o formulário para criar um novo filme.
  def new
    @movie = current_user.movies.build # Cria um novo filme associado ao usuário logado
  end

  # GET /movies/1/edit
  # Exibe o formulário para editar um filme existente.
  def edit
    # @movie já foi carregado por `set_movie` e verificado por `correct_user`
  end

  # POST /movies
  # Tenta criar um novo filme com os parâmetros fornecidos.
  def create
    @movie = current_user.movies.build(movie_params) # Associa o filme ao usuário logado

    if @movie.save
      redirect_to @movie, notice: 'Filme foi criado com sucesso.'
    else
      render :new, status: :unprocessable_entity # Re-renderiza o formulário com erros
    end
  end

  # PATCH/PUT /movies/1
  # Tenta atualizar um filme existente com os parâmetros fornecidos.
  def update
    if @movie.update(movie_params)
      redirect_to @movie, notice: 'Filme foi atualizado com sucesso.'
    else
      render :edit, status: :unprocessable_entity # Re-renderiza o formulário com erros
    end
  end

  # DELETE /movies/1
  # Deleta um filme.
  def destroy
    @movie.destroy! # Usa `destroy!` para levantar um erro se a destruição falhar
    redirect_to movies_url, notice: 'Filme foi excluído com sucesso.'
  end

  private
    # Define o filme (@movie) baseado no ID da URL. Usado por `before_action`.
    def set_movie
      @movie = Movie.find(params[:id])
    rescue ActiveRecord::RecordNotFound # Captura erro se o filme não for encontrado
      redirect_to movies_url, alert: "Filme não encontrado."
    end

    # Define os parâmetros permitidos para o filme (strong parameters).
    # IMPORTANTE: Adapte esta lista com todos os campos do seu modelo Movie que
    # podem ser criados ou atualizados pelos formulários.
    def movie_params
      params.require(:movie).permit(:title, :synopsis, :release_year, :duration, :director,
                                   :genre_name, :poster_url, # Adicione 'poster_url' se usar um campo de URL para o poster
                                   :watch_at_home, :watch_in_cinemas, :manequim_films, :vitrine_session,
                                   :user_id) # :user_id pode ser útil se você estiver depurando, mas normalmente é definido automaticamente.
    end

    # Verifica se o usuário logado é o proprietário do filme.
    # Redireciona com uma mensagem se não for o caso.
    def correct_user
      # Tenta encontrar o filme associado ao current_user.
      # Se não encontrar, significa que o filme não pertence a este usuário (ou não existe).
      @movie = current_user.movies.find_by(id: params[:id])
      if @movie.nil?
        redirect_to movies_path, alert: "Você não tem permissão para editar ou excluir este filme."
      end
    end
end