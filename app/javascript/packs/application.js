import { Application } from "@hotwired/stimulus";

const application = Application.start();


const context = require.context("../controllers", true, /_controller\.js$/);


context.keys().forEach((filename) => {

  const identifier = filename
  .replace(/_controller\.js$/, '') 
  .replace(/^\.\//, '')             
  .replace(/\//g, '--')           
  .replace(/_/g, '-');             

  application.register(identifier, context(filename).default);
  console.log(`Stimulus controller registered: ${identifier}`); 
});


import '../stylesheets/application.scss';


import Rails from '@rails/ujs';
import Turbolinks from 'turbolinks';
import * as ActiveStorage from '@rails/activestorage';
import * as Channels from 'channels';

Rails.start();
Turbolinks.start();
ActiveStorage.start();


const setupMobileMenu = () => {
  const menuToggle = document.querySelector('.menu-toggle');
  const mobileNav = document.querySelector('.mobile-nav');

  if (menuToggle && mobileNav) {
    if (!mobileNav.id) {
      mobileNav.id = 'mobile-nav-menu';
    }
    menuToggle.setAttribute('aria-controls', mobileNav.id);
    menuToggle.setAttribute('aria-expanded', 'false');
    mobileNav.setAttribute('aria-hidden', 'true');

    const toggleMenu = () => {
      const isActive = mobileNav.classList.toggle('active');
      const icon = menuToggle.querySelector('i');

      if (icon) {
        if (isActive) {
          icon.classList.remove('fa-bars');
          icon.classList.add('fa-times');
        } else {
          icon.classList.remove('fa-times');
          icon.classList.add('fa-bars');
        }
      }
      menuToggle.setAttribute('aria-expanded', isActive.toString());
      mobileNav.setAttribute('aria-hidden', (!isActive).toString());
      document.body.classList.toggle('mobile-menu-open', isActive);
    };

    menuToggle.addEventListener('click', toggleMenu);
    menuToggle.addEventListener('keydown', (event) => {
      if (event.key === 'Enter' || event.key === ' ') {
        event.preventDefault();
        toggleMenu();
      }
    });
    document.addEventListener('keydown', (event) => {
      if (event.key === 'Escape' && mobileNav.classList.contains('active')) {
        toggleMenu();
      }
    });
    document.addEventListener('click', (event) => {
      if (mobileNav.classList.contains('active') &&
          !mobileNav.contains(event.target) &&
          !menuToggle.contains(event.target)) {
        toggleMenu();
      }
    });
  }
};

const setupFilterToggles = () => {
  const filterToggles = document.querySelectorAll('.filter-group .filter-toggle');

  filterToggles.forEach(toggle => {
    const filterOptions = toggle.nextElementSibling;
    const icon = toggle.querySelector('i');

    if (filterOptions && icon) {
      toggle.setAttribute('role', 'button');
      toggle.setAttribute('tabindex', '0');
      toggle.setAttribute('aria-expanded', 'false');

      if (!filterOptions.id) {
        filterOptions.id = `filter-options-${Math.random().toString(36).substr(2, 9)}`;
      }
      toggle.setAttribute('aria-controls', filterOptions.id);
      filterOptions.setAttribute('aria-hidden', 'true');

      const toggleFilter = () => {
        const isActive = filterOptions.classList.toggle('active');
        icon.classList.toggle('fa-chevron-down');
        icon.classList.toggle('fa-chevron-up');

        toggle.setAttribute('aria-expanded', isActive.toString());
        filterOptions.setAttribute('aria-hidden', (!isActive).toString());
      };

      toggle.addEventListener('click', toggleFilter);
      toggle.addEventListener('keydown', (event) => {
        if (event.key === 'Enter' || event.key === ' ') {
          event.preventDefault();
          toggleFilter();
        }
      });
    }
  });
};


document.addEventListener('turbolinks:load', () => {
  console.log("Hello from application.js - DOM ready!");

  setupMobileMenu();
  setupFilterToggles();
});

console.log("Hello from application.js (Loaded)");