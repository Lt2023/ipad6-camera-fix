# iPad 6 Camera Fix

[English](README.md) | **简体中文**

适用于使用 rootful 越狱环境和 ElleKit、运行移植版 iPadOS 18 的 **iPad 第六代 Wi-Fi 版（iPad7,5 / J71b）**。蜂窝版、rootless 环境及其他系统大版本不是本项目的目标配置。

## 安装包

1. 在 Sileo 中安装 **camera-jetsam-1.2.deb**。安装程序读取设备本机的 J171 策略，补齐 J71b 策略中缺失的 cameracaptured 条目，保留已有条目。如果缺少参考条目，策略保持不变。安装包不包含 Apple 原始策略文件。
2. 安装 **CameraUI-0.2.deb**。插件仅作用于系统「相机」：当原始能力判断返回 false 时，检查可用的广角摄像头设备。遇到不存在的方法时跳过。
3. 如果内存策略发生变化，请先准备好有线引导环境，再重启并重新引导进入移植系统。仅 Respring 可能仍保留 launchd 的旧策略。退出并重新打开「相机」以加载插件。

软件包依赖允许在 iPad7,5 的 18.x 系统上安装；允许安装不代表所有版本的私有 CameraUI 实现都兼容。详见[兼容性与验证](docs/VALIDATION.zh-CN.md)。

## 验证与卸载

执行以下命令查看运行中的服务：

```sh
sudo launchctl print user/501/com.apple.cameracaptured
```

将实际限额与当前系统版本的参考策略进行对照。分别测试前后镜头切换、照片保存、录像保存与回放，以及第三方应用预览。

先卸载 CameraUI 插件并重新打开「相机」。卸载 Jetsam 软件包会恢复备份的原始字节。如果当前策略既不匹配原始备份，也不匹配补丁副本，卸载过程将停止。重新加载恢复后的策略时，同样需要准备好有线引导流程。

## 构建

在 macOS 上准备 Xcode、iPhoneOS SDK、Python 3，并确保 ar 和 ldid 在 PATH 中，然后运行：

```sh
./build.sh
```

两个安装包将生成到 `packages/`。源码采用 MIT 许可证。

## 已知问题
### 1. Codex 配对功能闪退

> [!NOTE]
> **猜想：** `DataScannerViewController` 可能需要 **A12 或更新的芯片**。