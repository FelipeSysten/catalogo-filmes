require "test_helper"

class MovieTest < ActiveSupport::TestCase
  # Teste 1: Garante que um filme é inválido sem um título
  test "should not save movie without title" do
    movie = Movie.new
    assert_not movie.save, "Saved the movie without a title"
  end

  # Teste 2: Garante que um filme é válido com um título
  test "should save valid movie" do
    # Você precisará de dados válidos aqui. 
    # Se você tiver fixtures, use-as. Caso contrário, crie um objeto válido.
    movie = Movie.new(title: "Meu Filme de Teste", description: "Uma descrição", release_date: Date.today)
    
    # Se o seu modelo tiver validações mais complexas, ajuste este objeto.
    assert movie.save, "Could not save a valid movie: #{movie.errors.full_messages.to_sentence}"
  end
end