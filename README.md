# Catálogo de Filmes

![Página Principal do Catálogo de Filmes](https://i.imgur.com/your-screenshot-url.png )
*Substitua o link acima por uma captura de tela da sua aplicação.*

O **Catálogo de Filmes** é uma aplicação web desenvolvida em Ruby on Rails que permite aos usuários explorar, buscar e comentar sobre uma vasta coleção de filmes. A aplicação foi projetada para ser uma plataforma centralizada para entusiastas de cinema, com funcionalidades de autenticação de usuário, busca filtrada e um sistema de comentários.

Este projeto foi desenvolvido utilizando tecnologias modernas do ecossistema Rails e está configurado para deploy contínuo em plataformas como o Render.

## ✨ Funcionalidades Principais

- **Catálogo de Filmes:** Navegue por uma lista de filmes com pôsteres, títulos e informações básicas.
- **Busca e Filtragem:** Pesquise filmes por título, diretor ou elenco. Filtre os resultados por gênero e ano de lançamento.
- **Página de Detalhes:** Veja informações completas de cada filme, incluindo sinopse, elenco, diretor, duração e ano.
- **Sistema de Comentários:** Adicione comentários em filmes (disponível para usuários logados e anônimos).
- **Autenticação de Usuários:** Sistema completo de cadastro, login e gerenciamento de sessão com a gem **Devise**.
- **Upload de Pôsteres:** Gerenciamento de upload de imagens de pôsteres através do **Active Storage**.
- **Internacionalização (I18n):** Suporte para múltiplos idiomas (Português e Inglês).

## 🛠️ Tecnologias Utilizadas

- **Backend:** Ruby on Rails 8.0+
- **Frontend:** Hotwire (Turbo, Stimulus), Shakapacker (Webpack)
- **Banco de Dados:** PostgreSQL
- **Autenticação:** Devise
- **Paginação:** Kaminari
- **Processamento de Imagens:** `image_processing` / `ruby-vips`
- **Servidor Web:** Puma
- **Deploy:** Docker e Render

## 🚀 Começando

Siga as instruções abaixo para configurar e executar o projeto em seu ambiente de desenvolvimento local.

### Pré-requisitos

- **Ruby 3.3.0** (recomendamos o uso de um gerenciador de versões como [rbenv](https://github.com/rbenv/rbenv ) ou [RVM](https://rvm.io/ ))
- **Bundler** (`gem install bundler`)
- **Node.js** (versão 18 ou superior)
- **Yarn** (`npm install -g yarn`)
- **PostgreSQL** (rodando localmente)

### Instalação

1.  **Clone o repositório:**
    ```bash
    git clone https://github.com/FelipeSysten/catalogo-filmes.git
    cd catalogo-filmes
    ```

2.  **Instale a versão correta do Ruby:**
    Se você usa `rbenv`, ele instalará a versão do arquivo `.ruby-version` automaticamente.
    ```bash
    rbenv install 3.3.0
    ```

3.  **Instale as dependências do Ruby (gems ):**
    ```bash
    bundle install
    ```

4.  **Instale as dependências do JavaScript:**
    ```bash
    yarn install
    ```

5.  **Configure as variáveis de ambiente:**
    Crie um arquivo `.env` na raiz do projeto e adicione as variáveis necessárias. Você pode usar o arquivo `.env.example` como base.

    *`.env`*
    ```env
    # Senha para o usuário do seu banco de dados PostgreSQL local
    DB_PASSWORD_TEST="sua_senha_local"

    # Chave para a API do The Movie Database (TMDB)
    TMDB_API_KEY="sua_chave_da_api_tmdb"

    # Chave mestra do Rails para descriptografar credentials.yml.enc
    RAILS_MASTER_KEY="sua_rails_master_key"
    ```
    *Para obter a `RAILS_MASTER_KEY`, verifique o arquivo `config/master.key` (não comite este arquivo!).*

6.  **Crie e configure o banco de dados:**
    Certifique-se de que seu usuário do PostgreSQL (`felipe`, conforme `config/database.yml`) exista e tenha permissões para criar bancos de dados. Em seguida, execute:
    ```bash
    rails db:create
    rails db:migrate
    ```

7.  **Execute o servidor de desenvolvimento:**
    ```bash
    rails server
    ```

    A aplicação estará disponível em `http://localhost:3000`.

## ✅ Executando os Testes

Os testes automatizados são essenciais para garantir a qualidade do código. Para executá-los, primeiro configure o banco de dados de teste:

```bash
rails db:migrate RAILS_ENV=test
