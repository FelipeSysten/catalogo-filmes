require "test_helper"

class MoviesControllerTest < ActionDispatch::IntegrationTest
  # Use fixtures para criar dados de teste
  # Se você não tiver fixtures para filmes, crie um aqui ou use a fábrica (se estiver usando FactoryBot)
  # fixtures :movies # Descomente se tiver um arquivo movies.yml em test/fixtures

  test "should get index" do
    get movies_url
    # Verifica se a resposta HTTP foi 200 (OK)
    assert_response :success 
    # Verifica se a view correta foi renderizada (opcional, mas bom)
    assert_template :index 
    # Verifica se o texto "Catálogo de Filmes" está presente na resposta
    assert_select "h1", "Catálogo de Filmes" 
  end

  # Exemplo de teste para a ação 'create' (criação de um novo filme)
  test "should create movie" do
    assert_difference('Movie.count') do
      post movies_url, params: { movie: { title: "Novo Filme", description: "Descrição", release_date: Date.today } }
    end

    # Verifica se após a criação o usuário é redirecionado
    assert_redirected_to movie_url(Movie.last)
    # Verifica se a mensagem de sucesso está presente
    assert_equal 'Filme criado com sucesso!', flash[:notice]
  end
end