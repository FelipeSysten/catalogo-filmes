# app/controllers/comments_controller.rb
class CommentsController < ApplicationController
  # O 'set_movie' garante que @movie esteja disponível nas ações de create e destroy
  # Ele busca o filme usando o movie_id dos parâmetros da rota aninhada.
  before_action :set_movie

  # Ação CREATE: Processa a submissão do formulário de comentários.
  def create
    # Constrói um novo comentário associado ao @movie, utilizando os parâmetros permitidos.
    @comment = @movie.comments.build(comment_params)
    @comment.user = current_user 

    # Lógica para associar o comentário ao usuário logado, se houver.
    if current_user # 'current_user' é um helper do Devise
      @comment.user = current_user # Associa o objeto User ao comentário
      # Opcional: preenche o campo 'name' do comentário com o email do usuário logado
      # Você pode mudar para current_user.name se o seu modelo User tiver um campo 'name'.
      @comment.name = current_user.email
    end
    # Se não houver current_user, o campo 'name' (se permitido via comment_params)
    # será preenchido diretamente do formulário, conforme a lógica do desafio para anônimos.

    if @comment.save
      # Se o comentário for salvo com sucesso, redireciona para a página do filme
      redirect_to movie_path(@movie), notice: 'Comentário adicionado com sucesso!'
    else
      # Se o comentário falhar na validação (ex: conteúdo vazio),
      # precisamos re-renderizar a página de detalhes do filme (@movie.show).
      # Para isso, precisamos garantir que as variáveis necessárias para a view 'movies/show' estejam definidas:
      @comments = @movie.comments.order(created_at: :desc) # Re-busca os comentários existentes para exibição
      # Renderiza o template 'movies/show' e envia um status HTTP 422 (unprocessable entity)
      render 'movies/show', status: :unprocessable_entity
    end
  end

  # Ação DESTROY: Apaga um comentário.
  def destroy
    # Encontra o comentário específico que pertence ao filme atual.
    # Isso também serve como uma camada de segurança para evitar que um comentário
    # de outro filme seja apagado por engano.
    @comment = @movie.comments.find(params[:id])

    # Lógica de autorização: Somente o usuário que criou o comentário pode apagá-lo.
    # Comentários anônimos (sem 'user_id') não poderão ser apagados por esta lógica.
    if @comment.user == current_user
      @comment.destroy
      redirect_to movie_path(@movie), notice: 'Comentário apagado com sucesso!'
    else
      # Se o usuário não tiver permissão, redireciona com uma mensagem de alerta.
      redirect_to movie_path(@movie), alert: 'Você não tem permissão para apagar este comentário.'
    end
  rescue ActiveRecord::RecordNotFound
    # Trata o caso em que o comentário não é encontrado (ex: já foi apagado por outro).
    redirect_to movie_path(@movie), alert: 'Comentário não encontrado.'
  end

  private

  # Método auxiliar para buscar o filme antes das ações.
  # O 'params[:movie_id]' vem da rota aninhada 'resources :movies do resources :comments'.
  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  # Método Strong Parameters para garantir a segurança dos dados do formulário.
  def comment_params
    if current_user
      # Para usuários logados, apenas o 'content' é permitido, pois o 'name' e 'user_id'
      # serão preenchidos automaticamente pelo controlador.
      params.require(:comment).permit(:content)
    else
      # Para usuários anônimos, 'name' e 'content' são permitidos.
      # O 'name' é obrigatório no modelo Comment (validação: validates :name, presence: true, unless: :user_id?).
      params.require(:comment).permit(:name, :content)
    end
  end
end
