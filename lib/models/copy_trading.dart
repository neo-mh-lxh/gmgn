class CopyTrader {
  final String id;
  final String name;
  final String? avatar;
  final String address;
  final double totalReturn;
  final double totalReturnPercentage;
  final int followers;
  final int winRate;
  final double avgPositionSize;
  final List<String> preferredTokens;
  final double riskScore;
  final int totalTrades;
  final DateTime joinDate;
  final bool isVerified;
  final double copyFee;
  final List<TradePosition> recentTrades;

  CopyTrader({
    required this.id,
    required this.name,
    this.avatar,
    required this.address,
    required this.totalReturn,
    required this.totalReturnPercentage,
    required this.followers,
    required this.winRate,
    required this.avgPositionSize,
    required this.preferredTokens,
    required this.riskScore,
    required this.totalTrades,
    required this.joinDate,
    this.isVerified = false,
    this.copyFee = 0.0,
    required this.recentTrades,
  });

  factory CopyTrader.fromJson(Map<String, dynamic> json) {
    return CopyTrader(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      address: json['address'],
      totalReturn: (json['total_return'] ?? 0).toDouble(),
      totalReturnPercentage: (json['total_return_percentage'] ?? 0).toDouble(),
      followers: json['followers'] ?? 0,
      winRate: json['win_rate'] ?? 0,
      avgPositionSize: (json['avg_position_size'] ?? 0).toDouble(),
      preferredTokens: List<String>.from(json['preferred_tokens'] ?? []),
      riskScore: (json['risk_score'] ?? 0).toDouble(),
      totalTrades: json['total_trades'] ?? 0,
      joinDate: DateTime.parse(json['join_date']),
      isVerified: json['is_verified'] ?? false,
      copyFee: (json['copy_fee'] ?? 0).toDouble(),
      recentTrades: (json['recent_trades'] as List? ?? [])
          .map((t) => TradePosition.fromJson(t))
          .toList(),
    );
  }

  String get shortAddress =>
      '${address.substring(0, 6)}...${address.substring(address.length - 4)}';

  String get riskLevel {
    if (riskScore <= 3) return 'Low';
    if (riskScore <= 6) return 'Medium';
    return 'High';
  }
}

class TradePosition {
  final String id;
  final String tokenSymbol;
  final String tokenName;
  final PositionType type;
  final double entryPrice;
  final double? exitPrice;
  final double amount;
  final double pnl;
  final double pnlPercentage;
  final PositionStatus status;
  final DateTime openTime;
  final DateTime? closeTime;

  TradePosition({
    required this.id,
    required this.tokenSymbol,
    required this.tokenName,
    required this.type,
    required this.entryPrice,
    this.exitPrice,
    required this.amount,
    required this.pnl,
    required this.pnlPercentage,
    required this.status,
    required this.openTime,
    this.closeTime,
  });

  factory TradePosition.fromJson(Map<String, dynamic> json) {
    return TradePosition(
      id: json['id'],
      tokenSymbol: json['token_symbol'],
      tokenName: json['token_name'],
      type: PositionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => PositionType.buy,
      ),
      entryPrice: (json['entry_price'] ?? 0).toDouble(),
      exitPrice: json['exit_price']?.toDouble(),
      amount: (json['amount'] ?? 0).toDouble(),
      pnl: (json['pnl'] ?? 0).toDouble(),
      pnlPercentage: (json['pnl_percentage'] ?? 0).toDouble(),
      status: PositionStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => PositionStatus.open,
      ),
      openTime: DateTime.parse(json['open_time']),
      closeTime: json['close_time'] != null
          ? DateTime.parse(json['close_time'])
          : null,
    );
  }

  String get duration {
    final end = closeTime ?? DateTime.now();
    final diff = end.difference(openTime);
    if (diff.inDays > 0) return '${diff.inDays}d';
    if (diff.inHours > 0) return '${diff.inHours}h';
    return '${diff.inMinutes}m';
  }
}

enum PositionType {
  buy,
  sell,
}

enum PositionStatus {
  open,
  closed,
  cancelled,
}

class CopyTradingSettings {
  final String traderId;
  final double maxPositionSize;
  final double totalAllocation;
  final bool autoFollow;
  final List<String> excludedTokens;
  final double stopLossPercentage;
  final double takeProfitPercentage;
  final bool isActive;

  CopyTradingSettings({
    required this.traderId,
    required this.maxPositionSize,
    required this.totalAllocation,
    this.autoFollow = true,
    this.excludedTokens = const [],
    this.stopLossPercentage = 10.0,
    this.takeProfitPercentage = 50.0,
    this.isActive = true,
  });

  factory CopyTradingSettings.fromJson(Map<String, dynamic> json) {
    return CopyTradingSettings(
      traderId: json['trader_id'],
      maxPositionSize: (json['max_position_size'] ?? 0).toDouble(),
      totalAllocation: (json['total_allocation'] ?? 0).toDouble(),
      autoFollow: json['auto_follow'] ?? true,
      excludedTokens: List<String>.from(json['excluded_tokens'] ?? []),
      stopLossPercentage: (json['stop_loss_percentage'] ?? 10.0).toDouble(),
      takeProfitPercentage: (json['take_profit_percentage'] ?? 50.0).toDouble(),
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trader_id': traderId,
      'max_position_size': maxPositionSize,
      'total_allocation': totalAllocation,
      'auto_follow': autoFollow,
      'excluded_tokens': excludedTokens,
      'stop_loss_percentage': stopLossPercentage,
      'take_profit_percentage': takeProfitPercentage,
      'is_active': isActive,
    };
  }
}
