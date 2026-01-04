# Spree Commerce - Configuration API-Admin Only

Cette configuration permet de déployer Spree Commerce avec **seulement l'interface d'administration et l'API**, sans le storefront (vitrine client). Idéal pour les environnements avec ressources limitées (512MB RAM).

## 🚀 Avantages

- **Mémoire réduite** : ~300-400MB vs 800MB+ avec storefront complet
- **Performance optimisée** : Moins de code à charger
- **Sécurité** : Interface admin sécurisée + API puissante
- **Flexibilité** : Créez votre propre storefront externe

## 📋 Fonctionnalités Incluses

### Interface Admin (`/admin`)
- ✅ Dashboard complet avec statistiques
- ✅ Gestion des produits (catalogue)
- ✅ Gestion des commandes et expéditions
- ✅ Gestion des clients
- ✅ Configuration de la boutique
- ✅ Rapports et analytics
- ✅ Gestion des promotions et remises

### API REST/GraphQL (`/api/v2`)
- ✅ API complète pour tous les objets Spree
- ✅ Authentification OAuth
- ✅ Webhooks pour intégrations
- ✅ Cache intelligent
- ✅ Documentation automatique

## 🚫 Fonctionnalités Exclues

- ❌ Vitrine client (storefront)
- ❌ Pages produits publiques
- ❌ Panier et checkout client
- ❌ Compte client public

## 🛠️ Installation

### 1. Prérequis
```bash
# Ruby 3.2+, PostgreSQL, Redis
sudo apt update
sudo apt install postgresql redis-server
```

### 2. Configuration
```bash
# Variables d'environnement
export DATABASE_URL="postgres://user:pass@localhost:5432/spree_db"
export REDIS_URL="redis://localhost:6379/0"
export REDIS_CACHE_URL="redis://localhost:6379/1"
export SECRET_KEY_BASE="$(rails secret)"
```

### 3. Installation des gems
```bash
bundle install
```

### 4. Base de données
```bash
rails db:create
rails db:migrate
rails db:seed  # Crée un admin par défaut
```

### 5. Lancement
```bash
# Développement
rails server

# Production avec Puma optimisé
bundle exec puma -t 1:1 -w 0
```

## 🌐 Accès

- **Admin** : `http://localhost:3000/admin`
  - Login par défaut : `admin@example.com` / `password`

- **API** : `http://localhost:3000/api/v2`
  - Documentation : `/api/v2/docs`

## 🔧 Optimisations Mémoire

### Variables d'environnement recommandées
```bash
# Threads limités
RAILS_MAX_THREADS=1

# Cache agressif
REDIS_CACHE_URL=redis://...

# Logs réduits
RAILS_LOG_LEVEL=warn

# Sessions courtes
DEVISE_SESSION_TIMEOUT=60  # minutes
```

### Puma configuration (`config/puma.rb`)
```ruby
workers 0  # Pas de workers
threads 1, 1  # 1 thread seulement
preload_app! false
```

## 📊 Consommation Mémoire

| Configuration | RAM utilisée | Status |
|---------------|--------------|---------|
| Spree complet | ~800MB+ | ❌ Trop lourd |
| API-Admin only | ~300-400MB | ✅ **Optimal** |
| API seulement | ~250MB | ✅ Ultra-léger |

## 🔗 Intégrations Externes

Puisque le storefront est supprimé, créez votre propre interface client :

### Frontend Frameworks
- **Next.js** avec API Spree
- **Vue.js/Nuxt** avec Storefront API
- **React** avec GraphQL

### Exemple d'intégration
```javascript
// Récupération des produits
const response = await fetch('/api/v2/storefront/products');
const products = await response.json();
```

## 🚀 Déploiement

### Render (512MB)
```yaml
# render.yaml
services:
  - type: web
    name: spree-admin
    env: ruby
    plan: starter  # 512MB RAM
    buildCommand: bundle install
    startCommand: bundle exec puma -t 1:1 -w 0
```

### Railway (gratuit)
```bash
# Déploiement automatique
railway up
```

## 📈 Monitoring

### Métriques importantes
- RAM utilisée (< 400MB idéal)
- Temps de réponse API (< 500ms)
- Cache hit ratio (> 80%)
- Erreurs 5xx (= 0)

### Health check
```bash
curl http://your-app.com/health
# Doit retourner "OK"
```

## 🔐 Sécurité

- Interface admin derrière authentification
- API avec OAuth tokens
- HTTPS obligatoire en production
- Variables d'environnement sécurisées

## 🆘 Support

- [Documentation Spree](https://spreecommerce.org/docs)
- [Slack Community](https://slack.spreecommerce.org)
- [GitHub Issues](https://github.com/spree/spree/issues)

---

**Résultat** : Une plateforme e-commerce complète avec interface d'administration moderne, API puissante, et consommation mémoire optimisée pour les environnements limités ! 🎯
