#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p packages
b=$(mktemp -d)
trap 'rm -rf "$b"' EXIT
u=$b/ui/usr/lib/TweakInject
j=$b/jetsam/usr/libexec
mkdir -p "$u" "$j" "$b/ui/DEBIAN" "$b/jetsam/DEBIAN"
cp src/J71bCameraFix.plist "$u/"
cp src/cameraui.control "$b/ui/DEBIAN/control"
cp src/jetsam.control "$b/jetsam/DEBIAN/control"
for s in preinst postinst prerm; do install -m755 "src/$s" "$b/jetsam/DEBIAN/$s"; done
xcrun -sdk iphoneos clang -target arm64-apple-ios18.0 -dynamiclib -fobjc-arc -framework Foundation -framework AVFoundation src/CameraFix.m -o "$u/J71bCameraFix.dylib"
xcrun -sdk iphoneos clang -target arm64-apple-ios18.0 -fobjc-arc -framework Foundation src/Policy.m -o "$j/j71b-camera-policy"
ldid -S "$u/J71bCameraFix.dylib"
ldid -S "$j/j71b-camera-policy"
python3 pack.py "$b"
