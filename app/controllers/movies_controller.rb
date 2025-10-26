
class MoviesController < ApplicationController
  
  before_action :set_movie, only: %i[ show edit update destroy ]
 
  before_action :authenticate_user!, except: [:index, :show]

  before_action :correct_user, only: [:edit, :update, :destroy]

  
  def index
   
    @movies = Movie.all.order(release_year: :desc, created_at: :desc)

    
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @movies = @movies.where("title ILIKE ? OR director ILIKE ? OR synopsis ILIKE ?",
                              search_term, search_term, search_term)
      
    end

    
    if params[:genre].present? && params[:genre] != ""
      @movies = @movies.where("genre_name ILIKE ?", "%#{params[:genre]}%")
    end

    
    if params[:year].present? && params[:year] != ""
      @movies = @movies.where(release_year: params[:year])
    end

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

  
    @movies = @movies.page(params[:page]).per(6)
  end


  def show
   
    @comment = @movie.comments.build 
    @comments = @movie.comments.order(created_at: :desc) 
  end


  def new
    @movie = current_user.movies.build 
  end


  def edit
    
  end


  def create
    @movie = current_user.movies.build(movie_params) 

    if @movie.save
      redirect_to @movie, notice: 'Filme foi criado com sucesso.'
    else
      render :new, status: :unprocessable_entity 
    end
  end

  
  def update
    if @movie.update(movie_params)
      redirect_to @movie, notice: 'Filme foi atualizado com sucesso.'
    else
      render :edit, status: :unprocessable_entity 
    end
  end


  def destroy
    @movie.destroy! 
    redirect_to movies_url, notice: 'Filme foi excluído com sucesso.'
  end

   
    def search_ai
      title = params[:title]
  
      if title.blank?
        render json: { error: "O título do filme não pode estar vazio." }, status: :bad_request and return
      end
  
     
      movie_data = ::MovieAIService.fetch_movie_data(title) 
  
      if movie_data[:error]
        render json: movie_data, status: :unprocessable_entity
      else
        
        render json: movie_data, status: :ok
      end
    rescue => e 
      Rails.logger.error "Erro inesperado em MoviesController#search_ai: #{e.message}"
      render json: { error: "Ocorreu um erro interno no servidor: #{e.message}" }, status: :internal_server_error
    end


  private
    
    def set_movie
      @movie = Movie.find(params[:id])
    rescue ActiveRecord::RecordNotFound 
      redirect_to movies_url, alert: "Filme não encontrado."
    end

   
    def movie_params
      params.require(:movie).permit(:title, :synopsis, :release_year, :duration, :director, :poster, :description, :cast, genre_ids: [])
    end

    
    def correct_user
     
      @movie = current_user.movies.find_by(id: params[:id])
      if @movie.nil?
        redirect_to movies_path, alert: "Você não tem permissão para editar ou excluir este filme."
      end
    end


end