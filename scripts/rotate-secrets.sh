#!/usr/bin/env bash
# =============================================================================
# 🔄 Rotate Secrets — Cubículo Digital
# =============================================================================
# Propósito: Regenerar todos los secrets del proyecto y actualizar
# GitHub Secrets + .env local de forma segura.
#
# Uso:
#   chmod +x scripts/rotate-secrets.sh
#   ./scripts/rotate-secrets.sh
#
# ⚠️  REQUISITOS:
#   - gh CLI autenticado (gh auth status)
#   - openssl instalado
#   - Acceso a las consolas de Supabase, Groq, Upstash, Vercel
#     para regenerar credentials manualmente antes de ejecutar este script.
#
# FLUJO:
#   1. Regenera JWT_SECRET local (no requiere consola externa)
#   2. Te pide los nuevos valores de servicios externos
#   3. Actualiza .env local
#   4. Actualiza GitHub Secrets
# =============================================================================

set -euo pipefail

echo "============================================"
echo "  🔄 Rotación de Secrets - Cubículo Digital"
echo "============================================"
echo ""

# ─── 1. JWT_SECRET (se genera localmente) ──────────────────────────────────
echo "📌 [1/4] Generando nuevo JWT_SECRET..."
NEW_JWT_SECRET=$(openssl rand -base64 32)
echo "  ✅ Nuevo JWT_SECRET generado: ${NEW_JWT_SECRET:0:16}... (truncado)"

# ─── 2. Solicitar nuevos valores de servicios externos ─────────────────────
echo ""
echo "📌 [2/4] Secrets de servicios externos"
echo "  (Ve a cada consola, rota la clave, y pégala aquí)"
echo ""

read -rp "  GROQ_API_KEY (nueva): " GROQ_API_KEY
read -rp "  DATABASE_URL (nueva): " DATABASE_URL
read -rp "  DIRECT_URL (nueva): " DIRECT_URL
read -rp "  REDIS_URL (nueva): " REDIS_URL
echo ""

# ─── 3. Actualizar .env local ──────────────────────────────────────────────
echo "📌 [3/4] Actualizando .env local..."

# Backup del .env actual
cp .env ".env.backup.$(date +%Y%m%d%H%M%S)"
echo "  ✅ Backup creado: .env.backup.$(date +%Y%m%d%H%M%S)"

# Actualizar JWT_SECRET
if grep -q "^JWT_SECRET=" .env; then
  sed -i "s|^JWT_SECRET=.*|JWT_SECRET=${NEW_JWT_SECRET}|" .env
else
  echo "JWT_SECRET=${NEW_JWT_SECRET}" >> .env
fi

# Actualizar GROQ_API_KEY
if grep -q "^GROQ_API_KEY=" .env; then
  sed -i "s|^GROQ_API_KEY=.*|GROQ_API_KEY=${GROQ_API_KEY}|" .env
fi

# Actualizar DATABASE_URL
if grep -q "^DATABASE_URL=" .env; then
  sed -i "s|^DATABASE_URL=.*|DATABASE_URL=${DATABASE_URL}|" .env
fi

# Actualizar DIRECT_URL
if grep -q "^DIRECT_URL=" .env; then
  sed -i "s|^DIRECT_URL=.*|DIRECT_URL=${DIRECT_URL}|" .env
fi

# Actualizar REDIS_URL
if grep -q "^REDIS_URL=" .env; then
  sed -i "s|^REDIS_URL=.*|REDIS_URL=${REDIS_URL}|" .env
fi

echo "  ✅ .env actualizado"

# ─── 4. Actualizar GitHub Secrets ──────────────────────────────────────────
echo ""
echo "📌 [4/4] Actualizando GitHub Secrets..."

gh secret set JWT_SECRET --body "${NEW_JWT_SECRET}"
echo "  ✅ JWT_SECRET → GitHub Secrets"

gh secret set GROQ_API_KEY --body "${GROQ_API_KEY}"
echo "  ✅ GROQ_API_KEY → GitHub Secrets"

gh secret set DATABASE_URL --body "${DATABASE_URL}"
echo "  ✅ DATABASE_URL → GitHub Secrets"

gh secret set DIRECT_URL --body "${DIRECT_URL}"
echo "  ✅ DIRECT_URL → GitHub Secrets"

gh secret set REDIS_URL --body "${REDIS_URL}"
echo "  ✅ REDIS_URL → GitHub Secrets"

# Staging usa los mismos valores que dev por ahora
gh secret set STAGING_DATABASE_URL --body "${DATABASE_URL}"
echo "  ✅ STAGING_DATABASE_URL → GitHub Secrets"

gh secret set STAGING_DIRECT_URL --body "${DIRECT_URL}"
echo "  ✅ STAGING_DIRECT_URL → GitHub Secrets"

echo ""
echo "============================================"
echo "  ✅ Rotación completada exitosamente"
echo "============================================"
echo ""
echo "⚠️  No olvides:"
echo "   - Actualizar PROD_DATABASE_URL y PROD_DIRECT_URL manualmente si cambian"
echo "   - Actualizar VERCEL_TOKEN, VERCEL_ORG_ID, VERCEL_* si es necesario"
echo "   - Verificar que los workflows CI/CD pasen correctamente"
echo "   - Eliminar el backup .env.backup.* después de confirmar que todo funciona"
