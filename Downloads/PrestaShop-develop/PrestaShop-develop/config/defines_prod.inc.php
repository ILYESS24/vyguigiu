<?php
/**
 * Configuration de production pour PrestaShop
 * À utiliser avec Railway + Cloudflare
 */

// Configuration de performance
define('_PS_MODE_DEV_', false);
define('_PS_MODE_DEMO_', false);
define('_PS_DEBUG_PROFILING_', false);

// Cache activé
define('_PS_CACHING_SYSTEM_', 'CacheMemcache');
define('_PS_CACHE_ENABLED_', true);

// Smarty en mode production
define('_PS_SMARTY_CACHING_', true);
define('_PS_SMARTY_CACHE_LIFETIME_', 3600); // 1 heure

// Optimisations base de données
define('_PS_DEBUG_SQL_', false);
define('_PS_SQL_PROFILING_', false);

// Sécurité renforcée
define('_COOKIE_KEY_', getenv('COOKIE_KEY') ?: 'votre-cle-secrete-unique');
define('_COOKIE_IV_', getenv('COOKIE_IV') ?: 'votre-vecteur-initialisation');

// Compression activée
define('_PS_USE_COMPRESSION_', true);

// Logs minimisés
define('_PS_LOG_MAX_FILES_', 7);
define('_PS_LOG_ERASE_', true);

// CDN Cloudflare
define('_PS_CDN_HOST_', getenv('CDN_HOST') ?: '');

// Optimisations diverses
define('_PS_FORCE_SMARTY_2_', false);
define('_PS_FORCE_SMARTY_3_', true);

// Maintenance (désactiver après installation)
define('_PS_MAINTENANCE_IP_', getenv('MAINTENANCE_IP') ?: '');
