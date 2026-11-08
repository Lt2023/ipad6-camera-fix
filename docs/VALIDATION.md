# Compatibility and validation

| Release | Evidence |
| --- | --- |
| Jetsam 1.1 and CameraUI 0.1 | Hardware testing on iPad7,5, iPadOS 18.7.2 (22H124), rootful, ElleKit 1.2. The camera service adopted its dedicated limits and camera functionality was reported restored. |
| Jetsam 1.2 and CameraUI 0.2 | Built for arm64 with an iPadOS 18.0 deployment target. Packaging targets iPad7,5 and firmware >=18.0 and <19.0. No hardware installation or cross-version camera tests of these releases are claimed. |

For each additional build, record the OS build, bootstrap, effective service limits, front/rear preview and photo results, video saving and playback, third-party capture, and uninstall restoration. Do not infer runtime support from successful installation alone.
