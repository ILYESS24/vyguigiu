const fs = require('fs');
const path = require('path');

console.log('🔍 Vérification du déploiement Aurion IDE');
console.log('==========================================');

// Vérifier les fichiers essentiels
const checks = [
  { file: 'package.json', desc: 'Configuration npm' },
  { file: 'wrangler.toml', desc: 'Configuration Cloudflare' },
  { file: 'dist/index.html', desc: 'Site web construit' },
  { file: '.github/workflows/deploy.yml', desc: 'CI/CD GitHub Actions' },
  { file: 'DEPLOYMENT_READY.md', desc: 'Guide de déploiement' }
];

let allGood = true;

checks.forEach(({ file, desc }) => {
  if (fs.existsSync(file)) {
    console.log(`✅ ${desc}: ${file}`);
  } else {
    console.log(`❌ ${desc}: ${file} (MANQUANT)`);
    allGood = false;
  }
});

// Vérifier le contenu du site
if (fs.existsSync('dist/index.html')) {
  const content = fs.readFileSync('dist/index.html', 'utf8');
  if (content.includes('Aurion IDE')) {
    console.log('✅ Contenu: "Aurion IDE" trouvé dans le site');
  } else {
    console.log('❌ Contenu: "Aurion IDE" non trouvé dans le site');
    allGood = false;
  }
}

// Vérifier les références invalides dans les noms de crates
const cargoFiles = [
  'Cargo.toml',
  'lapce-app/Cargo.toml',
  'lapce-proxy/Cargo.toml',
  'lapce-core/Cargo.toml',
  'lapce-rpc/Cargo.toml'
];

cargoFiles.forEach(file => {
  if (fs.existsSync(file)) {
    const content = fs.readFileSync(file, 'utf8');
    // Vérifier les noms de crates avec espaces (invalides pour Rust)
    const invalidPatterns = [
      /\bname\s*=\s*"[^"]*Aurion IDE[^"]*"/g,  // noms de crates avec espaces
      /\bpath\s*=\s*"[^"]*Aurion IDE[^"]*"/g,  // chemins avec espaces
      /\bAurion IDE-/g,  // crates avec espaces suivis de tiret
      /\bAurion IDE\//g   // chemins avec espaces suivis de slash
    ];

    invalidPatterns.forEach(pattern => {
      if (pattern.test(content)) {
        console.log(`❌ Référence invalide trouvée dans ${file}`);
        allGood = false;
      }
    });
  }
});

console.log('');
if (allGood) {
  console.log('🎉 Tout est prêt pour le déploiement !');
  console.log('');
  console.log('Prochaines étapes :');
  console.log('1. Créez le repository GitHub: aurion-ide/aurion-ide');
  console.log('2. Poussez le code et configurez Cloudflare Pages');
  console.log('3. Consultez DEPLOYMENT_READY.md pour le guide complet');
  console.log('');
  console.log('🚀 Bonne chance avec Aurion IDE !');
} else {
  console.log('❌ Des problèmes ont été détectés. Corrigez-les avant le déploiement.');
  process.exit(1);
}
