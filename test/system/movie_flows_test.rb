require "application_system_test_case"

class MovieFlowTest < ApplicationSystemTestCase
  test "visiting the index and creating a new movie" do
    # 1. Navega para a página inicial (index)
    visit movies_url

    # 2. Verifica se a página contém o cabeçalho
    assert_selector "h1", text: "EXPLORE NOSSO CATÁLOGO DE FILMES"

    # 3. Clica no link para criar um novo filme
    click_on "Entrar"# Assumindo que você tem um link com este texto

    fill_in "Email", with: users(:admin_user).email # Preenche o campo de e-mail
    fill_in "Senha", with: "password"            # Preenche o campo de senha
                                                    # (Use a senha configurada no fixture users.yml)
    click_button "Entrar" # Substitua pelo texto ou ID do seu botão de login

  # 2. Verifica se a página contém o cabeçalho
    assert_selector "h1", text: "EXPLORE NOSSO CATÁLOGO DE FILMES"

    # 3. Clica no link para criar um novo filme
    click_on "Cadastrar Novo Filme"# Assumindo que você tem um link com este texto


    # 4. Preenche o formulário
    fill_in "Título", with: "O Sucesso do Teste de Sistema"
    fill_in "Sinopse", with: "Este filme foi criado por um teste automatizado."
    fill_in "Ano de Lançamento", with: "2025"
    fill_in "Duração (minutos)", with: "104"
    fill_in "Diretor", with: "Fernando Vasconcelos"
   
    save_and_open_page

    # 5. Clica no botão de submissão
    click_on "Salvar Filme" # Assumindo que o botão tem este texto

    # 6. Verifica se a criação foi bem-sucedida
    assert_text "Filme criado com sucesso!"
    
   
  end
end