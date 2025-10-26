# config/application.rb
require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CatalogoFilmes
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0 # Mantenha a versão que você tem, provavelmente 8.0

    # Configuração de Internacionalização (I18n)
    config.i18n.default_locale = 'pt-BR'
    config.i18n.available_locales = %i[en pt-BR]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    
    # Ignora assets e tasks no autoload padrão da lib (Rails 7.1+)
    config.autoload_lib(ignore: %w[assets tasks])

    # **CORREÇÃO CRÍTICA PARA AUTOLOADING DE 'app/services'**
    # Adiciona app/services explicitamente aos caminhos de eager loading (produção)
    # e autoloading (desenvolvimento e teste) para Zeitwerk (Rails 6+)
    config.eager_load_paths << Rails.root.join('app/services')
    config.autoload_paths << Rails.root.join('app/services')
    
    # Garante que o autoloader Zeitwerk está ciente do diretório app/services
    # Este bloco `to_prepare` é executado uma vez em produção/testes e em cada request em dev.
    config.to_prepare do
      Rails.autoloaders.main.push_dir(Rails.root.join('app/services'))
    end
    # Este `end` fecha o bloco `config.to_prepare do`

  end # <--- ESTE `end` fecha a `class Application < Rails::Application`
end # <--- ESTE `end` fecha o `module CatalogoFilmes`