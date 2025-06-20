import 'dart:math';
import '../models/wallet.dart';

class WalletService {
  static List<Wallet> generateMockWallets() {
    return [
      Wallet(
        id: 'wallet_1',
        name: 'Main Wallet',
        address: 'So11111111111111111111111111111111111111112',
        type: WalletType.solana,
        balance: 12.45,
        totalValue: 3420.50,
        tokens: _generateMockTokens(),
        recentTransactions: _generateMockTransactions(),
        lastUpdated: DateTime.now(),
      ),
      Wallet(
        id: 'wallet_2',
        name: 'Trading Wallet',
        address: '0x742d35Cc6634C0532925a3b8D4521D296995C980',
        type: WalletType.ethereum,
        balance: 2.1,
        totalValue: 4567.89,
        tokens: _generateMockTokens(),
        recentTransactions: _generateMockTransactions(),
        lastUpdated: DateTime.now(),
      ),
    ];
  }

  static List<TokenBalance> _generateMockTokens() {
    final random = Random();
    final tokens = [
      {'symbol': 'SOL', 'name': 'Solana'},
      {'symbol': 'USDC', 'name': 'USD Coin'},
      {'symbol': 'RAY', 'name': 'Raydium'},
      {'symbol': 'SRM', 'name': 'Serum'},
      {'symbol': 'FIDA', 'name': 'Fida'},
      {'symbol': 'COPE', 'name': 'Cope'},
      {'symbol': 'STEP', 'name': 'Step Finance'},
    ];

    return tokens.map((token) {
      final amount = random.nextDouble() * 1000;
      final price = random.nextDouble() * 100;
      return TokenBalance(
        symbol: token['symbol']!,
        name: token['name']!,
        amount: amount,
        price: price,
        value: amount * price,
        change24h: (random.nextDouble() - 0.5) * 20,
      );
    }).toList();
  }

  static List<Transaction> _generateMockTransactions() {
    final random = Random();
    const types = TransactionType.values;
    const statuses = TransactionStatus.values;

    return List.generate(20, (index) {
      final type = types[random.nextInt(types.length)];
      final status = statuses[random.nextInt(statuses.length)];

      return Transaction(
        id: 'tx_${index + 1}',
        type: type,
        fromAddress: _generateRandomAddress(),
        toAddress: _generateRandomAddress(),
        amount: random.nextDouble() * 100,
        tokenSymbol: ['SOL', 'USDC', 'RAY'][random.nextInt(3)],
        fee: random.nextDouble() * 0.01,
        status: status,
        timestamp: DateTime.now().subtract(Duration(
          hours: random.nextInt(24 * 7),
          minutes: random.nextInt(60),
        )),
        signature: _generateRandomSignature(),
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

  static String _generateRandomSignature() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(88, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  static Future<List<Wallet>> fetchWallets() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return generateMockWallets();
  }

  static Future<Wallet> fetchWalletDetails(String walletId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final wallets = generateMockWallets();
    return wallets.firstWhere((w) => w.id == walletId);
  }

  static Future<List<Transaction>> fetchTransactionHistory(
    String walletId, {
    int page = 1,
    int limit = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _generateMockTransactions();
  }

  static Future<bool> sendTransaction({
    required String fromWallet,
    required String toAddress,
    required double amount,
    required String tokenSymbol,
  }) async {
    await Future.delayed(const Duration(milliseconds: 2000));
    // 模拟交易成功/失败
    return Random().nextBool();
  }
}
