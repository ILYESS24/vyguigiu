# Déploiement PrestaShop sur Render (512MB RAM)

## ⚡ Configuration optimisée pour contraintes mémoire

### Prérequis
- Compte Render (gratuit possible)
- 512MB RAM minimum
- Domaine (optionnel, Render fournit une URL gratuite)

### 🚀 Déploiement rapide

#### Via Render Dashboard (Recommandé)
1. **Créer un compte** sur [Render.com](https://render.com)
2. **Connecter votre repository Git** :
   - Dashboard → New → Web Service
   - Connecter votre repo GitHub
   - Sélectionner le service "prestashop" depuis `render.yaml`

#### Configuration automatique
Render détectera automatiquement :
- Le Dockerfile optimisé
- La base MySQL
- Les variables d'environnement

### 🔧 Configuration détaillée

#### Variables d'environnement (auto-configurées)
```bash
# Base de données
DB_SERVER=mysql
DB_NAME=prestashop
DB_USER=root
DB_PASSWD=${MYSQL_ROOT_PASSWORD}

# PrestaShop
PS_INSTALL_AUTO=1
PS_DEV_MODE=0
PS_ENABLE_SSL=1

# Optimisations RAM
PHP_MEMORY_LIMIT=128M
OPCACHE_MEMORY_CONSUMPTION=32
```

### 💾 Optimisations mémoire (512MB)

#### PHP
- **Mémoire max** : 128MB
- **Temps d'exécution** : 30 secondes
- **Upload max** : 8MB
- **OPcache** : Activé (32MB)

#### MySQL
- **Buffer pool** : 64MB
- **Connections max** : 10
- **Cache query** : 8MB
- **Tables temporaires** : 8MB

#### Apache
- **Workers max** : 10
- **Serveurs min** : 1
- **Cache** : Désactivé pour économiser RAM

### 📊 Ressources utilisées

| Service | RAM | CPU | Disque |
|---------|-----|-----|--------|
| PrestaShop | ~200MB | 0.1-0.5 | 500MB |
| MySQL | ~150MB | 0.1-0.3 | 1GB |
| **Total** | **~350MB** | **0.2-0.8** | **1.5GB** |

### 🌐 Accès à votre boutique

#### URL Render
Après déploiement, Render fournit une URL :
```
https://votre-service.onrender.com
```

#### Installation PrestaShop
1. Accéder à `https://votre-service.onrender.com/install`
2. L'installation est automatique grâce à `PS_INSTALL_AUTO=1`
3. Identifiants par défaut :
   - Email : `demo@prestashop.com`
   - Password : `Correct Horse Battery Staple`

### 🔄 Mises à jour

#### Déploiement automatique
Render déploie automatiquement à chaque push Git.

#### Mise à jour manuelle
```bash
git add .
git commit -m "Mise à jour PrestaShop"
git push origin develop
```

### 🚨 Limitations 512MB

#### Fonctionnalités désactivées
- ❌ Cache Smarty complet (trop gourmand)
- ❌ Logs détaillés
- ❌ Modules lourds (analytics, etc.)
- ❌ Import/export massifs

#### Recommandations
- ⚠️  Pas plus de 100 produits
- ⚠️  Pas plus de 10 catégories
- ⚠️  Utiliser des images optimisées (< 100KB)
- ⚠️  Désactiver les modules inutiles

### 🔒 Sécurité

#### Headers de sécurité (auto-configurés)
```apache
# HSTS, XSS Protection, Content Security Policy
# Via .htaccess.production
```

#### Variables sensibles
- Mots de passe générés automatiquement
- Stockés de manière sécurisée dans Render

### 📈 Monitoring

#### Métriques Render
- CPU, RAM, Bande passante
- Logs d'erreurs
- Status des services

#### Optimisations possibles
Si vous dépassez les 512MB :
1. Augmenter à 1GB (~10$/mois)
2. Désactiver plus de modules
3. Optimiser les images
4. Utiliser un CDN externe

### ☁️ Intégration Cloudflare (Optionnel)

#### Configuration gratuite
1. Ajouter votre domaine sur Cloudflare
2. Créer un CNAME vers votre URL Render
3. Activer le proxy (icône orange)

#### Bénéfices
- ✅ CDN gratuit
- ✅ Protection DDoS
- ✅ SSL automatique
- ✅ Cache supplémentaire

### 🆘 Dépannage

#### Erreur mémoire PHP
```
Fatal error: Allowed memory size exhausted
```
**Solution** : Réduire `PHP_MEMORY_LIMIT` à 64M (mais instable)

#### Timeout MySQL
```
SQLSTATE[HY000]: General error: 1205 Lock wait timeout
```
**Solution** : Réduire `innodb_lock_wait_timeout` à 10

#### Lent au démarrage
**Solution** : Activer OPcache (déjà configuré)

#### Erreur 500
**Solution** : Vérifier les logs Render dans le dashboard

### 💰 Coûts Render

| Plan | RAM | Prix | Statut |
|------|-----|------|--------|
| Free | 512MB | 0$ | ✅ Utilisé |
| Starter | 512MB | 7$/mois | Upgrade possible |
| Standard | 1GB | 25$/mois | Pour croissance |

### 🎯 Checklist déploiement

- [ ] Repo GitHub créé
- [ ] Code poussé sur GitHub
- [ ] Compte Render créé
- [ ] Service déployé depuis render.yaml
- [ ] URL Render obtenue
- [ ] Installation PrestaShop complétée
- [ ] Boutique accessible
- [ ] Modules inutiles désactivés
- [ ] Images optimisées
- [ ] Cache configuré

---

**🎉 Votre boutique e-commerce est maintenant en ligne avec seulement 512MB !**

**Temps estimé** : 10-15 minutes
