import 'package:intl/intl.dart';

class Formatters {
  static final NumberFormat currencyFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static final NumberFormat compactCurrencyFormat =
      NumberFormat.compactCurrency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static final NumberFormat percentFormat = NumberFormat(
    '+#0.00%;-#0.00%',
  );

  static final NumberFormat compactFormat = NumberFormat.compact();

  static String formatCurrency(double value) {
    if (value >= 1000000) {
      return compactCurrencyFormat.format(value);
    }
    return currencyFormat.format(value);
  }

  static String formatNumber(double value) {
    if (value >= 1000) {
      return compactFormat.format(value);
    }
    return value.toStringAsFixed(0);
  }

  static String formatPercent(double value) {
    return percentFormat.format(value / 100);
  }

  static String formatLargeNumber(double value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }

  static String formatPrice(double value) {
    if (value >= 1) {
      return '\$${value.toStringAsFixed(2)}';
    } else if (value >= 0.01) {
      return '\$${value.toStringAsFixed(4)}';
    } else if (value >= 0.0001) {
      return '\$${value.toStringAsFixed(6)}';
    } else {
      return '\$${value.toStringAsExponential(2)}';
    }
  }

  static String formatAge(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}
