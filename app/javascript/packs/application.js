// Importa o stylesheet principal do Sass
import '../stylesheets/application.scss'

// Importa as bibliotecas Rails usando sintaxe ES Module (geralmente mais robusta com Webpack)
// Isso substitui os antigos 'require()' e tenta resolver o TypeError no Turbolinks.
import Rails from '@rails/ujs';
import Turbolinks from 'turbolinks'; // <-- Tentando resolver o TypeError aqui
import * as ActiveStorage from '@rails/activestorage';
import * as Channels from 'channels'; // Channels geralmente não precisa de .start()

Rails.start();
Turbolinks.start(); // <-- Se o TypeError persistir aqui, o problema é na instalação do Turbolinks ou na config do Webpack.
ActiveStorage.start();
// Channels (ActionCable) geralmente não possui um método .start() que precisa ser chamado aqui.
// A linha `require("channels")` no seu código original já era suficiente para carregar e iniciar
// o ActionCable consumer se app/javascript/channels/index.js estiver configurado.


// --- Funções para gerenciar interações da UI (Mobile Menu, Filtros) ---

// Função para configurar o menu mobile
const setupMobileMenu = () => {
  const menuToggle = document.querySelector('.menu-toggle');
  const mobileNav = document.querySelector('.mobile-nav');

  if (menuToggle && mobileNav) {
    // Adiciona um ID ao mobileNav se ele não tiver, para acessibilidade (aria-controls)
    if (!mobileNav.id) {
      mobileNav.id = 'mobile-nav-menu';
    }

    // Define atributos iniciais de acessibilidade (ARIA)
    menuToggle.setAttribute('aria-controls', mobileNav.id);
    menuToggle.setAttribute('aria-expanded', 'false'); // O menu está inicialmente fechado
    mobileNav.setAttribute('aria-hidden', 'true'); // O menu está inicialmente oculto

    const toggleMenu = () => {
      const isActive = mobileNav.classList.toggle('active'); // Alterna a classe 'active'
      const icon = menuToggle.querySelector('i'); // Assume que há um ícone dentro do toggle

      if (icon) { // Garante que o ícone exista antes de tentar manipulá-lo
        if (isActive) {
          icon.classList.remove('fa-bars');
          icon.classList.add('fa-times');
        } else {
          icon.classList.remove('fa-times');
          icon.classList.add('fa-bars');
        }
      }

      // Atualiza os atributos ARIA
      menuToggle.setAttribute('aria-expanded', isActive.toString());
      mobileNav.setAttribute('aria-hidden', (!isActive).toString());

      // Opcional: Adiciona/remove uma classe no body para controlar o scroll
      // (Útil para evitar o scroll da página quando o menu mobile está aberto)
      document.body.classList.toggle('mobile-menu-open', isActive);
    };

    // Evento de clique para o botão de toggle
    menuToggle.addEventListener('click', toggleMenu);

    // Eventos de teclado para acessibilidade (Enter ou Spacebar)
    menuToggle.addEventListener('keydown', (event) => {
      if (event.key === 'Enter' || event.key === ' ') {
        event.preventDefault(); // Evita o scroll da página ao pressionar espaço
        toggleMenu();
      }
    });

    // Fechar o menu ao pressionar a tecla 'Escape'
    document.addEventListener('keydown', (event) => {
      if (event.key === 'Escape' && mobileNav.classList.contains('active')) {
        toggleMenu();
      }
    });

    // Fechar o menu ao clicar fora dele
    document.addEventListener('click', (event) => {
      // Verifica se o menu está ativo E se o clique não foi dentro do menu E não foi no botão de toggle
      if (mobileNav.classList.contains('active') &&
          !mobileNav.contains(event.target) &&
          !menuToggle.contains(event.target)) {
        toggleMenu();
      }
    });
  }
};

// Função para configurar os toggles de filtro (Gênero, Ano, etc.)
// Baseado na análise de imagem anterior, adicione se você tiver esses elementos no HTML.
const setupFilterToggles = () => {
  const filterToggles = document.querySelectorAll('.filter-group .filter-toggle');

  filterToggles.forEach(toggle => {
    const filterOptions = toggle.nextElementSibling; // Assume que as opções estão no próximo elemento irmão
    const icon = toggle.querySelector('i'); // Assume que há um ícone dentro do toggle

    if (filterOptions && icon) {
      // Define atributos iniciais de acessibilidade para o toggle
      toggle.setAttribute('role', 'button');
      toggle.setAttribute('tabindex', '0'); // Torna o elemento focável
      toggle.setAttribute('aria-expanded', 'false');

      // Adiciona um ID às opções de filtro se não tiverem, para aria-controls
      if (!filterOptions.id) {
        filterOptions.id = `filter-options-${Math.random().toString(36).substr(2, 9)}`; // ID único
      }
      toggle.setAttribute('aria-controls', filterOptions.id);
      filterOptions.setAttribute('aria-hidden', 'true'); // Inicialmente oculto

      const toggleFilter = () => {
        const isActive = filterOptions.classList.toggle('active'); // Alterna a classe 'active'
        icon.classList.toggle('fa-chevron-down');
        icon.classList.toggle('fa-chevron-up'); // Altera a direção da seta

        // Atualiza os atributos ARIA
        toggle.setAttribute('aria-expanded', isActive.toString());
        filterOptions.setAttribute('aria-hidden', (!isActive).toString());
      };

      // Evento de clique para o toggle do filtro
      toggle.addEventListener('click', toggleFilter);

      // Eventos de teclado para acessibilidade (Enter ou Spacebar)
      toggle.addEventListener('keydown', (event) => {
        if (event.key === 'Enter' || event.key === ' ') {
          event.preventDefault();
          toggleFilter();
        }
      });
    }
  });
};

// --- Execução após o carregamento do Turbolinks ---
document.addEventListener('turbolinks:load', () => {
  console.log("Hello from application.js - DOM ready!");

  // Chama as funções de configuração da UI
  setupMobileMenu();
  setupFilterToggles(); // Chame esta função apenas se você tiver os elementos HTML para filtros
});

console.log("Hello from application.js (Loaded)"); // Um log para indicar que o arquivo foi carregado