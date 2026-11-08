# iPad 6 Camera Fix

**English** | [简体中文](README.zh-CN.md)

Camera fixes for **iPad (6th generation, Wi-Fi), iPad7,5 / J71b**, running a port of iPadOS 18 with a rootful bootstrap and ElleKit. Cellular models, rootless installations and other major OS versions are outside the target.

## Packages

1. Install **camera-jetsam-1.2.deb** in Sileo. The installer reads the J171 policy already on the device and fills missing cameracaptured entries in the J71b policy. Existing entries are preserved. A missing donor entry leaves the policy unchanged. No Apple policy file is bundled.
2. Install **CameraUI-0.2.deb**. In Apple's Camera app only, the tweak checks the available wide-angle capture device when the original camera capability getter returns false. Unknown methods are skipped.
3. If the memory policy changed, prepare the tethered boot setup before restarting into the port. A respring alone may leave the old launchd policy active. Quit and reopen Camera to load the tweak.

The package dependencies allow 18.x on iPad7,5; installation eligibility is not a guarantee that every private CameraUI implementation is compatible. See [validation](docs/VALIDATION.md).

## Verify and remove

Inspect the live service with `sudo launchctl print user/501/com.apple.cameracaptured`. Compare its limits with the donor policy for the installed build. Test rear/front switching, saved photos, video recording and playback, and third-party previews.

Remove CameraUI first and relaunch Camera. Remove the Jetsam package to restore the saved bytes. Removal stops if the current policy differs from both the saved original and the package's patched copy. Reapply the tethered boot procedure when reloading the restored policy.

## Build

On macOS with Xcode, an iPhoneOS SDK, Python 3, ar and ldid on PATH, run `./build.sh`. Both packages are written to `packages/`. Source code is licensed under MIT.
