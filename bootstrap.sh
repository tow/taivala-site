# in an empty folder that already contains index.html
git init
printf "/node_modules\n.DS_Store\n" > .gitignore
echo > .nojekyll   # disables Jekyll processing (safe default for plain HTML)
mkdir -p .github/workflows

# GitHub Pages workflow
cat > .github/workflows/pages.yml <<'YAML'
name: Deploy static site to Pages

on:
  push:
    branches: ["main"]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: true

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/upload-pages-artifact@v3
        with:
          path: '.'
  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - id: deployment
        uses: actions/deploy-pages@v4
YAML

# Optional: lightweight README for investors/execs poking around
cat > README.md <<'MD'
# Taivala website
Static landing page. Built as a single `index.html` with inline styles.
- Architecture & security snapshot
- Behavior-change examples
- No tracking, no JS frameworks
MD
