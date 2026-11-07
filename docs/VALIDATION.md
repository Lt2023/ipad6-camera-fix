# 验证记录

- 设备：iPad7,5 / J71b，18.7.2 (22H124)，rootful，ElleKit 1.2。
- 1.0：隔离 dpkg 解包复现父目录缺失错误，exit 1。
- 1.1：设备隔离根目录完整安装返回 INSTALL_OK；卸载返回 REMOVE_OK，策略字节恢复一致。
- 1.1 实机：重启后 launchctl 确认 priority 140、active soft 1550 MB、inactive hard 27 MB、threads 512，服务 PID 70 保持运行。
- CameraUI 0.1：arm64 编译、签名、实机 dpkg 安装完成；dpkg -V 未报告校验差异。
- 用户反馈：“有了，有了功能都有了”；第三方及系统相机功能恢复。
- 未完成：多设备验证、全部格式/帧率、音轨、录像保存回放逐项独立验收。
- 当前发布文件为已测试原件复制；重新构建脚本已进行语法及策略生成校验，未承诺二进制可重复构建。
