#!/bin/bash
set -e
cd "$(dirname "$0")"

DOWNLOAD="$HOME/Downloads/aves_album.json"
TARGET="aves_album.json"

if [ ! -f "$DOWNLOAD" ]; then
  echo "No encontré $DOWNLOAD."
  echo "Exporta primero desde la guía: botón 'Exportar cambios'."
  exit 1
fi

# Validar que el archivo descargado sea JSON válido antes de tocar nada
if ! python3 -m json.tool "$DOWNLOAD" > /dev/null 2>&1; then
  echo "El archivo descargado no es JSON válido. No se movió ni se cambió nada."
  exit 1
fi

# Respaldo del archivo actual antes de reemplazarlo
cp "$TARGET" "$TARGET.bak"

mv "$DOWNLOAD" "$TARGET"

git add "$TARGET"

if git diff --cached --quiet; then
  echo "No hay cambios que publicar."
  exit 0
fi

git commit -m "Actualiza guía: $(date '+%Y-%m-%d %H:%M')"
git push

echo ""
echo "Publicado. GitHub Pages debería reflejarlo en 1-2 minutos:"
echo "https://ricaudvm.github.io/guia-aves/"
