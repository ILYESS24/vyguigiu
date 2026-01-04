const fs = require('fs');
const path = require('path');
const marked = require('marked');
const hljs = require('highlight.js');

// Configuration
const DIST_DIR = path.join(__dirname, '..', 'dist');
const README_PATH = path.join(__dirname, '..', 'README.md');

// Create dist directory
if (!fs.existsSync(DIST_DIR)) {
  fs.mkdirSync(DIST_DIR, { recursive: true });
}

// Configure marked with syntax highlighting
marked.setOptions({
  highlight: function(code, lang) {
    if (lang && hljs.getLanguage(lang)) {
      return hljs.highlight(code, { language: lang }).value;
    }
    return hljs.highlightAuto(code).value;
  },
  breaks: true,
  gfm: true
});

// Read and convert README
const readmeContent = fs.readFileSync(README_PATH, 'utf8');
const htmlContent = marked.parse(readmeContent);

// Create basic HTML template
const htmlTemplate = `<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aurion IDE - Éditeur de Code Ultra-Rapide</title>
    <meta name="description" content="Aurion IDE - Éditeur de code ultra-rapide écrit en Rust avec une interface moderne">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.2.0/github-markdown.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github.min.css">
    <style>
        body {
            background-color: #0d1117;
            color: #c9d1d9;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif;
        }
        .markdown-body {
            max-width: 1200px;
            margin: 0 auto;
            padding: 45px;
            background-color: #0d1117;
            color: #c9d1d9;
        }
        .markdown-body h1 {
            color: #58a6ff;
            border-bottom: 1px solid #30363d;
        }
        .markdown-body h2, .markdown-body h3, .markdown-body h4 {
            color: #f78166;
        }
        .markdown-body a {
            color: #58a6ff;
        }
        .markdown-body code {
            background-color: #161b22;
            border: 1px solid #30363d;
            color: #c9d1d9;
        }
        .markdown-body pre {
            background-color: #161b22;
            border: 1px solid #30363d;
        }
        .hero {
            text-align: center;
            padding: 60px 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            margin-bottom: 40px;
        }
        .hero h1 {
            font-size: 3em;
            margin-bottom: 20px;
        }
        .hero p {
            font-size: 1.2em;
            opacity: 0.9;
        }
    </style>
</head>
<body>
    <div class="hero">
        <h1>🚀 Aurion IDE</h1>
        <p>Éditeur de Code Ultra-Rapide et Puissant</p>
    </div>
    <div class="markdown-body">
        ${htmlContent}
    </div>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>
    <script>hljs.highlightAll();</script>
</body>
</html>`;

// Write the HTML file
fs.writeFileSync(path.join(DIST_DIR, 'index.html'), htmlTemplate);

// Copy screenshot if it exists
const screenshotSrc = path.join(__dirname, '..', 'extra', 'images', 'screenshot.png');
const screenshotDest = path.join(DIST_DIR, 'screenshot.png');
if (fs.existsSync(screenshotSrc)) {
  fs.copyFileSync(screenshotSrc, screenshotDest);
}

console.log('✅ Site web généré avec succès dans le dossier dist/');
