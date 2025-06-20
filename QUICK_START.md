# 快速开始指南

## 项目结构

```
flutter_app/
├── lib/
│   ├── main.dart                    # 应用入口
│   ├── models/
│   │   └── trading_pair.dart        # 交易对数据模型
│   ├── services/
│   │   └── trading_service.dart     # 数据服务
│   ├── screens/
│   │   └── new_pair_screen.dart     # 主页面
│   ├── widgets/
│   │   ├── filter_tabs.dart         # 筛选标签
│   │   ├── table_header.dart        # 表格头部
│   │   └── trading_pair_item.dart   # 交易对列表项
│   └── utils/
│       └── formatters.dart          # 格式化工具
├── assets/
│   ├── images/
│   └── icons/
├── pubspec.yaml                     # 依赖配置
└── README.md                        # 详细说明
```

## 运行应用

1. **安装依赖**

   ```bash
   flutter pub get
   ```

2. **检查代码**

   ```bash
   flutter analyze
   ```

3. **运行应用**

   ```bash
   # 在模拟器或连接的设备上运行
   flutter run

   # 或者在Chrome浏览器中运行
   flutter run -d chrome
   ```

## 功能展示

- ✅ 模拟了 GMGN.ai 新交易对页面的完整布局
- ✅ 包含平台筛选（All, Pump, Moonshot, Raydium）
- ✅ 支持按各列排序
- ✅ 显示安全检查指标
- ✅ 实时价格变化（模拟数据）
- ✅ 响应式设计

## 注意事项

- 当前使用模拟数据，实际应用需要接入真实 API
- 所有的交易对数据都是随机生成的示例数据
- 界面设计参考了 GMGN.ai 的原始布局

## 技术栈

- Flutter 3.0+
- Provider (状态管理)
- Material Design 3
