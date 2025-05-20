import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EarningsScreen extends ConsumerWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Dummy data
    const double currentBalance = 1850.50;
    const double weeklyEarnings = 100;
    const double totalEarnings = 200;
    const int completedDeliveries = 124;
    const double averageEarningPerDelivery = 103.23;

    // Weekly earnings data
    final weeklyData = [
      _EarningDay('Mon', 450.0),
      _EarningDay('Tue', 620.0),
      _EarningDay('Wed', 380.0),
      _EarningDay('Thu', 540.0),
      _EarningDay('Fri', 710.0),
      _EarningDay('Sat', 890.0),
      _EarningDay('Sun', 260.0),
    ];

    // Recent transactions
    final transactions = [
      _Transaction('Delivery #4582', '2023-06-15 14:30', 85.50, true),
      _Transaction('Delivery #4581', '2023-06-15 12:15', 92.00, true),
      _Transaction('Delivery #4580', '2023-06-15 10:45', 78.25, true),
      _Transaction('Cash Withdrawal', '2023-06-14 18:20', -500.00, false),
      _Transaction('Delivery #4579', '2023-06-14 16:10', 65.75, true),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Fixed Header
          _buildAppHeader(context),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Balance Card
                  _buildBalanceCard(currentBalance),

                  const SizedBox(height: 24),

                  // Stats cards
                  _buildStatsRow(
                    weeklyEarnings,
                    totalEarnings,
                    completedDeliveries,
                    averageEarningPerDelivery,
                  ),

                  const SizedBox(height: 24),

                  // Weekly earnings chart
                  _buildWeeklyEarningsChart(weeklyData),

                  const SizedBox(height: 24),

                  // Recent transactions
                  _buildTransactionsList(transactions),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "My Earnings",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                "Track your income",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.help_outline, size: 28, color: Colors.grey[600]),
            onPressed: () {
              // Navigate to help screen
              context.go('/help');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(double balance) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.teal[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Available Balance",
              style: TextStyle(
                fontSize: 16,
                color: Colors.teal[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "$balance SAR",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.teal[900],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      // Withdraw action
                    },
                    child: const Text(
                      "Withdraw",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.teal[600]!),
                    ),
                    onPressed: () {
                      // View history
                    },
                    child: Text(
                      "History",
                      style: TextStyle(
                        color: Colors.teal[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(
      double weeklyEarnings,
      double totalEarnings,
      int completedDeliveries,
      double averageEarning,
      ) {
    return Row(
      children: [
        Expanded(child: _buildEarningStatCard("This Week", weeklyEarnings, Icons.calendar_today)),
        const SizedBox(width: 12),
        Expanded(child: _buildEarningStatCard("Total", totalEarnings, Icons.attach_money)),
        const SizedBox(width: 12),
        Expanded(child: _buildEarningStatCard("Deliveries", completedDeliveries.toDouble(), Icons.delivery_dining)),
      ],
    );
  }

  Widget _buildEarningStatCard(String title, double value, IconData icon) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Reduced padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min, // Added this
              children: [
                Container(
                  padding: const EdgeInsets.all(4), // Reduced padding
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(icon, size: 16, color: Colors.teal), // Reduced size
                ),
                const SizedBox(width: 8), // Added spacing
                if (title == "Deliveries")
                  Flexible( // Wrapped in Flexible
                    child: Text(
                      value.toInt().toString(),
                      style: const TextStyle(
                        fontSize: 16, // Reduced font size
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis, // Added overflow handling
                    ),
                  )
                else
                  Flexible( // Wrapped in Flexible
                    child: Text(
                      "${value.toStringAsFixed(2)} SAR",
                      style: const TextStyle(
                        fontSize: 16, // Reduced font size
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis, // Added overflow handling
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12, // Reduced font size
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyEarningsChart(List<_EarningDay> data) {
    final maxValue = data.map((e) => e.amount).reduce((a, b) => a > b ? a : b);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Weekly Earnings",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "June 12-18",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: data.map((stat) {
                  final height = (stat.amount / maxValue) * 120;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 24,
                        height: height,
                        decoration: BoxDecoration(
                          color: Colors.teal[800],
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(
                            colors: [Colors.teal[600]!, Colors.green[400]!],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            stat.amount.toStringAsFixed(0),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        stat.day,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList(List<_Transaction> transactions) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recent Transactions",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: transactions.map((transaction) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: transaction.isDelivery
                              ? Colors.teal[50]
                              : Colors.orange[50],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          transaction.isDelivery ? Icons.delivery_dining : Icons.account_balance_wallet,
                          color: transaction.isDelivery
                              ? Colors.teal[600]
                              : Colors.orange[600],
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction.description,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              transaction.dateTime,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "${transaction.amount > 0 ? '+' : ''}${transaction.amount.toStringAsFixed(2)} SAR",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: transaction.amount > 0 ? Colors.teal[600] : Colors.red[600],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () {
                  // View all transactions
                },
                child: const Text(
                  "View All Transactions",
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EarningDay {
  final String day;
  final double amount;

  _EarningDay(this.day, this.amount);
}

class _Transaction {
  final String description;
  final String dateTime;
  final double amount;
  final bool isDelivery;

  _Transaction(this.description, this.dateTime, this.amount, this.isDelivery);
}