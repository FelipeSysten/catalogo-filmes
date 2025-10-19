# app/controllers/movies_controller.rb
class MoviesController < ApplicationController
  # set_movie é chamado apenas para show, edit, update e destroy
  # NOTA: O 'new' não está aqui porque ele cria um novo objeto, não busca um existente.
  before_action :set_movie, only: %i[ show edit update destroy ]

  # Garante que o usuário está logado para todas as ações, exceto index e show.
  before_action :authenticate_user!, except: [:index, :show]

  # GET /movies or /movies.json
  def index
    @movies = Movie.order(release_year: :desc).page(params[:page]).per(6)
  end

  # GET /movies/1 or /movies/1.json
  def show
    # @movie já foi definido pelo before_action :set_movie
    @comment = @movie.comments.build # Instancia um novo comentário para o formulário
    @comments = @movie.comments.order(created_at: :desc) # Busca os comentários para exibir
  end

  # GET /movies/new
  def new
    # Cria um novo filme associado ao usuário atualmente logado.
    @movie = current_user.movies.build
  end

  # GET /movies/1/edit
  def edit
    # @movie já foi definido pelo before_action :set_movie
    # Autorização: Só o criador pode editar.
    unless @movie.user == current_user
      redirect_to movies_path, alert: 'Você não tem permissão para editar este filme.'
    end
  end

  # POST /movies or /movies.json
  def create
    # Constrói e tenta salvar um novo filme.
    @movie = current_user.movies.build(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to movie_url(@movie), notice: 'Filme cadastrado com sucesso.' }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    # @movie já foi definido pelo before_action :set_movie
    # Autorização: Só o criador pode atualizar.
    unless @movie.user == current_user
      return redirect_to movies_path, alert: 'Você não tem permissão para atualizar este filme.'
    end

    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to movie_url(@movie), notice: 'Filme atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    # @movie já foi definido pelo before_action :set_movie
    # Autorização: Só o criador pode apagar.
    unless @movie.user == current_user
      return redirect_to movies_path, alert: 'Você não tem permissão para apagar este filme.'
    end

    @movie.destroy!

    respond_to do |format|
      format.html { redirect_to movies_url, notice: 'Filme apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # set_movie: Encontra um filme pelo 'id' nos parâmetros.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # movie_params: Strong Parameters para permitir apenas atributos seguros.
    def movie_params
      params.require(:movie).permit(:title, :synopsis, :release_year, :duration, :director)
      # NOTA: O user_id é atribuído automaticamente via current_user.movies.build
      # e não deve ser permitido aqui por segurança.
    end
end