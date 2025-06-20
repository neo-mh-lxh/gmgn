# GMGN.AI - 智能加密货币交易平台

<div align="center">
  <img src="assets/icons/app_icon.svg" width="120" height="120" alt="GMGN.AI Logo">
  
  ![Flutter](https://img.shields.io/badge/Flutter-3.32.4-blue.svg)
  ![Dart](https://img.shields.io/badge/Dart-3.8.1-blue.svg)
  ![License](https://img.shields.io/badge/License-MIT-green.svg)
</div>

## 📱 应用简介

GMGN.AI 是一款专业的加密货币交易平台移动应用，提供实时市场数据监控、智能钱包管理和跟单交易功能。应用采用现代化的深色主题设计，为用户提供流畅的交易体验。

## ✨ 主要功能

### 🔐 用户认证系统

- 邮箱注册登录
- 邮箱验证码验证
- 用户数据持久化存储
- 安全的认证状态管理

### 📊 市场数据监控

- 实时新币对监控
- 价格图表展示
- 交易历史记录
- 市场统计数据
- 智能筛选功能

### 💰 钱包管理

- 多币种余额展示
- SOL、USDC、RAY 等主流代币支持
- 充值提现功能
- 详细交易记录
- 资产价值统计

### 🔄 跟单交易

- 钱包地址管理
- 多种跟单模式（闪电模式、极速上链）
- 灵活买入策略（最大跟买、固定金额、固定比例）
- 智能卖出设置（自动跟卖、不跟卖）
- 止盈止损配置
- 高级交易参数设置

### 👤 个人中心

- 用户信息管理
- 安全退出登录
- 简洁的用户界面

## 🎨 设计特色

- **GMGN 品牌风格**：采用标志性的绿色主题色彩 (#4ECCA3)
- **深色主题**：现代化的深色界面设计
- **响应式布局**：适配不同屏幕尺寸
- **流畅动画**：提升用户体验的交互动画
- **原生启动屏幕**：iOS 和 Android 原生启动效果

## 📋 页面流程图

### 1. 应用导航流程

```mermaid
flowchart TD
    A[启动页面<br/>SplashScreen] --> B{用户认证状态}

    B -->|未登录| C[登录页面<br/>LoginScreen]
    B -->|已登录| D[主应用<br/>MainScreen]

    C --> E[注册页面<br/>RegisterScreen]
    E --> F[邮箱验证<br/>EmailVerification]
    F --> D
    C --> D

    D --> G[市场数据页面<br/>MarketScreen]
    D --> H[钱包页面<br/>WalletScreen]
    D --> I[跟单页面<br/>CopyTradingScreen]
    D --> J[个人页面<br/>ProfileScreen]

    G --> G1[新币对监控<br/>NewPairMonitoring]
    G --> G2[价格图表<br/>PriceCharts]
    G --> G3[交易历史<br/>TradingHistory]

    H --> H1[余额展示<br/>BalanceDisplay]
    H --> H2[充值功能<br/>DepositFunction]
    H --> H3[提现功能<br/>WithdrawFunction]
    H --> H4[交易记录<br/>TransactionHistory]

    I --> I1[钱包地址输入<br/>WalletAddressInput]
    I --> I2[跟单模式选择<br/>TradingModeSelection]
    I --> I3[买入方式设置<br/>BuySettings]
    I --> I4[卖出方式设置<br/>SellSettings]
    I --> I5[高级设置<br/>AdvancedSettings]

    J --> J1[退出登录<br/>Logout]
    J1 --> C

    %% 样式定义
    classDef startPage fill:#4ECCA3,stroke:#2EAA8A,stroke-width:3px,color:#000
    classDef authPage fill:#FFE4B5,stroke:#DEB887,stroke-width:2px,color:#000
    classDef mainPage fill:#E6F3FF,stroke:#4A90E2,stroke-width:2px,color:#000
    classDef subPage fill:#F0F8FF,stroke:#87CEEB,stroke-width:1px,color:#000
    classDef decision fill:#FFE4E1,stroke:#CD5C5C,stroke-width:2px,color:#000

    class A startPage
    class B decision
    class C,E,F authPage
    class D,G,H,I,J mainPage
    class G1,G2,G3,H1,H2,H3,H4,I1,I2,I3,I4,I5,J1 subPage
```

### 2. 应用架构模块图

```mermaid
graph TB
    subgraph "GMGN.AI 应用架构"
        A[启动模块<br/>Splash Screen]

        subgraph "认证模块 Authentication"
            B[登录 Login]
            C[注册 Register]
            D[邮箱验证 Email Verification]
        end

        subgraph "主导航 Main Navigation"
            E[底部导航栏<br/>BottomNavigationBar]
        end

        subgraph "市场数据模块 Market Data"
            F[新币对监控<br/>New Pair Monitoring]
            F1[实时价格更新<br/>Real-time Price Updates]
            F2[交易对筛选<br/>Trading Pair Filtering]
            F3[价格图表<br/>Price Charts]
            F4[交易历史<br/>Trading History]
            F5[市场统计<br/>Market Statistics]
        end

        subgraph "钱包模块 Wallet"
            G[钱包概览<br/>Wallet Overview]
            G1[总余额显示<br/>Total Balance Display]
            G2[代币持仓<br/>Token Holdings]
            G3[充值功能<br/>Deposit Function]
            G4[提现功能<br/>Withdraw Function]
            G5[交易记录<br/>Transaction History]
        end

        subgraph "跟单模块 Copy Trading"
            H[跟单设置<br/>Copy Trading Setup]
            H1[钱包地址管理<br/>Wallet Address Management]
            H2[跟单模式<br/>Trading Mode Selection]
            H3[买入策略<br/>Buy Strategy]
            H4[卖出策略<br/>Sell Strategy]
            H5[风险控制<br/>Risk Management]
            H6[高级设置<br/>Advanced Settings]
        end

        subgraph "个人中心 Profile"
            I[用户设置<br/>User Settings]
            I1[账户信息<br/>Account Information]
            I2[退出登录<br/>Logout]
        end

        subgraph "数据服务 Data Services"
            J[API服务<br/>API Services]
            K[本地存储<br/>Local Storage]
            L[认证服务<br/>Authentication Service]
        end
    end

    %% 连接关系
    A --> B
    B --> E
    C --> D
    D --> E

    E --> F
    E --> G
    E --> H
    E --> I

    F --> F1
    F --> F2
    F --> F3
    F --> F4
    F --> F5

    G --> G1
    G --> G2
    G --> G3
    G --> G4
    G --> G5

    H --> H1
    H --> H2
    H --> H3
    H --> H4
    H --> H5
    H --> H6

    I --> I1
    I --> I2
    I2 --> B

    %% 数据流
    F -.-> J
    G -.-> J
    H -.-> J
    B -.-> L
    C -.-> L
    G -.-> K
    H -.-> K

    %% 样式定义
    classDef startModule fill:#4ECCA3,stroke:#2EAA8A,stroke-width:3px,color:#000
    classDef authModule fill:#FFE4B5,stroke:#DEB887,stroke-width:2px,color:#000
    classDef mainModule fill:#E6F3FF,stroke:#4A90E2,stroke-width:2px,color:#000
    classDef serviceModule fill:#F0F0F0,stroke:#808080,stroke-width:2px,color:#000
    classDef feature fill:#F8F8FF,stroke:#9370DB,stroke-width:1px,color:#000

    class A startModule
    class B,C,D,L authModule
    class E,F,G,H,I mainModule
    class J,K serviceModule
    class F1,F2,F3,F4,F5,G1,G2,G3,G4,G5,H1,H2,H3,H4,H5,H6,I1,I2 feature
```

### 3. 用户交互时序图

```mermaid
sequenceDiagram
    participant U as 用户
    participant S as 启动页面
    participant A as 认证系统
    participant M as 主界面
    participant Market as 市场数据
    participant Wallet as 钱包
    participant Copy as 跟单
    participant Profile as 个人中心

    Note over U,Profile: GMGN.AI 用户交互流程

    U->>S: 启动应用
    S->>S: 显示GMGN.AI Logo<br/>和启动动画
    S->>A: 检查登录状态

    alt 用户未登录
        A->>U: 显示登录界面
        U->>A: 输入邮箱密码
        A->>A: 验证用户信息
        A->>U: 登录成功
    else 用户已登录
        A->>M: 直接进入主界面
    end

    A->>M: 进入主界面
    M->>U: 显示底部导航栏

    rect rgb(230, 243, 255)
        Note over U,Market: 市场数据功能
        U->>Market: 点击市场数据
        Market->>Market: 加载新币对数据
        Market->>U: 显示实时价格
        U->>Market: 筛选交易对
        Market->>U: 更新筛选结果
    end

    rect rgb(240, 248, 255)
        Note over U,Wallet: 钱包功能
        U->>Wallet: 点击钱包
        Wallet->>Wallet: 加载余额信息
        Wallet->>U: 显示总余额和代币
        U->>Wallet: 查看交易记录
        Wallet->>U: 显示历史交易
    end

    rect rgb(255, 248, 220)
        Note over U,Copy: 跟单功能
        U->>Copy: 点击跟单
        Copy->>U: 显示跟单设置
        U->>Copy: 输入钱包地址
        U->>Copy: 设置跟单参数
        Copy->>Copy: 保存跟单配置
        Copy->>U: 确认跟单设置
    end

    rect rgb(255, 240, 245)
        Note over U,Profile: 个人中心
        U->>Profile: 点击个人中心
        Profile->>U: 显示用户信息
        U->>Profile: 点击退出登录
        Profile->>A: 清除登录状态
        A->>U: 返回登录界面
    end
```

## 🛠️ 技术栈

- **框架**: Flutter 3.32.4
- **语言**: Dart 3.8.1
- **状态管理**: Provider
- **网络请求**: Dio, HTTP
- **本地存储**: SharedPreferences
- **图表组件**: FL Chart
- **图像处理**: Cached Network Image
- **动画**: Flutter Animations
- **国际化**: Intl

## 📱 支持平台

- ✅ iOS 12.0+
- ✅ Android API 21+
- ✅ 响应式设计，支持各种屏幕尺寸

## 🚀 快速开始

### 环境要求

- Flutter SDK 3.32.4+
- Dart SDK 3.8.1+
- Android Studio / VS Code
- iOS: Xcode 15.0+ (仅 iOS 开发)
- Java 17+ (Android 开发)

### 安装步骤

1. **克隆项目**

   ```bash
   git clone <repository-url>
   cd flutter_app
   ```

2. **安装依赖**

   ```bash
   flutter pub get
   ```

3. **运行应用**

   ```bash
   # iOS模拟器
   flutter run -d ios

   # Android模拟器
   flutter run -d android

   # 查看可用设备
   flutter devices
   ```

### 构建发布版本

```bash
# Android APK
flutter build apk --release

# iOS IPA (需要在macOS上)
flutter build ios --release
```

## 📁 项目结构

```
lib/
├── main.dart                 # 应用入口
├── models/                   # 数据模型
│   ├── user.dart
│   └── trading_data.dart
├── screens/                  # 页面组件
│   ├── splash_screen.dart
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── main_screen.dart
│   ├── market_screen.dart
│   ├── wallet_screen.dart
│   ├── copy_trading_screen.dart
│   └── profile_screen.dart
├── services/                 # 业务服务
│   ├── auth_service.dart
│   └── api_service.dart
└── widgets/                  # 通用组件
    ├── custom_button.dart
    └── loading_indicator.dart

assets/
├── images/                   # 图片资源
└── icons/                    # 图标资源
    └── app_icon.svg

android/                      # Android原生配置
ios/                         # iOS原生配置
```

## 🎯 开发路线图

- [x] 用户认证系统
- [x] 市场数据展示
- [x] 钱包功能
- [x] 跟单交易界面
- [x] 原生启动屏幕
- [x] 应用图标和品牌
- [ ] 实时数据推送
- [ ] 交易执行功能
- [ ] 多语言支持
- [ ] 深色/浅色主题切换
- [ ] 推送通知

## 🤝 贡献指南

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 📞 联系我们

- 官网: [https://gmgn.ai](https://gmgn.ai)
- 邮箱: support@gmgn.ai
- Telegram: @GMGNAI

---

<div align="center">
  <p>由 ❤️ 和 Flutter 构建</p>
  <p>© 2024 GMGN.AI. All rights reserved.</p>
</div>
