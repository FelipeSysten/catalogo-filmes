require_relative "boot"

require "rails/all"


Bundler.require(*Rails.groups)

module CatalogoFilmes
  class Application < Rails::Application

    config.i18n.default_locale = 'pt-BR'

    config.i18n.available_locales = %i[en pt-BR]

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    
 
    config.load_defaults 8.0

   
    config.autoload_lib(ignore: %w[assets tasks])

  
  end
end
