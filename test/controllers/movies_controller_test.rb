require "test_helper"

class MoviesControllerTest < ActionDispatch::IntegrationTest
  # É uma boa prática carregar as fixtures para ter dados pré-definidos para os testes.
  # Já que você está usando 'movies(:one)' em outros lugares, isso é importante.
  fixtures :movies, :users # Adicione :users se seus filmes dependem de usuários

  setup do
    @user = users(:felipe) # Carrega a fixture do usuário 'felipe'
    sign_in @user         # SIMULA o login do usuário antes de CADA TESTE
    # Se você usa `movies(:one)` ou `comments(:one)` em outros testes, certifique-se
    # que eles também foram carregados ou inicializados aqui se necessário.
    @movie = movies(:one) # Exemplo: Carrega uma fixture de filme
    @comment = comments(:one) # Exemplo: Carrega uma fixture de comentário
  end

  test "should get index" do
    # Garante que pelo menos uma fixture de filme esteja disponível para ser exibida
    # Isso resolve a falha "Expected 0 to be >= 1" se sua view exibe filmes.
    movies(:the_matrix) # Ou movies(:one), ou qualquer outra fixture que você queira que exista.

    get movies_url
    assert_response :success
    assert_template :index
    # CORREÇÃO: O texto correto é "EXPLORE NOSSO CATÁLOGO DE FILMES" (plural),
    # conforme o erro anterior que encontramos.
    assert_select 'h1', "EXPLORE NOSSO CATÁLOGO DE FILMES"

    # SUGESTÃO: Verifique se pelo menos um filme está sendo listado na página.
    # O seletor '.movie-card' é um exemplo, ajuste para a classe ou tag HTML que envolve seus filmes individuais.
    assert_select '.movie-card', minimum: 1
  end

  test "should create movie" do
    # É bom ser explícito: assert_difference('Movie.count', 1)
    # Certifique-se de que o usuário 'felipe' está definido em test/fixtures/users.yml
    # Se você não tem users.yml, você precisará criá-lo ou ajustar a forma como o user é associado.
    user_felipe = users(:felipe) # Carrega a fixture do usuário 'felipe'

    assert_difference('Movie.count', 1) do # Espera que 1 filme seja criado
      post movies_url, params: { movie: {
        title: "Novo Filme de Teste Criado",
        synopsis: "Uma breve sinopse do filme de teste recém-criado.",
        release_year: 2024,
        duration: 120,
        director: "Diretor Teste",
        # IMPORTANTE: Adicione AQUI TODOS OS OUTROS CAMPOS QUE SÃO OBRIGATÓRIOS no seu Movie model.
        # Por exemplo, se seu filme pertence a um usuário, você PRECISA incluir o user_id.
        user_id: user_felipe.id, # EXEMPLO: Se Movie `belongs_to :user`
        # release_date: "2024-01-01", # EXEMPLO: Se release_date for obrigatório
        # genre_id: 1 # EXEMPLO: Se genre_id for obrigatório e existir um gênero com ID 1
      } }
    end

    # **** LINHAS DE DEBUGGING (MUITO IMPORTANTES AQUI!) ****
    # Mantenha-as para depuração. Remova ou comente-as quando o teste estiver passando.
    # Garante que @movie foi atribuído no controller antes de tentar acessar .errors
    if assigns(:movie)
      if assigns(:movie).errors.any?
        puts "--- ERROS DE VALIDAÇÃO DO FILME ---"
        puts assigns(:movie).errors.full_messages.join(", ")
        puts "----------------------------------"
      end
    else
      puts "--- @movie NÃO FOI ATRIBUÍDO NO CONTROLLER ---"
    end
    puts "Response Body (para ver erros de renderização/redirect): #{response.body}"
    puts "Response Status: #{response.status}"
    # **** FIM DAS LINHAS DE DEBUGGING ****

    # Verifica se houve o redirecionamento esperado para a página do filme recém-criado.
    assert_redirected_to movie_url(Movie.last)

    # SUGESTÃO: Seguir o redirecionamento e verificar o conteúdo da página de destino.
    follow_redirect!
    # Verifica se o título do filme está presente na página após o redirecionamento
    assert_select 'h1', "Novo Filme de Teste Criado"
    # assert_select 'p', /Diretor Teste/ # Exemplo: Verifica se o diretor está na página
  end

  # SUGESTÃO: Adicione um teste para criação com dados inválidos
  test "should not create movie with invalid data" do
    assert_no_difference('Movie.count') do
      post movies_url, params: { movie: {
        title: "", # Título vazio (assumindo que é obrigatório)
        synopsis: "Uma sinopse válida.",
        release_year: 2024,
        duration: 120,
        director: "Diretor Teste",
        user_id: users(:felipe).id # Mesmo com dados inválidos, tente associar um user
      } }
    end
    # Verifica o status HTTP esperado quando a validação falha.
    # Geralmente é :unprocessable_entity (422) se o controller renderiza :new
    assert_response :unprocessable_entity
    # Opcional: Verifique se a view 'new' foi renderizada novamente
    # assert_template :new
    # Opcional: Verifique se as mensagens de erro estão presentes na página
    # assert_select 'li', "Title can't be blank"
  end
end