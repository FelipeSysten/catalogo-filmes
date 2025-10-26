
class CommentsController < ApplicationController
 
  before_action :set_movie


  def create
    
    @comment = @movie.comments.build(comment_params)

   
    if current_user 
      @comment.user = current_user 
      @comment.name = current_user.email
    end

    if @comment.save
      redirect_to movie_path(@movie), notice: 'Comentário adicionado com sucesso!'
    else

      @comments = @movie.comments.order(created_at: :desc)
     
      render 'movies/show', status: :unprocessable_entity
    end
  end


  def destroy
   
    @comment = @movie.comments.find(params[:id])

   
    if @comment.user == current_user
      @comment.destroy
      redirect_to movie_path(@movie), notice: 'Comentário apagado com sucesso!'
    else
   
      redirect_to movie_path(@movie), alert: 'Você não tem permissão para apagar este comentário.'
    end
  rescue ActiveRecord::RecordNotFound
   
    redirect_to movie_path(@movie), alert: 'Comentário não encontrado.'
  end

  private


  def set_movie
    @movie = Movie.find(params[:movie_id])
  end


  def comment_params
    if current_user
      
      params.require(:comment).permit(:content)
    else
      
      params.require(:comment).permit(:name, :content)
    end
  end
end
