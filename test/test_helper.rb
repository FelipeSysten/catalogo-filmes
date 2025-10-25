ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "capybara/rails"
require "selenium/webdriver"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

Capybara.register_driver :headless_firefox_with_locale do |app|
  options = Selenium::WebDriver::Firefox::Options.new
  # Define a preferência de idioma para pt-BR
  options.add_preference('intl.accept_languages', 'pt-BR')
  # Adiciona o argumento para rodar em modo headless (sem interface gráfica)
  options.add_argument('-headless')

  # Cria o driver Selenium com as opções configuradas
  Capybara::Selenium::Driver.new(app, browser: :firefox, options: options)
end

# Se você quiser também um driver Chrome com locale pt-BR e headless (opcional, mas bom ter)
Capybara.register_driver :headless_chrome_with_locale do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--no-sandbox')
  options.add_argument('--lang=pt-BR') # Define o idioma para o Chrome

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end
