#!/bin/bash

# Script de post-déploiement pour PrestaShop
# À exécuter après le déploiement sur Railway

echo "🔧 Post-déploiement PrestaShop"
echo "================================"

# Attendre que l'application soit prête
echo "⏳ Attente que l'application soit prête..."
sleep 60

# Tester la connectivité
APP_URL=$(railway domain 2>/dev/null || echo "localhost:8001")
echo "🌐 URL de l'application : $APP_URL"

# Vérifier que l'application répond
if curl -f -s "$APP_URL" > /dev/null; then
    echo "✅ Application accessible"
else
    echo "❌ Application non accessible"
    exit 1
fi

# Copier la configuration de production
echo "📋 Configuration de production..."
if [ -f "config/defines_prod.inc.php" ]; then
    cp config/defines_prod.inc.php config/defines.inc.php
    echo "✅ Configuration de production appliquée"
fi

# Copier le .htaccess de production
if [ -f ".htaccess.production" ]; then
    cp .htaccess.production .htaccess
    echo "✅ Configuration Apache appliquée"
fi

# Générer des clés de sécurité aléatoires
echo "🔐 Génération des clés de sécurité..."
COOKIE_KEY=$(openssl rand -hex 32)
COOKIE_IV=$(openssl rand -hex 8)

# Mettre à jour les variables d'environnement
railway variables set COOKIE_KEY="$COOKIE_KEY"
railway variables set COOKIE_IV="$COOKIE_IV"

echo "✅ Clés de sécurité générées et configurées"

# Vider les caches
echo "🗑️  Nettoyage des caches..."
if [ -d "var/cache" ]; then
    rm -rf var/cache/*
    echo "✅ Cache vidé"
fi

# Créer les dossiers nécessaires avec les bonnes permissions
echo "📁 Configuration des permissions..."
chmod -R 755 .
chmod -R 777 img/ upload/ download/ var/cache var/logs var/sessions

echo "✅ Permissions configurées"

# Redémarrer l'application
echo "🔄 Redémarrage de l'application..."
railway restart

echo ""
echo "🎉 Post-déploiement terminé !"
echo ""
echo "📋 Prochaines étapes :"
echo "1. Accéder à : $APP_URL/install"
echo "2. Compléter l'installation PrestaShop"
echo "3. Configurer Cloudflare (voir RAILWAY_DEPLOYMENT.md)"
echo ""
echo "🔐 Identifiants par défaut :"
echo "   Email : admin@votre-domaine.com"
echo "   Mot de passe : votre_mot_de_passe_sécurisé"
echo ""
echo "📖 Documentation : RAILWAY_DEPLOYMENT.md"
