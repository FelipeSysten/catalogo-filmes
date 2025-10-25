# test/application_system_test_case.rb
require "test_helper" # Certifique-se que esta linha está no topo

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # Use o driver personalizado que registramos em test_helper.rb
  # Escolha entre :headless_firefox_with_locale ou :headless_chrome_with_locale
  driven_by :headless_firefox_with_locale, screen_size: [1400, 1400]

  # O bloco setup que tentava configurar o Accept-Language pode ser removido,
  # pois a configuração já está no driver personalizado.
  # Se você tem outras configurações no setup, pode mantê-las.
end