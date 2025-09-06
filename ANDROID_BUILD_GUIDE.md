# Android APK 编译指南 (Android APK Compilation Guide)

本文档提供了编译 Simple Live 安卓 APK 的详细步骤。

## 系统要求 (System Requirements)

### 必需软件 (Required Software)
- **Java 17** (OpenJDK 或 Oracle JDK)
- **Flutter SDK 3.22.x**
- **Android SDK** (API 级别 21 或更高)
- **Git**

### 硬件要求 (Hardware Requirements)
- **RAM**: 最少 8GB，推荐 16GB
- **存储空间**: 至少 20GB 可用空间
- **操作系统**: 
  - Ubuntu 18.04+ (推荐)
  - macOS 10.14+
  - Windows 10+

## 环境配置 (Environment Setup)

### 1. 安装 Java 17

#### Ubuntu/Debian:
```bash
sudo apt update
sudo apt install openjdk-17-jdk
```

#### macOS:
```bash
brew install openjdk@17
```

#### Windows:
从 [Oracle官网](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html) 下载并安装 JDK 17

### 2. 安装 Flutter SDK

#### 方法一：官方下载
```bash
# 下载 Flutter
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.3-stable.tar.xz

# 解压
tar xf flutter_linux_3.22.3-stable.tar.xz

# 添加到 PATH
export PATH="$PATH:`pwd`/flutter/bin"
```

#### 方法二：Git 克隆
```bash
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:`pwd`/flutter/bin"
```

### 3. 安装 Android SDK

#### 通过 Android Studio (推荐):
1. 下载并安装 [Android Studio](https://developer.android.com/studio)
2. 启动 Android Studio 并完成 SDK 安装
3. 设置环境变量:
   ```bash
   export ANDROID_HOME=$HOME/Android/Sdk
   export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
   ```

#### 命令行安装:
```bash
# Ubuntu
sudo apt install android-sdk

# 设置 ANDROID_HOME
export ANDROID_HOME=/usr/lib/android-sdk
```

### 4. 验证环境

```bash
# 检查 Java 版本
java -version

# 检查 Flutter 环境
flutter doctor

# 检查 Android 许可证
flutter doctor --android-licenses
```

## 编译步骤 (Compilation Steps)

### 1. 获取源代码
```bash
git clone https://github.com/ZYar-er/dart_simple_live.git
cd dart_simple_live
```

### 2. 安装依赖
```bash
cd simple_live_app
flutter pub get
```

### 3. 配置签名 (可选，用于发布版本)

创建 `simple_live_app/android/key.properties` 文件:
```properties
storePassword=你的密钥库密码
keyPassword=你的密钥密码
keyAlias=你的密钥别名
storeFile=密钥库文件路径
```

### 4. 编译 APK

#### Debug 版本:
```bash
flutter build apk --debug
```

#### Release 版本:
```bash
flutter build apk --release --split-per-abi
```

### 5. 查找生成的 APK
编译完成后，APK 文件位于:
```
simple_live_app/build/app/outputs/flutter-apk/
```

生成的文件:
- `app-armeabi-v7a-release.apk` (32位 ARM 设备)
- `app-arm64-v8a-release.apk` (64位 ARM 设备) 
- `app-x86_64-release.apk` (64位 x86 设备)

## 自动化脚本 (Automation Script)

使用提供的脚本自动编译:
```bash
./build_android_apk.sh
```

## 故障排除 (Troubleshooting)

### 常见问题

#### 1. "flutter: command not found"
确保 Flutter 已添加到 PATH:
```bash
export PATH="$PATH:/path/to/flutter/bin"
```

#### 2. "Android licenses not accepted"
运行以下命令接受许可证:
```bash
flutter doctor --android-licenses
```

#### 3. "Gradle build failed"
清理并重新构建:
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk
```

#### 4. "Java version mismatch"
确保使用 Java 17:
```bash
java -version
# 如果版本不正确，设置 JAVA_HOME
export JAVA_HOME=/path/to/jdk17
```

### 网络问题解决
如果遇到网络连接问题，可以：
1. 使用 VPN 或代理
2. 配置镜像源
3. 使用离线依赖包

## 性能优化 (Performance Optimization)

### 构建优化选项:
```bash
# 启用混淆和缩减资源
flutter build apk --release --obfuscate --split-debug-info=./debug-symbols

# 针对特定架构构建
flutter build apk --release --target-platform android-arm64
```

### 减小 APK 大小:
1. 使用 `--split-per-abi` 选项
2. 启用代码混淆
3. 移除未使用的资源

## 签名和发布 (Signing and Publishing)

### 生成签名密钥:
```bash
keytool -genkey -v -keystore my-release-key.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias my-key-alias
```

### 配置签名:
在 `android/key.properties` 中配置密钥信息，然后构建发布版本。

## 相关链接 (Related Links)

- [Flutter 官方文档](https://flutter.dev/docs)
- [Android 开发者指南](https://developer.android.com/guide)
- [Simple Live 项目主页](https://github.com/ZYar-er/dart_simple_live)

## 支持 (Support)

如果遇到问题，请：
1. 检查 [Issues](https://github.com/ZYar-er/dart_simple_live/issues) 页面
2. 参考 Flutter 官方文档
3. 在项目中创建新的 Issue