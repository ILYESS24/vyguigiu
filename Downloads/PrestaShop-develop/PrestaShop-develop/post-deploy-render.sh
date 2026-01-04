#!/bin/bash

# Script de post-déploiement pour Render (512MB)
# À exécuter après le déploiement

echo "🔧 Post-déploiement PrestaShop sur Render"
echo "========================================"

# Récupérer l'URL du service Render
SERVICE_URL=$(render services list | grep prestashop | awk '{print $4}' || echo "https://votre-service.onrender.com")

echo "🌐 URL du service : $SERVICE_URL"

# Attendre que le service soit prêt
echo "⏳ Attente que les services soient prêts..."
sleep 120

# Tester la connectivité
echo "🔍 Test de connectivité..."
if curl -f -s --max-time 30 "$SERVICE_URL" > /dev/null; then
    echo "✅ Application accessible"
else
    echo "⚠️  Application en cours de démarrage (peut prendre 5-10 minutes)"
fi

# Vérifier l'installateur
if curl -f -s --max-time 30 "$SERVICE_URL/install" > /dev/null; then
    echo "✅ Installateur accessible"
    echo ""
    echo "🎯 Prochaines étapes :"
    echo "1. Accéder à : $SERVICE_URL/install"
    echo "2. Compléter l'installation PrestaShop"
    echo "3. Désactiver les modules gourmands en RAM"
    echo "4. Optimiser les images produits"
else
    echo "⏳ Installateur pas encore prêt"
fi

echo ""
echo "📊 Configuration RAM 512MB :"
echo "   ✅ PHP: 128MB max"
echo "   ✅ MySQL: 64MB buffer pool"
echo "   ✅ OPcache: Activé"
echo "   ✅ Apache: Optimisé"
echo ""
echo "⚠️  Limitations :"
echo "   - Max 100 produits recommandés"
echo "   - Images < 100KB"
echo "   - Modules légers uniquement"
echo ""
echo "📖 Documentation complète : RENDER_DEPLOYMENT.md"
echo ""
echo "🔐 Identifiants par défaut :"
echo "   Email : demo@prestashop.com"
echo "   Mot de passe : Correct Horse Battery Staple"
