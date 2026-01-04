#!/bin/bash

# Script de déploiement PrestaShop sur Railway
# Utilisation : ./deploy.sh

echo "🚀 Déploiement PrestaShop sur Railway + Cloudflare"
echo "=================================================="

# Vérifier si Railway CLI est installé
if ! command -v railway &> /dev/null; then
    echo "❌ Railway CLI n'est pas installé."
    echo "📦 Installez-le avec : npm install -g @railway/cli"
    exit 1
fi

# Vérifier si l'utilisateur est connecté à Railway
if ! railway status &> /dev/null; then
    echo "🔐 Connexion à Railway..."
    railway login
fi

# Créer un nouveau projet ou utiliser un existant
echo "📁 Création/configuration du projet Railway..."
if [ -z "$RAILWAY_PROJECT_ID" ]; then
    echo "🔄 Création d'un nouveau projet..."
    railway init prestashop-project
else
    echo "✅ Utilisation du projet existant..."
    railway link $RAILWAY_PROJECT_ID
fi

# Ajouter la base de données MySQL
echo "🗄️  Configuration de la base de données..."
railway add mysql

# Déployer l'application
echo "🚀 Déploiement de l'application..."
railway deploy

# Attendre que le déploiement soit terminé
echo "⏳ Attente du déploiement..."
sleep 30

# Récupérer l'URL de l'application
APP_URL=$(railway domain)
echo "🌐 Application déployée sur : $APP_URL"

# Instructions finales
echo ""
echo "✅ Déploiement terminé !"
echo ""
echo "📋 Prochaines étapes :"
echo "1. Configurer Cloudflare pour pointer vers : $APP_URL"
echo "2. Accéder à l'installateur : $APP_URL/install"
echo "3. Suivre le guide complet dans RAILWAY_DEPLOYMENT.md"
echo ""
echo "📖 Documentation complète : RAILWAY_DEPLOYMENT.md"
