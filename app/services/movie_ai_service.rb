# app/services/movie_ai_service.rb
require 'httparty' # Garante que a gem HTTParty esteja disponível para esta classe

class MovieAIService # Manteremos o nome da classe como MovieAIService para não alterar o controller
  include HTTParty # Inclui os métodos de HTTParty na classe

  BASE_URL = "https://api.themoviedb.org/3" # URL base da API do TMDB
  
  # Carrega a chave da API de forma segura de credentials.yml.enc
  API_KEY = Rails.application.credentials.the_movie_db_api_key

  # Verifica se a chave da API está configurada. Essencial para evitar erros em tempo de execução.
  if API_KEY.nil?
    raise "A chave THE_MOVIE_DB_API_KEY não está configurada. Por favor, adicione-a em credentials.yml.enc."
  end

  def self.fetch_movie_data(title)
    puts "[MovieAIService] Buscando filme no TMDB: #{title}"
    Rails.logger.info "[MovieAIService] Buscando filme no TMDB: #{title}"

    # 1. Primeiro, fazemos uma busca inicial pelo filme usando o título fornecido
    search_response = self.get("#{BASE_URL}/search/movie", query: {
      api_key: API_KEY,
      query: title,
      language: 'pt-BR' # Opcional: para receber resultados em português
    })

    # Verifica se a requisição de busca foi bem-sucedida
    unless search_response.success?
      Rails.logger.error "[MovieAIService] Erro na busca TMDB: #{search_response.code} - #{search_response.body}"
      return { error: "Erro ao buscar filme no TMDB. Código: #{search_response.code}." }
    end

    search_results = search_response.parsed_response['results']

    # Se nenhum filme for encontrado na busca
    if search_results.empty?
      return { error: "Filme '#{title}' não encontrado no TMDB. Tente um título diferente ou verifique a ortografia." }
    end

    # Pegamos o primeiro resultado da busca, que geralmente é o mais relevante
    first_movie = search_results.first
    movie_id = first_movie['id'] # Extrai o ID do filme para a próxima requisição

    # 2. Em seguida, buscamos os detalhes completos do filme usando o ID,
    # incluindo informações de elenco e equipe (credits)
    details_response = self.get("#{BASE_URL}/movie/#{movie_id}", query: {
      api_key: API_KEY,
      language: 'pt-BR',
      append_to_response: 'credits' # Adiciona dados de créditos (elenco e equipe) à resposta
    })

    # Verifica se a requisição de detalhes foi bem-sucedida
    unless details_response.success?
      Rails.logger.error "[MovieAIService] Erro nos detalhes TMDB: #{details_response.code} - #{details_response.body}"
      return { error: "Erro ao obter detalhes do filme no TMDB. Código: #{details_response.code}." }
    end

    movie_details = details_response.parsed_response

    # Extrai o diretor e os principais membros do elenco
    # Procura por um membro da equipe com o trabalho 'Director'
    director = movie_details['credits']['crew'].find { |crew_member| crew_member['job'] == 'Director' }&.fetch('name', 'Desconhecido')
    # Pega os 3 primeiros nomes do elenco para exibir
    cast_members = movie_details['credits']['cast'].take(3).map { |actor| actor['name'] }

    # Mapeia os dados recebidos do TMDB para o formato esperado pelo seu frontend
    {
      title: movie_details['title'].presence || title, # Mantém o título buscado se o do TMDB vier vazio
      synopsis: movie_details['overview'].presence || "Sinopse não disponível.",
      release_year: movie_details['release_date'].present? ? Date.parse(movie_details['release_date']).year : nil,
      duration: movie_details['runtime'].present? ? "#{movie_details['runtime']} min" : nil,
      director: director,
      cast: cast_members.any? ? cast_members : ["Elenco não disponível."]
    }.compact # Remove quaisquer chaves cujo valor seja nil para uma resposta mais limpa
  rescue HTTParty::Error => e
    Rails.logger.error "[MovieAIService] Erro HTTParty ao chamar a API do TMDB: #{e.message}"
    return { error: "Erro de conexão com a API do TMDB. Verifique sua conexão ou o status da API. Detalhes: #{e.message}" }
  rescue StandardError => e
    Rails.logger.error "[MovieAIService] Erro inesperado em MovieAIService (TMDB): #{e.class}: #{e.message}\n#{e.backtrace.join("\n")}"
    return { error: "Ocorreu um erro inesperado ao buscar o filme com TMDB. Detalhes: #{e.message}" }
  end
end