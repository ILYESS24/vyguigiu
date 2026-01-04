Rails.application.routes.draw do
  # API routes (v2) - pour les intégrations externes
  mount Spree::Api::Engine, at: '/api/v2'

  # Admin routes - interface d'administration principale
  mount Spree::Admin::Engine, at: '/admin'

  # Root redirect vers admin
  root to: redirect('/admin')

  # Health check endpoint
  get '/health', to: ->(env) { [200, {}, ['OK']] }
end
