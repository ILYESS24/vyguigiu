# Dockerfile optimisé pour Spree API-Admin Only
FROM ruby:3.2-slim

# Installer les dépendances système
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    npm \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Créer le répertoire de l'application
WORKDIR /app

# Copier les fichiers Gem
COPY Gemfile Gemfile.lock common_spree_dependencies.rb ./

# Installer les gems
RUN bundle install --without development test --jobs 4 --retry 3

# Copier le code source (sauf les dossiers inutiles)
COPY . .

# Précompiler les assets (seulement pour admin)
RUN RAILS_ENV=production SECRET_KEY_BASE=dummy bundle exec rake assets:precompile

# Créer les dossiers nécessaires
RUN mkdir -p tmp/pids tmp/cache storage

# Nettoyer le cache apt et les gems de développement
RUN apt-get remove -y build-essential && apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Utilisateur non-root pour la sécurité
RUN useradd --create-home --shell /bin/bash spree
RUN chown -R spree:spree /app
USER spree

# Exposer le port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

# Commande de démarrage optimisée
CMD ["bundle", "exec", "puma", "-t", "1:1", "-w", "0", "-p", "3000"]
