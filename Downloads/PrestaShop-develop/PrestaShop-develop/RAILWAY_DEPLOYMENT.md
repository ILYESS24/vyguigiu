# Déploiement PrestaShop sur Railway + Cloudflare

## 🚀 Guide de déploiement

### 1. Préparation du projet

#### Variables d'environnement Railway (à définir dans le dashboard)

```bash
# Base de données
DB_SERVER=mysql
DB_NAME=prestashop
DB_USER=root
DB_PASSWD=${{ MYSQL_ROOT_PASSWORD }}
DB_PREFIX=ps_

# PrestaShop
PS_INSTALL_AUTO=1
PS_DEV_MODE=0
PS_ENABLE_SSL=1
PS_FOLDER_ADMIN=admin
PS_FOLDER_INSTALL=install
PS_COUNTRY=fr
PS_LANGUAGE=fr

# Administrateur
ADMIN_MAIL=votre-email@domaine.com
ADMIN_PASSWD=votre_mot_de_passe_sécurisé

# Domaine
PS_DOMAIN=${{ RAILWAY_STATIC_URL }}

# Email (optionnel)
PS_MAIL_METHOD=3
PS_MAIL_SERVER=smtp.gmail.com
PS_MAIL_SMTP_ENCRYPTION=tls
PS_MAIL_SMTP_PORT=587

# Performance
PS_CACHE_ENABLED=1
PS_SMARTY_CACHE=1
PS_COOKIE_SAMESITE=Lax
```

### 2. Déploiement sur Railway

1. **Créer un compte** sur [Railway.app](https://railway.app)
2. **Connecter votre repository Git** :
   - Aller dans Railway Dashboard
   - Cliquer "New Project" → "Deploy from GitHub"
   - Sélectionner votre repository PrestaShop

3. **Ajouter une base de données MySQL** :
   - Dans votre projet Railway, cliquer "Add Plugin"
   - Sélectionner "MySQL"
   - La base de données sera automatiquement liée

4. **Configurer les variables d'environnement** :
   - Dans les settings de votre service
   - Ajouter toutes les variables listées ci-dessus

### 3. Configuration Cloudflare

1. **Ajouter votre domaine** :
   ```
   Dashboard Cloudflare → Websites → Add site
   ```

2. **Modifier les DNS** :
   - Copier les nameservers Cloudflare
   - Les coller dans les DNS de votre registrar

3. **Configurer le proxy** :
   - Dans Cloudflare : DNS → Activer le proxy (icône orange)
   - Votre domaine pointera vers Railway

### 4. Installation de PrestaShop

1. **Accéder à l'installateur** :
   ```
   https://votre-domaine.com/install
   ```

2. **Suivre l'installation automatique** :
   - La base de données sera détectée automatiquement
   - Utiliser les identifiants configurés dans les variables d'env

### 5. Optimisations Cloudflare

#### Règles de cache :
```
Dashboard → Caching → Cache Rules

# Règles recommandées :
- Cache les images (/img/*) : 1 heure
- Cache les assets statiques (/themes/*, /js/*, /css/*) : 1 jour
- Ne pas cacher l'admin (/admin/*)
- Ne pas cacher les pages dynamiques (/, /category/*, etc.)
```

#### Optimisations de performance :
```
Dashboard → Speed → Optimization
- ✅ Auto Minify (JavaScript, CSS, HTML)
- ✅ Brotli compression
- ✅ Rocket Loader (attention : peut casser certains scripts)
```

#### Sécurité :
```
Dashboard → Security → WAF
- ✅ Bot Management
- ✅ Rate Limiting (si nécessaire)
```

### 6. Migration de données (optionnel)

Si vous migrez depuis un autre hébergement :

```bash
# Exporter la base de données
mysqldump -u username -p database_name > prestashop_backup.sql

# Importer sur Railway
mysql -h railway_host -u root -p database_name < prestashop_backup.sql
```

### 7. Monitoring

#### Métriques Railway :
- CPU, RAM, bande passante dans le dashboard

#### Métriques Cloudflare :
- Visitors Analytics
- Security Events
- Performance insights

## 🔧 Commandes utiles

```bash
# Vider le cache PrestaShop
php bin/console cache:clear

# Mettre à jour la base de données
php bin/console doctrine:schema:update --force

# Générer les assets
npm run build
```

## 💡 Conseils de production

1. **Sauvegardes** : Configurer des backups automatiques sur Railway
2. **SSL** : Activé automatiquement via Cloudflare
3. **CDN** : Images et assets servis via Cloudflare
4. **Sécurité** : WAF Cloudflare activé
5. **Performance** : Cache intelligent configuré

## 🆘 Dépannage

### Problème : Installation qui boucle
**Solution** : Vérifier que `PS_INSTALL_AUTO=1` et que la DB est accessible

### Problème : Erreur 500
**Solution** : Vérifier les logs Railway et les permissions des fichiers

### Problème : Cache qui ne se vide pas
**Solution** : Purger le cache Cloudflare + cache PrestaShop

---

**Coût estimé** : ~10-20€/mois (Railway starter + domaine)
