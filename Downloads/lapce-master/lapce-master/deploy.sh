#!/bin/bash

# 🚀 Script de déploiement rapide Aurion IDE
# Utilisation: ./deploy.sh

set -e

echo "🚀 Déploiement Aurion IDE sur Cloudflare Pages"
echo "==============================================="

# Vérifications préalables
echo "📋 Vérifications préalables..."

if ! command -v node &> /dev/null; then
    echo "❌ Node.js n'est pas installé. Installez Node.js 18+ d'abord."
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo "❌ npm n'est pas installé."
    exit 1
fi

if ! command -v git &> /dev/null; then
    echo "❌ git n'est pas installé."
    exit 1
fi

# Vérifier que nous sommes dans le bon répertoire
if [ ! -f "package.json" ] || [ ! -f "Cargo.toml" ]; then
    echo "❌ Vous n'êtes pas dans le répertoire du projet Aurion IDE."
    echo "   Naviguez vers le dossier racine du projet."
    exit 1
fi

echo "✅ Environnement OK"

# Installer les dépendances
echo "📦 Installation des dépendances..."
npm install

# Construire le site
echo "🔨 Construction du site web..."
npm run build

# Vérifier que la build a réussi
if [ ! -d "dist" ]; then
    echo "❌ Échec de la construction. Vérifiez les erreurs ci-dessus."
    exit 1
fi

echo "✅ Site web construit avec succès"

# Déploiement avec Wrangler (si configuré)
if command -v wrangler &> /dev/null; then
    echo "☁️  Déploiement avec Wrangler..."
    echo "   Si vous voulez déployer maintenant, exécutez:"
    echo "   wrangler pages deploy dist"
    echo ""
    echo "   Ou poussez sur GitHub pour un déploiement automatique."
else
    echo "ℹ️  Wrangler CLI n'est pas installé."
    echo "   Pour installer: npm install -g wrangler"
    echo ""
fi

echo ""
echo "🎉 Prêt pour le déploiement !"
echo ""
echo "Prochaines étapes :"
echo "1. Créez le repository GitHub: https://github.com/new"
echo "   Nom: aurion-ide/aurion-ide"
echo "2. Poussez ce code:"
echo "   git init"
echo "   git add ."
echo "   git commit -m 'Initial commit: Aurion IDE'"
echo "   git remote add origin https://github.com/aurion-ide/aurion-ide.git"
echo "   git push -u origin main"
echo "3. Configurez Cloudflare Pages (voir DEPLOYMENT_READY.md)"
echo ""
echo "🚀 Votre site sera automatiquement déployé à chaque push !"
