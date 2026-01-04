# Déploiement Aurion IDE sur Cloudflare

Ce guide explique comment déployer le site web d'Aurion IDE sur Cloudflare Pages.

## Prérequis

1. **Compte Cloudflare** : Créez un compte sur [cloudflare.com](https://cloudflare.com)
2. **Repository GitHub** : Le code doit être hébergé sur GitHub
3. **API Token Cloudflare** : Généré depuis le dashboard Cloudflare

## Configuration Cloudflare

### 1. Créer un projet Pages

1. Allez dans le [Cloudflare Dashboard](https://dash.cloudflare.com)
2. Cliquez sur "Pages" dans le menu latéral
3. Cliquez sur "Create a project"
4. Connectez votre repository GitHub
5. Configurez les paramètres :
   - **Project name**: `aurion-ide`
   - **Production branch**: `main` ou `master`
   - **Build command**: `npm run build`
   - **Build output directory**: `dist`

### 2. Générer un API Token

1. Allez dans "My Profile" > "API Tokens"
2. Cliquez sur "Create Token"
3. Utilisez le modèle "Cloudflare Pages Token" ou créez un token personnalisé avec ces permissions :
   - Account: Cloudflare Pages:Edit
   - Account: Cloudflare Pages:Read
   - Account: Account Settings:Read

### 3. Configurer les secrets GitHub

Dans votre repository GitHub :

1. Allez dans Settings > Secrets and variables > Actions
2. Ajoutez ces secrets :
   - `CLOUDFLARE_API_TOKEN`: Votre API token Cloudflare
   - `CLOUDFLARE_ACCOUNT_ID`: Votre Account ID Cloudflare (visible dans le dashboard)

## Déploiement

### Déploiement automatique

Une fois configuré, chaque push sur la branche principale déclenchera automatiquement le déploiement via GitHub Actions.

### Déploiement manuel

Pour déployer manuellement :

```bash
# Installer Wrangler CLI
npm install -g wrangler

# Se connecter à Cloudflare
wrangler auth login

# Déployer
npm run deploy
```

## Configuration du domaine

### Domaine personnalisé

1. Dans Cloudflare Pages, allez dans "Custom domains"
2. Ajoutez `aurion-ide.com`
3. Configurez les enregistrements DNS selon les instructions

### Sous-domaines

- Site principal : `aurion-ide.com`
- Documentation : `docs.aurion-ide.com` (redirigé vers docs.aurion-ide.com)

## Structure du projet

```
lapce-master/
├── dist/                    # Site généré (ignoré par git)
├── public/                  # Assets statiques
│   ├── _headers            # Configuration HTTP headers
│   └── _redirects          # Règles de redirection
├── scripts/                # Scripts de build
│   ├── build-website.js    # Génère le site depuis README.md
│   └── dev-server.js       # Serveur de développement
├── wrangler.toml          # Configuration Cloudflare
├── package.json           # Configuration npm
└── .github/workflows/     # CI/CD
    └── deploy.yml
```

## Développement local

```bash
# Installer les dépendances
npm install

# Démarrer le serveur de développement
npm run dev

# Construire le site
npm run build

# Prévisualiser la construction
npm run preview
```

## Optimisations

### Performance

- **Compression automatique** : Activée par défaut sur Cloudflare
- **CDN global** : Distribution automatique
- **Cache intelligent** : Configuré via `_headers`
- **Optimisation d'images** : Via Cloudflare Images (optionnel)

### Sécurité

- **HTTPS automatique** : Forcé sur tous les domaines
- **Headers de sécurité** : Configurés dans `_headers`
- **Protection DDoS** : Incluse avec Cloudflare
- **WAF** : Web Application Firewall disponible

## Monitoring

### Métriques disponibles

- **Temps de réponse** : Via Cloudflare Analytics
- **Taux d'erreur** : Suivi automatique
- **Trafic géographique** : Distribution des visiteurs
- **Performance** : Core Web Vitals

### Logs

- **Logs de déploiement** : Dans GitHub Actions
- **Logs d'accès** : Via Cloudflare Logs
- **Logs d'erreurs** : Configurables dans wrangler.toml

## Résolution des problèmes

### Problèmes courants

1. **Build qui échoue**
   - Vérifiez les logs GitHub Actions
   - Assurez-vous que toutes les dépendances sont dans package.json

2. **Déploiement qui échoue**
   - Vérifiez les secrets GitHub
   - Vérifiez les permissions du token Cloudflare

3. **Site non accessible**
   - Vérifiez la configuration DNS
   - Vérifiez les redirections dans `_redirects`

### Support

- **Documentation Cloudflare Pages** : https://developers.cloudflare.com/pages/
- **Community Discord** : https://discord.gg/cloudflaredev
- **Issues GitHub** : https://github.com/aurion-ide/aurion-ide/issues
