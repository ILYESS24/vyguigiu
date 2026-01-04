# Déploiement PearAI sur Cloudflare Pages

Ce guide explique comment déployer la version web de PearAI sur Cloudflare Pages.

## Prérequis

1. **Compte Cloudflare** : Un compte Cloudflare avec Pages activé
2. **API Token Cloudflare** : Un token API avec les permissions Pages
3. **GitHub Repository** : Ce dépôt doit être sur GitHub

## Configuration

### 1. Variables d'environnement GitHub

Ajoutez ces secrets dans votre dépôt GitHub (Settings > Secrets and variables > Actions) :

- `CLOUDFLARE_API_TOKEN` : Votre token API Cloudflare
- `CLOUDFLARE_ACCOUNT_ID` : L'ID de votre compte Cloudflare

### 2. Trouver votre Account ID

1. Connectez-vous à votre [dashboard Cloudflare](https://dash.cloudflare.com/)
2. Cliquez sur votre compte dans le coin supérieur gauche
3. Votre Account ID est affiché dans l'URL ou dans les paramètres du compte

### 3. Créer un token API

1. Allez dans [My Profile > API Tokens](https://dash.cloudflare.com/profile/api-tokens)
2. Cliquez sur "Create Token"
3. Utilisez le template "Edit Cloudflare Workers" ou créez un token personnalisé avec :
   - Account > Cloudflare Pages > Edit
   - Zone > Page Rules > Edit

## Déploiement

### Méthode 1: Déploiement automatique (Recommandé)

1. Poussez ces fichiers sur votre branche principale :
   - `wrangler.toml`
   - `.github/workflows/deploy.yml`

2. Le déploiement se fera automatiquement à chaque push sur la branche principale

### Méthode 2: Déploiement manuel

1. Installez Wrangler CLI :
   ```bash
   npm install -g wrangler
   ```

2. Authentifiez-vous :
   ```bash
   wrangler auth login
   ```

3. Déployez :
   ```bash
   wrangler pages deploy vscode-web --project-name=pearai-app
   ```

## Structure des fichiers

Après le build, les fichiers seront dans le répertoire `vscode-web/` avec cette structure :
```
vscode-web/
├── index.html
├── out/
│   ├── vs/
│   │   ├── workbench/
│   │   └── ...
│   └── ...
├── node_modules/
└── package.json
```

## Commandes de build

Pour tester le build localement :

```bash
# Installer les dépendances
npm install

# Construire la version web
npm run deploy-web

# Construire la version minifiée (optimisée pour la production)
npm run deploy-web-min
```

## Dépannage

### Erreur de compilation
Si vous rencontrez des erreurs de compilation liées aux dépendances natives :
- Utilisez la version web uniquement : `npm run vscode-web`
- Assurez-vous d'avoir Node.js 18+ installé

### Erreur de déploiement
- Vérifiez que votre token API a les bonnes permissions
- Vérifiez que l'Account ID est correct
- Assurez-vous que le projet Pages existe dans Cloudflare

### Performance
Pour optimiser les performances :
- Utilisez `npm run vscode-web-min` pour une version minifiée
- Configurez la compression gzip dans Cloudflare
- Utilisez un CDN edge pour les ressources statiques

## Domaines personnalisés

Pour utiliser un domaine personnalisé :

1. Dans Cloudflare Pages, allez dans votre projet
2. Cliquez sur "Custom domains"
3. Ajoutez votre domaine
4. Mettez à jour le `wrangler.toml` avec votre domaine

```toml
[env.production]
routes = [
  { pattern = "/*", zone_name = "votre-domaine.com" }
]
```

## Support

Pour plus d'aide :
- [Documentation Cloudflare Pages](https://developers.cloudflare.com/pages/)
- [Documentation Wrangler](https://developers.cloudflare.com/workers/wrangler/)
- [Discord PearAI](https://discord.gg/7QMraJUsQt)
