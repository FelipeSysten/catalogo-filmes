require "application_system_test_case"

class MovieFlowTest < ApplicationSystemTestCase
  test "visiting the index and creating a new movie" do
    # 1. Navega para a página inicial (index)
    visit movies_url

    # 2. Verifica se a página contém o cabeçalho
    assert_selector "h1", text: "Filmes"

    # 3. Clica no link para criar um novo filme
    click_on "Novo Filme" # Assumindo que você tem um link com este texto

    # 4. Preenche o formulário
    fill_in "Título", with: "O Sucesso do Teste de Sistema"
    fill_in "Descrição", with: "Este filme foi criado por um teste automatizado."
    
    # 5. Clica no botão de submissão
    click_on "Criar Filme" # Assumindo que o botão tem este texto

    # 6. Verifica se a criação foi bem-sucedida
    assert_text "Filme criado com sucesso!"
    
    # 7. Verifica se o filme aparece na página de detalhes
    assert_selector "h1", text: "O Sucesso do Teste de Sistema"
  end
end