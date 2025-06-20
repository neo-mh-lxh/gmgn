import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyTradingScreen extends StatefulWidget {
  const CopyTradingScreen({super.key});

  @override
  State<CopyTradingScreen> createState() => _CopyTradingScreenState();
}

class _CopyTradingScreenState extends State<CopyTradingScreen> {
  String _followMode = '闪电模式';
  String _buyMethod = '最大跟买';
  String _sellMethod = '自动跟卖';
  double _buyAmount = 0.0;
  double _fixedAmount = 0.0;
  double _fixedRatio = 0.0;
  bool _autoFollow = true;
  bool _isAdvancedExpanded = true;
  double _slippage = 0.005;
  double _priorityFee = 0.00131;
  bool _mevProtection = true;

  final _walletController = TextEditingController(
      text: '59w8VJgKqVpQbFTaqGSiViYKpGtjR91VHXZEcjmomtiw');

  @override
  void dispose() {
    _walletController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          '钱包跟单',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.school, color: Colors.white),
            onPressed: () => _showTutorial(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildModeSelector(),
            const SizedBox(height: 24),
            _buildWalletSection(),
            const SizedBox(height: 24),
            _buildBuyMethodSection(),
            const SizedBox(height: 24),
            _buildAmountSection(),
            const SizedBox(height: 24),
            _buildSellMethodSection(),
            const SizedBox(height: 24),
            _buildStopLossSection(),
            const SizedBox(height: 24),
            _buildAdvancedSettings(),
            const SizedBox(height: 32),
            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF4ECCA3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.flash_on, color: Colors.black, size: 16),
                const SizedBox(width: 4),
                const Text(
                  '闪电模式',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            '极速上链',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.help_outline, color: Colors.grey.shade400, size: 16),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF4ECCA3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.bolt, color: Colors.black, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(Icons.account_balance_wallet,
                      color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  const Text(
                    'W1 Wallet',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '59w8...tiw',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
            const SizedBox(width: 8),
            Icon(Icons.copy, color: Colors.grey.shade400, size: 14),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(Icons.menu, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  const Text('0',
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                  const SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down,
                      color: Colors.grey.shade400, size: 16),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          '跟单钱包地址',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade700),
          ),
          child: TextField(
            controller: _walletController,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '输入要跟单的钱包地址',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBuyMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildMethodButton('最大跟买', _buyMethod == '最大跟买', () {
              setState(() => _buyMethod = '最大跟买');
            }),
            const SizedBox(width: 12),
            _buildMethodButton('固定金额', _buyMethod == '固定金额', () {
              setState(() => _buyMethod = '固定金额');
            }),
            const SizedBox(width: 12),
            _buildMethodButton('固定比例', _buyMethod == '固定比例', () {
              setState(() => _buyMethod = '固定比例');
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildMethodButton(String title, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color:
                isSelected ? const Color(0xFF4ECCA3) : const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  isSelected ? const Color(0xFF4ECCA3) : Colors.grey.shade600,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.grey.shade300,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.help_outline,
                color: isSelected ? Colors.black54 : Colors.grey.shade500,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '数量',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            const Text(
              'SOL',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade700),
          ),
          child: Row(
            children: [
              const Text(
                '≈\$0(0SOL)',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const Spacer(),
              const Text(
                '余额: 0SOL',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSellMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '卖出方式',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Icon(Icons.help_outline, color: Colors.grey.shade400, size: 16),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _sellMethod = '自动跟卖'),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: _sellMethod == '自动跟卖'
                        ? const Color(0xFF4ECCA3)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _sellMethod == '自动跟卖'
                          ? const Color(0xFF4ECCA3)
                          : Colors.grey.shade600,
                    ),
                  ),
                  child: Text(
                    '自动跟卖',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _sellMethod == '自动跟卖'
                          ? Colors.black
                          : Colors.grey.shade300,
                      fontWeight: _sellMethod == '自动跟卖'
                          ? FontWeight.w600
                          : FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _sellMethod = '不跟卖'),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: _sellMethod == '不跟卖'
                        ? const Color(0xFF4ECCA3)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _sellMethod == '不跟卖'
                          ? const Color(0xFF4ECCA3)
                          : Colors.grey.shade600,
                    ),
                  ),
                  child: Text(
                    '不跟卖',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _sellMethod == '不跟卖'
                          ? Colors.black
                          : Colors.grey.shade300,
                      fontWeight: _sellMethod == '不跟卖'
                          ? FontWeight.w600
                          : FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStopLossSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        '自定义止盈止损',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAdvancedSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () =>
              setState(() => _isAdvancedExpanded = !_isAdvancedExpanded),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Text(
                  '高级设置',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ECCA3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    '1',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '展开',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const Spacer(),
                const Text(
                  '清除',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(width: 8),
                Icon(
                  _isAdvancedExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        if (_isAdvancedExpanded) ...[
          const SizedBox(height: 16),
          _buildAdvancedOption('自动', '0.005', '关'),
          const SizedBox(height: 16),
          _buildSlippageSection(),
          const SizedBox(height: 16),
          _buildPriorityFeeSection(),
          const SizedBox(height: 16),
          _buildMevProtectionSection(),
        ],
      ],
    );
  }

  Widget _buildAdvancedOption(String title1, String value1, String title2) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(title1,
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
          const SizedBox(width: 24),
          Row(
            children: [
              const Icon(Icons.speed, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(value1,
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
          const SizedBox(width: 24),
          Row(
            children: [
              const Icon(Icons.shield, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(title2,
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
          const Spacer(),
          Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  Widget _buildSlippageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '滑点',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF4ECCA3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '自动',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade600),
                ),
                child: Text(
                  '自定义    %',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade300),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriorityFeeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '优先费(SOL)',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text(
              '自动 0.00131',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.shade600),
              ),
              child: const Text(
                '0.005',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMevProtectionSection() {
    return Row(
      children: [
        const Text(
          '防夹节点提交',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        const Spacer(),
        Switch(
          value: _mevProtection,
          onChanged: (value) => setState(() => _mevProtection = value),
          activeColor: const Color(0xFF4ECCA3),
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _confirmFollow(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4ECCA3),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          '确认',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showTutorial() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          '跟单教程',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '跟单功能可以自动复制其他钱包的交易操作...',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '了解',
              style: TextStyle(color: Color(0xFF4ECCA3)),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmFollow() {
    if (_walletController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入钱包地址'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          '确认跟单',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          '确认跟单钱包：${_walletController.text.substring(0, 8)}...?',
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '取消',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('跟单设置已保存'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text(
              '确认',
              style: TextStyle(color: Color(0xFF4ECCA3)),
            ),
          ),
        ],
      ),
    );
  }
}
