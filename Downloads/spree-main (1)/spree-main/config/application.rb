require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SpreeAdminOnly
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Configuration for the application, engines, and railties goes here.

    # Spree configuration - API-Admin only
    config.spree = {
      api: {
        v2: {
          serializers_cache_ttl: 3600, # Cache des sérialiseurs API
          collection_cache_ttl: 1800   # Cache des collections
        }
      }
    }

    # Optimisations mémoire pour environnement limité
    config.cache_store = :redis_cache_store, {
      url: ENV.fetch('REDIS_CACHE_URL', 'redis://localhost:6379/0'),
      connect_timeout: 30,
      read_timeout: 0.2,
      write_timeout: 0.2,
      reconnect_attempts: 2
    }

    # Puma configuration optimisée
    config.puma = {
      workers: 0,  # Pas de workers pour économie mémoire
      threads: [1, 1]  # 1 thread seulement
    }

    # Désactiver les assets du storefront (non utilisé)
    config.serve_static_files = false

    # Time zone
    config.time_zone = "UTC"

    # I18n
    config.i18n.available_locales = [:en]
    config.i18n.default_locale = :en

    # Autoloader
    config.autoloader = :zeitwerk
  end
end
