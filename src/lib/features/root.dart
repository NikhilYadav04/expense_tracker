import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_expense_tracker/features/expenses/screens/home_screen.dart';
import 'package:personal_expense_tracker/features/expenses/screens/statistics_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const StatisticsScreen(),
    Container(
      color: Colors.white,
      child: const Center(
        child: Text(
          'Wallet Screen',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    ),
    Container(
      color: Colors.white,
      child: const Center(
        child: Text(
          'Profile Screen',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final bool isTablet = sw > 600;

    return Scaffold(
      body: _screens[_currentIndex],
      floatingActionButton: Container(
        width: isTablet ? sw * 0.12 : sw * 0.16,
        height: isTablet ? sw * 0.12 : sw * 0.16,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF4A9B8E), Color(0xFF3A8577)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4A9B8E).withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            context.push('/add-expense');
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(
            Icons.add,
            size: isTablet ? sw * 0.06 : sw * 0.08,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 8,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Container(
          height: isTablet ? sw * 0.12 : sw * 0.16,
          padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //* Left side items
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      icon: Icons.home,
                      index: 0,
                      isTablet: isTablet,
                      sw: sw,
                    ),
                    _buildNavItem(
                      icon: Icons.bar_chart_rounded,
                      index: 1,
                      isTablet: isTablet,
                      sw: sw,
                    ),
                  ],
                ),
              ),

              //* Space for FAB
              SizedBox(width: sw * 0.2),

              //* Right side items
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      icon: Icons.account_balance_wallet_outlined,
                      index: 2,
                      isTablet: isTablet,
                      sw: sw,
                    ),
                    _buildNavItem(
                      icon: Icons.person_outline,
                      index: 3,
                      isTablet: isTablet,
                      sw: sw,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required bool isTablet,
    required double sw,
  }) {
    final isSelected = _currentIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: sw * 0.04,
          vertical: sw * 0.02,
        ),
        child: Icon(
          icon,
          size: isTablet ? sw * 0.05 : sw * 0.07,
          color: isSelected ? const Color(0xFF4A9B8E) : Colors.grey[400],
        ),
      ),
    );
  }
}
