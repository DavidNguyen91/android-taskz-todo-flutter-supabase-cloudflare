
#!/usr/bin/env bash
set -euo pipefail

FLUTTER_VERSION="3.47.9"
ARCHIVE="flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/${ARCHIVE}"

echo "=== Download Flutter SDK ==="
curl -fL --retry 3 "$URL" -o "/tmp/${ARCHIVE}"

echo "=== Verify Flutter SDK ==="
echo "25ed8c3c29d51a7353f2a944310b478af8214920639524b19c50a19e6c044c5a  /tmp/${ARCHIVE}" | sha256sum --check

echo "=== Extract Flutter SDK ==="
tar -xf "/tmp/${ARCHIVE}" -C /tmp

export PATH="/tmp/flutter/bin:$PATH"

echo "=== Flutter version ==="
flutter --version

echo "=== Install dependencies ==="
flutter pub get

echo "=== Build Flutter Web ==="
flutter build web --release

echo "=== Build completed ==="
