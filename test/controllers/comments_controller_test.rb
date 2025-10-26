# test/controllers/comments_controller_test.rb
require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  # Supondo que você tenha fixtures ou crie um filme de teste
  # para que os comentários possam ser aninhados.
  # Ou você pode criar um @movie antes de cada teste.
  setup do
    @user = users(:felipe) # Carrega a fixture do usuário 'felipe'
    sign_in @user         # SIMULA o login do usuário antes de CADA TESTE
    @movie = movies(:one) # O movie associado ao comment
    @comment = comments(:one) # O comment que será destruído
  end

  test "should create comment" do
    # post comments_create_url, params: { ... } # INCORRETO
    assert_difference('Comment.count') do
      post movie_comments_url(@movie), params: { comment: { name: "Test User", content: "Great movie!" } }
    end
    assert_redirected_to movie_url(@movie) # Ou para onde o create do comentário redirecionar
  end

  test "should destroy comment" do
    # delete comments_destroy_url, params: { ... } # INCORRETO
    assert_difference('Comment.count', -1) do
      delete movie_comment_url(@movie, @comment)
    end
    assert_redirected_to movie_url(@movie) # Ou para onde o destroy do comentário redirecionar
  end
end