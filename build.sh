
#!/usr/bin/env bash
set -euo pipefail

FLUTTER_VERSION="3.50.1"
ARCHIVE="flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/${ARCHIVE}"

echo "=== Download Flutter SDK ==="
curl -fL --retry 3 "$URL" -o "/tmp/${ARCHIVE}"

echo "=== Verify Flutter SDK ==="
echo "4ad17fc8462fbcef2ba19ff4a78c0a16b7147fde1add8578e267ea62cdb92678  /tmp/${ARCHIVE}" | sha256sum --check

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
