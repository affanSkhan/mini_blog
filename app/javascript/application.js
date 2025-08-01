// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import * as bootstrap from "bootstrap"

// Initialize Bootstrap dropdowns on page load and after Turbo navigation
function initializeDropdowns() {
  document.querySelectorAll('.dropdown-toggle').forEach((dropdownToggleEl) => {
    // Check if dropdown is already initialized to avoid duplicates
    if (!bootstrap.Dropdown.getInstance(dropdownToggleEl)) {
      new bootstrap.Dropdown(dropdownToggleEl)
    }
  })
}

// Initialize on page load
document.addEventListener("DOMContentLoaded", initializeDropdowns)

// Initialize after Turbo navigation
document.addEventListener("turbo:load", initializeDropdowns)

// Re-initialize after Turbo cache restoration
document.addEventListener("turbo:render", initializeDropdowns)
