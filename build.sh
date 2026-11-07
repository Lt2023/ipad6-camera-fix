#!/bin/sh
set -eu
cd "$(dirname "$0")"
: "${ORIGINAL_POLICY:?Path to original J71b policy required}"
: "${REFERENCE_POLICY:?Path to same-build J171 policy required}"
command -v dpkg-deb >/dev/null
command -v ldid >/dev/null
rm -rf .build
mkdir -p .build/ui/DEBIAN .build/ui/usr/lib/TweakInject .build/jetsam/DEBIAN .build/jetsam/usr/share/local-j71b-camera packages
cp src/cameraui.control .build/ui/DEBIAN/control
cp src/jetsam.control .build/jetsam/DEBIAN/control
cp src/J71bCameraFix.plist .build/ui/usr/lib/TweakInject/
xcrun -sdk iphoneos clang -target arm64-apple-ios18.0 -dynamiclib -fobjc-arc -framework Foundation -framework AVFoundation src/CameraFix.m -o .build/ui/usr/lib/TweakInject/J71bCameraFix.dylib
ldid -S .build/ui/usr/lib/TweakInject/J71bCameraFix.dylib
python3 tools.py
dpkg-deb --root-owner-group -Zgzip -b .build/jetsam packages/camera-1.1.deb
dpkg-deb --root-owner-group -Zgzip -b .build/ui packages/CameraUI-test.deb
