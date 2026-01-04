# 🚀 Déploiement Rapide PearAI sur Cloudflare Pages

## En 3 étapes simples :

### 1. Préparer votre compte Cloudflare
```bash
# 1. Créez un compte sur https://cloudflare.com
# 2. Activez Cloudflare Pages dans votre dashboard
# 3. Notez votre Account ID (visible dans l'URL ou les paramètres)
```

### 2. Configurer les secrets GitHub
Allez dans votre dépôt GitHub > Settings > Secrets and variables > Actions :

- `CLOUDFLARE_API_TOKEN` : Créez un token API avec permissions Pages
- `CLOUDFLARE_ACCOUNT_ID` : Votre Account ID Cloudflare

### 3. Déployer automatiquement
```bash
# Poussez ces fichiers sur GitHub :
git add .
git commit -m "Add Cloudflare Pages deployment"
git push origin main

# Le déploiement se fait automatiquement !
```

## 📁 Fichiers créés :

- ✅ `wrangler.toml` - Configuration Cloudflare
- ✅ `.github/workflows/deploy.yml` - Déploiement automatique
- ✅ `CLOUDFLARE_DEPLOYMENT.md` - Guide complet
- ✅ Scripts npm ajoutés dans `package.json`

## 🧪 Tester localement :

```bash
npm install
npm run deploy-web
# Les fichiers sont dans vscode-web/
```

## 🌐 Résultat :

Après déploiement, vous aurez :
- URL Cloudflare Pages : `https://votre-projet.pages.dev`
- PearAI fonctionnel dans le navigateur
- Déploiement automatique à chaque push

## 🆘 Problèmes ?

Consultez `CLOUDFLARE_DEPLOYMENT.md` pour le guide complet ou rejoignez le [Discord PearAI](https://discord.gg/7QMraJUsQt).

---

**Prêt à déployer ? Poussez les fichiers sur GitHub !** 🎉
