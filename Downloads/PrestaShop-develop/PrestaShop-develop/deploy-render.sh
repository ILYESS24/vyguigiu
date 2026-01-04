#!/bin/bash

# Script de déploiement PrestaShop sur Render (512MB)
# Utilisation : ./deploy-render.sh

echo "🚀 Déploiement PrestaShop sur Render (512MB RAM)"
echo "================================================"

# Vérifier si Render CLI est installé
if ! command -v render &> /dev/null; then
    echo "❌ Render CLI n'est pas installé."
    echo "📦 Installez-le avec : npm install -g render-cli"
    echo "   Ou allez sur https://dashboard.render.com pour déployer manuellement"
    exit 1
fi

# Vérifier si l'utilisateur est connecté à Render
if ! render whoami &> /dev/null; then
    echo "🔐 Connexion à Render..."
    render login
fi

echo "📦 Déploiement avec render.yaml..."

# Déployer les services
render deploy --file render.yaml

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Déploiement réussi !"
    echo ""
    echo "🌐 Votre boutique sera disponible sous peu sur l'URL fournie par Render"
    echo ""
    echo "📋 Prochaines étapes :"
    echo "1. Attendre que le déploiement soit terminé (5-10 minutes)"
    echo "2. Accéder à votre URL Render"
    echo "3. Compléter l'installation PrestaShop"
    echo "4. Configurer Cloudflare si souhaité"
    echo ""
    echo "⚠️  Rappel : Configuration optimisée pour 512MB RAM"
    echo "   - PHP: 128MB max"
    echo "   - MySQL: 64MB buffer pool"
    echo "   - Cache OPcache activé"
    echo ""
    echo "📖 Documentation : RENDER_DEPLOYMENT.md"
else
    echo "❌ Échec du déploiement"
    echo "Vérifiez les logs Render pour plus de détails"
fi
