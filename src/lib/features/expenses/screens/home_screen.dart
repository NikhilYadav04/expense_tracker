import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/config/constants.dart';
import 'package:personal_expense_tracker/features/expenses/providers/expense_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/expense_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ExpensesProvider>().fetchExpenses());
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final bool isTablet = sw > 600;

    return Scaffold(
      backgroundColor: const Color(0xFF4A9B8E),
      body: SafeArea(
        child: Consumer<ExpensesProvider>(
          builder: (context, expensesProvider, _) {
            final user = context.watch<AuthProvider>().user;
            final userName = user?.email?.split('@')[0] ?? 'User';

            //* Calculate income and expenses
            final totalExpenses = expensesProvider.totalExpenses;
            final totalIncome = totalIncomeUser;
            final totalBalance = totalIncome - totalExpenses;

            return Column(
              children: [
                //* Header Section
                Padding(
                  padding: EdgeInsets.all(sw * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good afternoon,',
                                style: TextStyle(
                                  fontSize: isTablet ? sw * 0.032 : sw * 0.038,
                                  fontFamily: 'Poppins-Regular',
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              Text(
                                userName.substring(0, 1).toUpperCase() +
                                    userName.substring(1),
                                style: TextStyle(
                                  fontSize: isTablet ? sw * 0.045 : sw * 0.055,
                                  fontFamily: 'Poppins-Bold',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.notifications_outlined,
                                  color: Colors.white,
                                  size: isTablet ? sw * 0.05 : sw * 0.06,
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                  size: isTablet ? sw * 0.05 : sw * 0.06,
                                ),
                                onPressed: () async {
                                  final shouldLogout = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(
                                        'Logout',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: Text(
                                        'Are you sure you want to logout?',
                                        style: TextStyle(
                                          fontSize: isTablet
                                              ? sw * 0.032
                                              : sw * 0.035,
                                          fontFamily: 'Poppins-Regular',
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 33, 112, 99),
                                            ),
                                          ),
                                        ),
                                        FilledButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStatePropertyAll(
                                            Color.fromARGB(255, 33, 112, 99),
                                          )),
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text('Logout'),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (shouldLogout == true && mounted) {
                                    await context
                                        .read<AuthProvider>()
                                        .signOut();
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: sh * 0.025),

                      //* Balance Card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(sw * 0.05),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5DAA97),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Balance',
                                  style: TextStyle(
                                    fontSize:
                                        isTablet ? sw * 0.032 : sw * 0.035,
                                    fontFamily: 'Poppins-Regular',
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                                Icon(
                                  Icons.more_horiz,
                                  color: Colors.white,
                                  size: isTablet ? sw * 0.05 : sw * 0.06,
                                ),
                              ],
                            ),
                            SizedBox(height: sh * 0.01),
                            Text(
                              '\$ ${totalBalance.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: isTablet ? sw * 0.065 : sw * 0.08,
                                fontFamily: 'Poppins-Bold',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: sh * 0.02),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildIncomeExpenseCard(
                                    icon: Icons.arrow_downward,
                                    label: 'Income',
                                    amount: totalIncome,
                                    isIncome: true,
                                    isTablet: isTablet,
                                    sw: sw,
                                  ),
                                ),
                                SizedBox(width: sw * 0.03),
                                Expanded(
                                  child: _buildIncomeExpenseCard(
                                    icon: Icons.arrow_upward,
                                    label: 'Expenses',
                                    amount: totalExpenses,
                                    isIncome: false,
                                    isTablet: isTablet,
                                    sw: sw,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //* Expenses List Section
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(sw * 0.05),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Income & Expense Listing',
                                style: TextStyle(
                                  fontSize: isTablet ? sw * 0.038 : sw * 0.042,
                                  fontFamily: 'Poppins-Bold',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: expensesProvider.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : expensesProvider.error != null
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            size: 80,
                                            color: Colors.red[300],
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Error loading expenses',
                                            style: TextStyle(
                                              fontSize: isTablet
                                                  ? sw * 0.04
                                                  : sw * 0.045,
                                              fontFamily: 'Poppins-Medium',
                                              color: Colors.red[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : expensesProvider.expenses.isEmpty
                                      ? Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.receipt_long_outlined,
                                                size: 80,
                                                color: Colors.grey[400],
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                'No expenses yet',
                                                style: TextStyle(
                                                  fontSize: isTablet
                                                      ? sw * 0.04
                                                      : sw * 0.045,
                                                  fontFamily: 'Poppins-Medium',
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Tap the + button to add one',
                                                style: TextStyle(
                                                  fontSize: isTablet
                                                      ? sw * 0.03
                                                      : sw * 0.035,
                                                  fontFamily: 'Poppins-Regular',
                                                  color: Colors.grey[500],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : RefreshIndicator(
                                          onRefresh: () =>
                                              expensesProvider.fetchExpenses(),
                                          child: ListView.builder(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: sw * 0.05,
                                            ),
                                            itemCount: expensesProvider
                                                .expenses.length,
                                            itemBuilder: (context, index) {
                                              final expense = expensesProvider
                                                  .expenses[index];
                                              return _ExpenseListItem(
                                                expense: expense,
                                                isTablet: isTablet,
                                                sw: sw,
                                                onDelete: () => expensesProvider
                                                    .deleteExpense(expense.id),
                                              );
                                            },
                                          ),
                                        ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildIncomeExpenseCard({
    required IconData icon,
    required String label,
    required double amount,
    required bool isIncome,
    required bool isTablet,
    required double sw,
  }) {
    return Container(
      padding: EdgeInsets.all(sw * 0.03),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(sw * 0.02),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: isTablet ? sw * 0.04 : sw * 0.045,
            ),
          ),
          SizedBox(width: sw * 0.02),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isTablet ? sw * 0.025 : sw * 0.028,
                    fontFamily: 'Poppins-Regular',
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                Text(
                  '\$ ${amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: isTablet ? sw * 0.032 : sw * 0.038,
                    fontFamily: 'Poppins-Bold',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseListItem extends StatelessWidget {
  final ExpenseModel expense;
  final bool isTablet;
  final double sw;
  final VoidCallback onDelete;

  const _ExpenseListItem({
    required this.expense,
    required this.isTablet,
    required this.sw,
    required this.onDelete,
  });

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

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Container(
      margin: EdgeInsets.only(bottom: sw * 0.03),
      child: InkWell(
        onTap: () {
          context.push('/edit-expense', extra: expense);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(sw * 0.03),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(sw * 0.03),
                decoration: BoxDecoration(
                  color: _getCategoryColor(expense.category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
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
              SizedBox(
                width: sw * 0.03,
              ),
              InkWell(
                onTap: () async {
                  //* Delete

                  final shouldDelete = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'Delete',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: Text(
                        'Are you sure you want to delete the task?',
                        style: TextStyle(
                          fontSize: isTablet ? sw * 0.032 : sw * 0.035,
                          fontFamily: 'Poppins-Regular',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color.fromARGB(255, 33, 112, 99),
                            ),
                          ),
                        ),
                        FilledButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                            Color.fromARGB(255, 33, 112, 99),
                          )),
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  if (shouldDelete == true) {
                    onDelete(); 
                  }
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFF4A9B8E),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(sw * 0.01),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                    size: isTablet ? sw * 0.035 : sw * 0.04,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
