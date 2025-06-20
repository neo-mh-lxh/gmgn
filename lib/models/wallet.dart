import 'package:intl/intl.dart';

class Wallet {
  final String id;
  final String name;
  final String address;
  final WalletType type;
  final double balance;
  final double totalValue;
  final List<TokenBalance> tokens;
  final List<Transaction> recentTransactions;
  final DateTime lastUpdated;

  Wallet({
    required this.id,
    required this.name,
    required this.address,
    required this.type,
    required this.balance,
    required this.totalValue,
    required this.tokens,
    required this.recentTransactions,
    required this.lastUpdated,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      type: WalletType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => WalletType.solana,
      ),
      balance: (json['balance'] ?? 0).toDouble(),
      totalValue: (json['total_value'] ?? 0).toDouble(),
      tokens: (json['tokens'] as List? ?? [])
          .map((t) => TokenBalance.fromJson(t))
          .toList(),
      recentTransactions: (json['recent_transactions'] as List? ?? [])
          .map((t) => Transaction.fromJson(t))
          .toList(),
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }

  String get shortAddress =>
      '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
}

enum WalletType {
  solana,
  ethereum,
  bitcoin,
}

class TokenBalance {
  final String symbol;
  final String name;
  final String? logo;
  final double amount;
  final double price;
  final double value;
  final double change24h;

  TokenBalance({
    required this.symbol,
    required this.name,
    this.logo,
    required this.amount,
    required this.price,
    required this.value,
    required this.change24h,
  });

  factory TokenBalance.fromJson(Map<String, dynamic> json) {
    return TokenBalance(
      symbol: json['symbol'],
      name: json['name'],
      logo: json['logo'],
      amount: (json['amount'] ?? 0).toDouble(),
      price: (json['price'] ?? 0).toDouble(),
      value: (json['value'] ?? 0).toDouble(),
      change24h: (json['change_24h'] ?? 0).toDouble(),
    );
  }
}

class Transaction {
  final String id;
  final TransactionType type;
  final String? fromAddress;
  final String? toAddress;
  final double amount;
  final String? tokenSymbol;
  final double? fee;
  final TransactionStatus status;
  final DateTime timestamp;
  final String? signature;

  Transaction({
    required this.id,
    required this.type,
    this.fromAddress,
    this.toAddress,
    required this.amount,
    this.tokenSymbol,
    this.fee,
    required this.status,
    required this.timestamp,
    this.signature,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      type: TransactionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => TransactionType.unknown,
      ),
      fromAddress: json['from_address'],
      toAddress: json['to_address'],
      amount: (json['amount'] ?? 0).toDouble(),
      tokenSymbol: json['token_symbol'],
      fee: json['fee']?.toDouble(),
      status: TransactionStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => TransactionStatus.pending,
      ),
      timestamp: DateTime.parse(json['timestamp']),
      signature: json['signature'],
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  String get formattedDate =>
      DateFormat('MMM dd, yyyy HH:mm').format(timestamp);
}

enum TransactionType {
  send,
  receive,
  swap,
  stake,
  unstake,
  unknown,
}

enum TransactionStatus {
  pending,
  confirmed,
  failed,
}
