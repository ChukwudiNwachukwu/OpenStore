#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
if [[ ! -d OpenStore.xcodeproj ]]; then
  xcodegen generate
fi
xcodebuild build \
  -project OpenStore.xcodeproj \
  -scheme OpenStore \
  -configuration Release \
  -sdk iphoneos \
  -destination 'generic/platform=iOS' \
  -derivedDataPath build/device \
  CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY=""
mkdir -p build/package/Payload
rm -rf build/package/Payload/OpenStore.app
cp -R build/device/Build/Products/Release-iphoneos/OpenStore.app build/package/Payload/
rm -f build/OpenStore-unsigned.ipa
cd build/package
/usr/bin/zip -qry ../OpenStore-unsigned.ipa Payload
