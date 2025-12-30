import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/config/constants.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/expense_model.dart';
import '../providers/expense_provider.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String _selectedPeriod = 'Day';
  final _totalExpenses = totalIncomeUser;

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final bool isTablet = sw > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Statistics',
          style: TextStyle(
            fontSize: isTablet ? sw * 0.04 : sw * 0.048,
            fontFamily: 'Poppins-Bold',
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<ExpensesProvider>(
        builder: (context, expensesProvider, _) {
          if (expensesProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final expenses = expensesProvider.expenses;

          return SingleChildScrollView(
            padding: EdgeInsets.all(sw * 0.05),
            child: Column(
              children: [
                //* Period Selector
                Container(
                  padding: EdgeInsets.all(sw * 0.01),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      _buildPeriodButton('Day', isTablet, sw),
                      _buildPeriodButton('Week', isTablet, sw),
                      _buildPeriodButton('Month', isTablet, sw),
                      _buildPeriodButton('Year', isTablet, sw),
                    ],
                  ),
                ),

                SizedBox(height: sh * 0.02),

                //* Expense Label
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: sw * 0.03,
                      vertical: sw * 0.015,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      'Expense',
                      style: TextStyle(
                        fontSize: isTablet ? sw * 0.032 : sw * 0.036,
                        fontFamily: 'Poppins-Medium',
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: sh * 0.03),

                //* Graph
                Container(
                  height: sh * 0.3,
                  padding: EdgeInsets.all(sw * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child:
                      _buildLineChart(expenses, isTablet, sw, _totalExpenses),
                ),

                SizedBox(height: sh * 0.03),

                //* Top Spending Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Spending',
                      style: TextStyle(
                        fontSize: isTablet ? sw * 0.038 : sw * 0.042,
                        fontFamily: 'Poppins-Bold',
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.sort,
                        size: isTablet ? sw * 0.05 : sw * 0.06,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),

                SizedBox(height: sh * 0.02),

                //* Top Spending Items
                ...expenses.take(5).map((expense) {
                  return _buildTopSpendingItem(
                    expense: expense,
                    isTablet: isTablet,
                    sw: sw,
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPeriodButton(String period, bool isTablet, double sw) {
    final isSelected = _selectedPeriod == period;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPeriod = period;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: sw * 0.03),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4A9B8E) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            period,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isTablet ? sw * 0.03 : sw * 0.035,
              fontFamily: 'Poppins-Medium',
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLineChart(List<ExpenseModel> expenses, bool isTablet, double sw,
      final double totalExpenses) {
    if (expenses.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(
            fontSize: isTablet ? sw * 0.035 : sw * 0.04,
            fontFamily: 'Poppins-Regular',
            color: Colors.grey[600],
          ),
        ),
      );
    }

    final Map<int, double> monthlyData = {};
    for (var expense in expenses) {
      final month = expense.expenseDate.month;
      monthlyData[month] = (monthlyData[month] ?? 0) + expense.amount;
    }

    final spots = monthlyData.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));

    final maxY = totalExpenses;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[200]!,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                const months = [
                  'Jan',
                  'Feb',
                  'Mar',
                  'Apr',
                  'May',
                  'Jun',
                  'Jul',
                  'Aug',
                  'Sep',
                  'Oct',
                  'Nov',
                  'Dec'
                ];
                if (value.toInt() >= 1 && value.toInt() <= 12) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      months[value.toInt() - 1],
                      style: TextStyle(
                        fontSize: isTablet ? sw * 0.025 : sw * 0.028,
                        fontFamily: 'Poppins-Regular',
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: maxY / 5,
              getTitlesWidget: (value, meta) {
                return Text(
                  '\$${value.toInt()}',
                  style: TextStyle(
                    fontSize: isTablet ? sw * 0.025 : sw * 0.028,
                    fontFamily: 'Poppins-Regular',
                    color: Colors.grey[600],
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 1,
        maxX: 12,
        minY: 0,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: const Color(0xFF4A9B8E),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: const Color(0xFF4A9B8E),
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF4A9B8E).withOpacity(0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: const Color(0xFF4A9B8E),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '\$${spot.y.toStringAsFixed(0)}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopSpendingItem({
    required ExpenseModel expense,
    required bool isTablet,
    required double sw,
  }) {
    IconData _getCategoryIcon(ExpenseCategory category) {
      switch (category) {
        case ExpenseCategory.food:
          return Icons.restaurant;
        case ExpenseCategory.travel:
          return Icons.travel_explore;
        case ExpenseCategory.shopping:
          return Icons.shopping_bag;
        case ExpenseCategory.bills:
          return Icons.receipt;
        case ExpenseCategory.others:
          return Icons.more_horiz;
      }
    }

    Color _getCategoryColor(ExpenseCategory category) {
      switch (category) {
        case ExpenseCategory.food:
          return Colors.orange;
        case ExpenseCategory.travel:
          return Colors.blue;
        case ExpenseCategory.shopping:
          return Colors.purple;
        case ExpenseCategory.bills:
          return Colors.red;
        case ExpenseCategory.others:
          return Colors.grey;
      }
    }

    final dateFormat = DateFormat('MMM dd, yyyy');

    return Container(
      margin: EdgeInsets.only(bottom: sw * 0.03),
      padding: EdgeInsets.all(sw * 0.04),
      decoration: BoxDecoration(
        color: _getCategoryColor(expense.category).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(sw * 0.03),
            decoration: BoxDecoration(
              color: _getCategoryColor(expense.category).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getCategoryIcon(expense.category),
              color: _getCategoryColor(expense.category),
              size: isTablet ? sw * 0.05 : sw * 0.06,
            ),
          ),
          SizedBox(width: sw * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  style: TextStyle(
                    fontSize: isTablet ? sw * 0.035 : sw * 0.04,
                    fontFamily: 'Poppins-Medium',
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  dateFormat.format(expense.expenseDate),
                  style: TextStyle(
                    fontSize: isTablet ? sw * 0.028 : sw * 0.032,
                    fontFamily: 'Poppins-Regular',
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '- \$ ${expense.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTablet ? sw * 0.035 : sw * 0.04,
              fontFamily: 'Poppins-Bold',
              fontWeight: FontWeight.bold,
              color: Colors.red[400],
            ),
          ),
        ],
      ),
    );
  }
}
