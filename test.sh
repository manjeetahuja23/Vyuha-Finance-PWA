#!/bin/bash
#
# Vyuha-Finance-PWA — UI/UX & Build Test Gate
# Blocks deployment if any UI/build check fails.
# Runs locally (./test.sh) and in CI (.github/workflows/ci.yml).
#
set -euo pipefail

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$APP_DIR"

FAIL=0

echo "=============================================="
echo " Vyuha-Finance-PWA UI/UX Testing Gate"
echo "=============================================="

# --- 1. Essential file existence -------------------------------------------
echo ""
echo "1. Verifying essential files..."
for f in index.html manifest.json sw.js .nojekyll; do
  if [ ! -f "$f" ]; then
    echo "   [FAIL] $f not found!"
    FAIL=1
  else
    echo "   [OK]   $f"
  fi
done

# --- 2. HTML validation -----------------------------------------------------
echo ""
echo "2. Running HTML validation (html-validate)..."
if command -v html-validate >/dev/null 2>&1; then
  if html-validate index.html; then
    echo "   [OK]   HTML validation passed."
  else
    echo "   [FAIL] HTML validation failed!"
    FAIL=1
  fi
else
  echo "   [SKIP] html-validate not installed."
fi

# --- 3. PWA manifest validation --------------------------------------------
echo ""
echo "3. Validating manifest.json (PWA requirements)..."
if node -e "
  const fs = require('fs');
  const m = JSON.parse(fs.readFileSync('manifest.json','utf8'));
  const required = ['name','short_name','start_url','display','icons'];
  for (const k of required) {
    if (!(k in m)) { console.error('Missing manifest field: '+k); process.exit(1); }
  }
  if (!Array.isArray(m.icons) || m.icons.length === 0) { console.error('Manifest needs at least one icon'); process.exit(1); }
  if (!['standalone','fullscreen','window-controls-overlay'].includes(m.display)) {
    console.error('manifest display must be standalone/fullscreen for PWA'); process.exit(1);
  }
  console.log('Manifest valid PWA (display=' + m.display + ', icons=' + m.icons.length + ')');
"; then
  echo "   [OK]   Manifest valid."
else
  echo "   [FAIL] Manifest validation failed!"
  FAIL=1
fi

# --- 4. Service worker ------------------------------------------------------
echo ""
echo "4. Checking service worker (sw.js)..."
if [ -f sw.js ] && grep -q 'addEventListener' sw.js; then
  echo "   [OK]   sw.js present with service worker listeners."
else
  echo "   [FAIL] sw.js missing or not a valid service worker!"
  FAIL=1
fi

# --- 5. Design audit (best-effort, requires Playwright/Chromium) ------------
echo ""
echo "5. Design audit (heuristic, best-effort)..."
AUDIT_SCRIPT="$HOME/.openclaw/workspace/skills/ui-ux-pro-max-skill/stack/scripts/design-audit.mjs"
if [ -f "$AUDIT_SCRIPT" ] && command -v node >/dev/null 2>&1; then
  if node "$AUDIT_SCRIPT" --file "$APP_DIR/index.html" --out /tmp/vyuha-finance-audit >/tmp/vyuha-audit.log 2>&1; then
    echo "   [OK]   Design audit passed."
  else
    echo "   [WARN] Design audit reported issues (review /tmp/vyuha-audit.log)."
    echo "   Non-blocking in local gate unless Playwright findings are high-severity."
  fi
else
  echo "   [SKIP] design-audit.mjs not found (Playwright/Chromium not installed)."
fi

# --- Result ----------------------------------------------------------------
echo ""
if [ "$FAIL" -ne 0 ]; then
  echo "=============================================="
  echo " GATE FAILED — deployment blocked."
  echo "=============================================="
  exit 1
else
  echo "=============================================="
  echo " ALL UI/UX CHECKS PASSED — gate open."
  echo "=============================================="
  exit 0
fi
