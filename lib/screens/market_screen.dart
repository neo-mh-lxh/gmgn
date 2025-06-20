import 'package:flutter/material.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  String _selectedTimeFrame = '5m';
  String _selectedFilter = '全部';

  // 模拟市场数据
  final List<Map<String, dynamic>> _marketData = [
    {
      'symbol': 'YUUMIWEB3',
      'name': 'J7Gr1...5wQ',
      'icon': '🔥',
      'time': '5s',
      'price': 'SOL 0/0',
      'change': '--',
      'holders': 1,
      'volume': '--',
      'marketCap': '--',
      'price24h': '\$0',
      'change24h': 0.0,
      'change1h': 0.0,
      'action': '买入',
      'verified': true,
    },
    {
      'symbol': 'VAMPE',
      'name': 'D8GRe...ump',
      'icon': '🧛',
      'time': '4s',
      'price': 'SOL 0.015/0.015',
      'change': '0%',
      'holders': 1,
      'volume': '--',
      'marketCap': '--',
      'price24h': '\$0',
      'change24h': 0.0,
      'change1h': 0.0,
      'action': '买入',
      'verified': true,
    },
    {
      'symbol': 'DROSS',
      'name': 'KtuK8...ump',
      'icon': '💎',
      'time': '10s',
      'price': 'SOL 93.9/93.9',
      'change': '0%',
      'holders': 1,
      'volume': '0',
      'marketCap': '--/--',
      'price24h': '\$0',
      'change24h': 0.0,
      'change1h': 0.0,
      'action': '买入',
      'verified': false,
      'warning': true,
    },
    {
      'symbol': 'FUNKY',
      'name': 'FCdqK...ump',
      'icon': '🎵',
      'time': '11s',
      'price': 'SOL 0.015/0.015',
      'change': '0%',
      'holders': 1,
      'volume': '--',
      'marketCap': '--',
      'price24h': '\$0',
      'change24h': 0.0,
      'change1h': 0.0,
      'action': '买入',
      'verified': true,
    },
    {
      'symbol': 'DSC',
      'name': '3RyaU...ump',
      'icon': '💿',
      'time': '17s',
      'price': 'SOL 0.015/0.015',
      'change': '\$7.9K',
      'holders': 11,
      'volume': '16',
      'marketCap': '13/3',
      'price24h': '\$2.4K',
      'change24h': 86.8,
      'change1h': 86.8,
      'action': '买入',
      'verified': true,
      'hot': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          '市场数据',
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
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () => _showFilterDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterTabs(),
          _buildTableHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: _marketData.length,
              itemBuilder: (context, index) =>
                  _buildTokenItem(_marketData[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final filters = ['全部', '新币', '热门', '涨幅榜', '跌幅榜'];

    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;

          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedFilter = filter);
              },
              selectedColor: const Color(0xFF4ECCA3),
              backgroundColor: const Color(0xFF2A2A2A),
              labelStyle: TextStyle(
                color: isSelected ? Colors.black : Colors.grey.shade300,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color:
                    isSelected ? const Color(0xFF4ECCA3) : Colors.grey.shade600,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade700),
        ),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: _buildHeaderCell('币种')),
          Expanded(flex: 2, child: _buildHeaderCell('时间')),
          Expanded(flex: 3, child: _buildHeaderCell('池子/初始池')),
          Expanded(flex: 2, child: _buildHeaderCell('市值')),
          Expanded(flex: 2, child: _buildHeaderCell('持有者')),
          Expanded(flex: 2, child: _buildHeaderCell('价格')),
          SizedBox(width: 80, child: _buildHeaderCell('操作')),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTokenItem(Map<String, dynamic> token) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade800),
        ),
      ),
      child: Row(
        children: [
          // 币种信息
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ECCA3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      token['icon'],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              token['symbol'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (token['verified'] == true)
                            const Icon(
                              Icons.verified,
                              color: Color(0xFF4ECCA3),
                              size: 14,
                            ),
                          if (token['warning'] == true)
                            const Icon(
                              Icons.warning,
                              color: Colors.orange,
                              size: 14,
                            ),
                        ],
                      ),
                      Text(
                        token['name'],
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 时间
          Expanded(
            flex: 2,
            child: Text(
              token['time'],
              style: TextStyle(
                color: Colors.grey.shade300,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // 池子/初始池
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  token['price'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  token['change'],
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // 市值
          Expanded(
            flex: 2,
            child: Text(
              token['marketCap'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // 持有者
          Expanded(
            flex: 2,
            child: Text(
              token['holders'].toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // 价格
          Expanded(
            flex: 2,
            child: Text(
              token['change24h'] > 0 ? '\$0.07967' : '--',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // 操作按钮
          SizedBox(
            width: 80,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4ECCA3),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: const Size(60, 28),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(
                token['action'],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          '筛选选项',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '更多筛选功能开发中...',
              style: TextStyle(color: Colors.grey.shade400),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '关闭',
              style: TextStyle(color: Color(0xFF4ECCA3)),
            ),
          ),
        ],
      ),
    );
  }
}
