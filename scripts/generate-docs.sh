#!/usr/bin/env bash
set -euo pipefail

cat > docs/module-summary.md <<'EOF'
# Module Summary

This file is generated as a simple index of Terraform modules.

EOF

for module in terraform/modules/*; do
  if [ -d "$module" ]; then
    echo "## $(basename "$module")" >> docs/module-summary.md
    echo "" >> docs/module-summary.md
    find "$module" -maxdepth 1 -type f -name '*.tf' -printf '- `%f`\n' >> docs/module-summary.md
    echo "" >> docs/module-summary.md
  fi
done
