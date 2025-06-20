import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _isLoading = true;
  String _selectedTimeFrame = '7d';
  String _selectedTab = '最近盈亏';

  // 模拟钱包数据
  final Map<String, dynamic> _walletData = {
    'address': '59w8VJKqVpQbFTaqGSVfYKpGjR91VHXZEcjmomtiw',
    'uid': '38420594',
    'email': 'geoliuxh@gmail.com',
    'twitter': '绑定Twitter',
    'totalPnL': 0.0,
    'winRate': 0.0,
    'totalTrades': 0,
    'avgHoldTime': '--',
    'buyVolume': 0.0,
    'avgBuyCost': 0.0,
    'avgSellProfit': 0.0,
    'gasFees': 0,
    'balance': {
      'sol': 2.45,
      'usd': 428.75,
      'tokens': [
        {'symbol': 'SOL', 'amount': 2.45, 'value': 428.75, 'price': 175.0},
        {'symbol': 'USDC', 'amount': 150.0, 'value': 150.0, 'price': 1.0},
        {'symbol': 'RAY', 'amount': 85.2, 'value': 89.46, 'price': 1.05},
      ]
    },
    'riskChecks': {
      'blacklist': true,
      'largeTransfers': true,
      'honeypot': true,
      'fakeCompleted': true,
    },
    'profitDistribution': {
      '>500%': 0,
      '200%-500%': 0,
      '0%-200%': 0,
      '0%--50%': 0,
      '<-50%': 0,
    }
  };

  @override
  void initState() {
    super.initState();
    _loadWalletData();
  }

  Future<void> _loadWalletData() async {
    setState(() => _isLoading = true);
    // 模拟网络请求
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4ECCA3), Color(0xFF2EAA8A)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  '🔥',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _walletData['address'].substring(0, 8) + '...tiw',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '绑定Twitter',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 4),
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.link, color: Color(0xFF4ECCA3), size: 14),
              label: const Text(
                '跟单',
                style: TextStyle(color: Color(0xFF4ECCA3), fontSize: 11),
              ),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF2A2A2A),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.person_add, color: Colors.white, size: 20),
            color: const Color(0xFF2A2A2A),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('追踪', style: TextStyle(color: Colors.white)),
                onTap: () {},
              ),
              PopupMenuItem(
                child: Text('分享', style: TextStyle(color: Colors.white)),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4ECCA3)),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildWalletInfo(),
                  _buildBalanceSection(),
                  _buildTimeFrameSelector(),
                  _buildStatsCards(),
                  _buildAnalysisSection(),
                  _buildRiskChecks(),
                  _buildProfitDistribution(),
                  _buildTradesList(),
                ],
              ),
            ),
    );
  }

  Widget _buildWalletInfo() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _walletData['address'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade300,
                    fontFamily: 'monospace',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.copy, size: 16, color: Colors.grey.shade400),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'uid:${_walletData['uid']}',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Email:${_walletData['email']}',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.copy, size: 12, color: Colors.grey.shade400),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSection() {
    final balance = _walletData['balance'];
    final totalUsdValue =
        balance['tokens'].fold(0.0, (sum, token) => sum + token['value']);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4ECCA3), Color(0xFF2EAA8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_balance_wallet,
                color: Colors.black,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                '钱包余额',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '刷新',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '\$${totalUsdValue.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '≈ ${balance['sol'].toStringAsFixed(2)} SOL',
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildBalanceAction(
                  Icons.add,
                  '充值',
                  () => _showComingSoon('充值功能'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBalanceAction(
                  Icons.remove,
                  '提现',
                  () => _showComingSoon('提现功能'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBalanceAction(
                  Icons.swap_horiz,
                  '交易',
                  () => _showComingSoon('交易功能'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTokensList(),
        ],
      ),
    );
  }

  Widget _buildBalanceAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.black, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTokensList() {
    final tokens = _walletData['balance']['tokens'] as List;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '代币持仓',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...tokens.map((token) => _buildTokenItem(token)).toList(),
      ],
    );
  }

  Widget _buildTokenItem(Map<String, dynamic> token) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                token['symbol'][0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  token['symbol'],
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${token['amount'].toStringAsFixed(2)} ${token['symbol']}',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${token['value'].toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                '\$${token['price'].toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature即将推出'),
        backgroundColor: const Color(0xFF4ECCA3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildTimeFrameSelector() {
    final timeFrames = ['1d', '7d', '30d', '全部'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: timeFrames.asMap().entries.map((entry) {
          final index = entry.key;
          final timeFrame = entry.value;
          final isSelected = timeFrame == _selectedTimeFrame;
          final isLast = index == timeFrames.length - 1;

          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTimeFrame = timeFrame),
              child: Container(
                margin: EdgeInsets.only(right: isLast ? 0 : 8),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF4ECCA3)
                      : const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  timeFrame,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.grey.shade300,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatsCards() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              '7D已实现利润',
              '\$${_walletData['totalPnL'].toStringAsFixed(0)}',
              '总盈亏',
              Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              '胜率',
              '${_walletData['winRate'].toStringAsFixed(0)}%',
              '分析',
              Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, String subtitle, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '分析',
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildAnalysisRow('余额', '0 SOL (\$0)'),
          _buildAnalysisRow('7D交易数', '0/0'),
          _buildAnalysisRow('7D平均持仓时长', '--'),
          _buildAnalysisRow('7D买入总成本', '\$0'),
          _buildAnalysisRow('7D代币平均买入成本', '\$0'),
          _buildAnalysisRow('7D代币平均实现利润', '\$0'),
          _buildAnalysisRow('7D Gas费用', '0'),
        ],
      ),
    );
  }

  Widget _buildAnalysisRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskChecks() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.security, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                '约鱼检测',
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildRiskCheckItem('黑名单', true),
              ),
              Expanded(
                child: _buildRiskCheckItem('未购买', true),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildRiskCheckItem('卖出量大于买入量', true),
              ),
              Expanded(
                child: _buildRiskCheckItem('五分钟内完成买卖', true),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRiskCheckItem(String label, bool isGreen) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isGreen ? Colors.green : Colors.red,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfitDistribution() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '盈利分布 (0)',
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildProfitDistributionItem('>500%', 0, Colors.green.shade400),
          _buildProfitDistributionItem('200% - 500%', 0, Colors.green.shade300),
          _buildProfitDistributionItem('0% - 200%', 0, Colors.green.shade200),
          _buildProfitDistributionItem('0% - -50%', 0, Colors.red.shade300),
          _buildProfitDistributionItem('<-50%', 0, Colors.red.shade400),
        ],
      ),
    );
  }

  Widget _buildProfitDistributionItem(String range, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              range,
              style: TextStyle(
                color: Colors.grey.shade300,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            count.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradesList() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTabButton('最近盈亏', '最近盈亏'),
                _buildTabButton('持有代币', '持有代币'),
                _buildTabButton('活动', '活动'),
                _buildTabButton('部署代币', '部署代币'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('类型',
                    style:
                        TextStyle(color: Colors.grey.shade400, fontSize: 12)),
              ),
              Expanded(
                flex: 1,
                child: Text('币种',
                    style:
                        TextStyle(color: Colors.grey.shade400, fontSize: 12)),
              ),
              Expanded(
                flex: 1,
                child: Text('总额',
                    style:
                        TextStyle(color: Colors.grey.shade400, fontSize: 12)),
              ),
              Expanded(
                flex: 1,
                child: Text('数量',
                    style:
                        TextStyle(color: Colors.grey.shade400, fontSize: 12)),
              ),
              Expanded(
                flex: 1,
                child: Text('价格',
                    style:
                        TextStyle(color: Colors.grey.shade400, fontSize: 12)),
              ),
              Expanded(
                flex: 1,
                child: Text('利润',
                    style:
                        TextStyle(color: Colors.grey.shade400, fontSize: 12)),
              ),
              Expanded(
                flex: 1,
                child: Text('时长',
                    style:
                        TextStyle(color: Colors.grey.shade400, fontSize: 12)),
              ),
              Expanded(
                flex: 1,
                child: Text('Gas',
                    style:
                        TextStyle(color: Colors.grey.shade400, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '暂无交易数据',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, String key) {
    final isSelected = _selectedTab == key;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = key),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4ECCA3) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey.shade400,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
