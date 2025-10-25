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
    user = users(:felipe)
    
    # 2. Defina TODOS os atributos obrigatórios para o filme
    movie_attributes = {
      title: "My Awesome Movie",
      synopsis: "This is a really great movie with a compelling plot and interesting characters.",
      release_year: 2023,
      duration: 120, # em minutos
      director: "John Doe",
      user: user, # Atribua o usuário
      # Se você adicionou 'release_date', adicione aqui também
      release_date: Date.today
    }

    movie = Movie.new(movie_attributes)

    # DEBUG: Opcionalmente, adicione isso para ver as validações falhando
    unless movie.valid?
      puts "Movie validation errors: #{movie.errors.full_messages.join(', ')}"
    end
    # Se o seu modelo tiver validações mais complexas, ajuste este objeto.
    assert movie.save, "Could not save a valid movie: #{movie.errors.full_messages.to_sentence}"
  end
end