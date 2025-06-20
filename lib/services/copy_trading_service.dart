import 'dart:math';
import '../models/copy_trading.dart';

class CopyTradingService {
  static List<CopyTrader> generateMockTraders() {
    final random = Random();
    final traderNames = [
      'CryptoWhale88',
      'DefiMaster',
      'SolanaKing',
      'MemeHunter',
      'YieldFarmer',
      'NFTCollector',
      'AlgoTrader',
      'DiamondHands',
      'PumpSeeker',
      'SmartMoney',
      'TradingBot',
      'LiquidityPro'
    ];

    return List.generate(20, (index) {
      final totalReturn = (random.nextDouble() - 0.3) * 200000;
      final totalReturnPercentage = (random.nextDouble() - 0.3) * 500;

      return CopyTrader(
        id: 'trader_${index + 1}',
        name: traderNames[random.nextInt(traderNames.length)],
        address: _generateRandomAddress(),
        totalReturn: totalReturn,
        totalReturnPercentage: totalReturnPercentage,
        followers: random.nextInt(5000) + 100,
        winRate: random.nextInt(40) + 50, // 50-90%
        avgPositionSize: random.nextDouble() * 10000 + 1000,
        preferredTokens: _getRandomTokens(random),
        riskScore: random.nextDouble() * 10,
        totalTrades: random.nextInt(1000) + 50,
        joinDate: DateTime.now().subtract(Duration(days: random.nextInt(365))),
        isVerified: random.nextBool(),
        copyFee: random.nextDouble() * 3, // 0-3%
        recentTrades: _generateMockTrades(random),
      );
    });
  }

  static List<String> _getRandomTokens(Random random) {
    final allTokens = [
      'SOL',
      'RAY',
      'SRM',
      'FIDA',
      'COPE',
      'STEP',
      'MNGO',
      'ORCA'
    ];
    final count = random.nextInt(4) + 2; // 2-5 tokens
    allTokens.shuffle(random);
    return allTokens.take(count).toList();
  }

  static List<TradePosition> _generateMockTrades(Random random) {
    final tokens = ['SOL', 'RAY', 'SRM', 'FIDA', 'COPE'];

    return List.generate(random.nextInt(10) + 5, (index) {
      final token = tokens[random.nextInt(tokens.length)];
      final entryPrice = random.nextDouble() * 100;
      final isOpen = random.nextBool();
      final pnlPercentage = (random.nextDouble() - 0.4) * 100;

      return TradePosition(
        id: 'trade_${index + 1}',
        tokenSymbol: token,
        tokenName: '$token Token',
        type: random.nextBool() ? PositionType.buy : PositionType.sell,
        entryPrice: entryPrice,
        exitPrice: isOpen ? null : entryPrice * (1 + pnlPercentage / 100),
        amount: random.nextDouble() * 1000,
        pnl: random.nextDouble() * 5000 - 1000,
        pnlPercentage: pnlPercentage,
        status: isOpen ? PositionStatus.open : PositionStatus.closed,
        openTime: DateTime.now().subtract(Duration(
          hours: random.nextInt(24 * 30),
          minutes: random.nextInt(60),
        )),
        closeTime: isOpen
            ? null
            : DateTime.now().subtract(Duration(
                hours: random.nextInt(24 * 7),
                minutes: random.nextInt(60),
              )),
      );
    });
  }

  static String _generateRandomAddress() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(44, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  static Future<List<CopyTrader>> fetchTopTraders({
    String sortBy = 'total_return',
    int limit = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final traders = generateMockTraders();

    // 根据sortBy排序
    switch (sortBy) {
      case 'total_return':
        traders.sort((a, b) => b.totalReturn.compareTo(a.totalReturn));
        break;
      case 'win_rate':
        traders.sort((a, b) => b.winRate.compareTo(a.winRate));
        break;
      case 'followers':
        traders.sort((a, b) => b.followers.compareTo(a.followers));
        break;
      case 'total_trades':
        traders.sort((a, b) => b.totalTrades.compareTo(a.totalTrades));
        break;
    }

    return traders.take(limit).toList();
  }

  static Future<CopyTrader> fetchTraderDetails(String traderId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final traders = generateMockTraders();
    return traders.firstWhere((t) => t.id == traderId);
  }

  static Future<List<TradePosition>> fetchTraderTrades(
    String traderId, {
    int page = 1,
    int limit = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _generateMockTrades(Random());
  }

  static Future<bool> startCopyTrading({
    required String traderId,
    required CopyTradingSettings settings,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    // 模拟开始复制交易
    return Random().nextDouble() > 0.1; // 90% 成功率
  }

  static Future<bool> stopCopyTrading(String traderId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }

  static Future<List<CopyTradingSettings>> fetchActiveCopySettings() async {
    await Future.delayed(const Duration(milliseconds: 600));
    final random = Random();

    return List.generate(random.nextInt(5), (index) {
      return CopyTradingSettings(
        traderId: 'trader_${index + 1}',
        maxPositionSize: random.nextDouble() * 5000 + 500,
        totalAllocation: random.nextDouble() * 20000 + 5000,
        autoFollow: random.nextBool(),
        excludedTokens: ['SCAM', 'RUG'],
        stopLossPercentage: random.nextDouble() * 20 + 5,
        takeProfitPercentage: random.nextDouble() * 100 + 20,
        isActive: random.nextBool(),
      );
    });
  }

  static Future<bool> updateCopySettings(CopyTradingSettings settings) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return true;
  }
}
