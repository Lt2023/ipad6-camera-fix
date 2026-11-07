# iPad 6 Camera Fix

适用于通过 upRa1n / ipad6-ipados18 移植运行 iPadOS 18 的 **iPad7,5（J71b），18.7.2，22H124，rootful / iphoneos-arm，ElleKit**。不适用于原生支持 iPadOS 18 的普通设备；未验证蜂窝版、其他系统版本或 rootless。

## 两个组件

| 包 | 版本 | 用途 |
|---|---|---|
| local.j71b.camera-jetsam | 1.1 | 补齐相机服务专项 Jetsam 策略，防止服务落入通用低内存限额 |
| local.j71b.cameraui-test | 0.1 | 仅在系统相机内，对三个能力 getter 增加广角设备存在且有格式时的回退 |

CameraUI 插件的函数为 CAMCaptureCapabilities 的 isBackCameraSupported、isFrontCameraSupported、isVideoSupported。原函数返回 YES 时保留原结果；它不验证每种录像格式，也不保证其他版本兼容。

## 安装

1. 确认设备符合上述型号、系统、引导与越狱环境，并准备原有电脑有线引导流程。
2. 用 Sileo 安装 packages/camera-1.1.deb，确认成功。
3. 用 Sileo 安装 packages/CameraUI-test.deb。
4. Jetsam 策略需要 launchd 重新载入：在有线引导流程已准备好的条件下受控重启，并重新引导回移植系统。仅 Respring 不保证生效。
5. 如果只新增 CameraUI 插件、Jetsam 已生效，划掉相机后台再打开即可测试。
6. 不要反复安装 1.0；1.0 缺少归档目录条目，已被 1.1 替代。

依赖、原策略哈希不符时应停止，不要强行安装或绕过依赖。

## 验证

SSH 执行：
```sh
sudo launchctl print user/501/com.apple.cameracaptured
```
目标：priority 140，active soft 1550 MB，inactive hard 27 MB，thread limit 512。
1550 是配置限额，不是立即分配的内存。

随后分别验证系统相机前后切换、拍照保存、录像保存及回放、QQ 双摄连续预览、扫码器后置。用户已反馈功能恢复；这不是跨设备测试或全部分辨率/音轨的完整认证。详见 docs/VALIDATION.md。

## 卸载

先在 Sileo 移除 J71b CameraUI Test，然后退出重开相机，运行时 hook 随进程退出消失。
如需撤销 Jetsam 修复，再移除 local.j71b.camera-jetsam；prerm 仅在策略哈希匹配已知补丁时恢复原件。
遇到哈希不符会退出，不覆盖其他改动。恢复内存策略后同样需要准备有线引导再受控重启。
CameraUI 不替换系统 framework，不注入 QQ 或扫码器。

## 构建与开源

源码位于 src/，build.sh / tools.py 用于生成两个 deb。需要 macOS、Xcode iPhoneOS SDK、Python 3、ldid 和支持 --root-owner-group 的 dpkg-deb。
提供匹配当前已验证哈希的、由使用者自行合法取得的原始 J71b 与同版本 J171 Jetsam 策略：

```sh
ORIGINAL_POLICY=/absolute/path/com.apple.jetsamproperties.J71b.plist \
REFERENCE_POLICY=/absolute/path/com.apple.jetsamproperties.J171.plist ./build.sh
```

**公开 Git 仓库时提交源码、脚本和文档，不提交 packages/*.deb。**
现成 Jetsam deb 内含 Apple 策略文件，供当前设备验证交付；本项目没有为 Apple 内容授予再分发许可。
.gitignore 默认排除二进制包，避免把 Apple 原始策略和个人日志推到仓库。
不含设备序列号、密码、SSH 工具或个人采集日志。

本目录尚未创建远程仓库，也未公开上传。新编写源码采用 MIT，见 LICENSE。
