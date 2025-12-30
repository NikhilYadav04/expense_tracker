import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_expense_tracker/core/config/constants.dart';
import 'package:personal_expense_tracker/features/expenses/providers/expense_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/expense_model.dart';

class EditExpenseScreen extends StatefulWidget {
  final ExpenseModel expense;

  const EditExpenseScreen({
    super.key,
    required this.expense,
  });

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;

  late ExpenseCategory _selectedCategory;
  late DateTime _selectedDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense.title);
    _amountController =
        TextEditingController(text: widget.expense.amount.toString());
    _selectedCategory = widget.expense.category;
    _selectedDate = widget.expense.expenseDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4A9B8E),
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _showCategoryPicker() {
    final sw = MediaQuery.of(context).size.width;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //* Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: sw * 0.15,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Select Category',
                  style: TextStyle(
                    fontSize: sw * 0.05,
                    fontFamily: 'Poppins-Bold',
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              ...ExpenseCategory.values.map((category) {
                return ListTile(
                  leading: Icon(
                    _getCategoryIcon(category),
                    color: const Color(0xFF4A9B8E),
                  ),
                  title: Text(
                    category.displayName,
                    style: const TextStyle(
                      fontFamily: 'Poppins-Regular',
                    ),
                  ),
                  trailing: _selectedCategory == category
                      ? const Icon(
                          Icons.check_circle,
                          color: Color(0xFF4A9B8E),
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  IconData _getCategoryIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return Icons.restaurant;

      case ExpenseCategory.shopping:
        return Icons.shopping_bag;

      case ExpenseCategory.bills:
        return Icons.receipt;
      case ExpenseCategory.travel:
        return Icons.travel_explore;
      case ExpenseCategory.others:
        return Icons.person;
    }
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<ExpensesProvider>();
    final futureExpense =
        (totalIncomeUser - provider.totalExpenses) - double.parse(_amountController.text.trim());

    if (futureExpense < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Oops! Your expenses exceed your income. Try adjusting your spending'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await context.read<ExpensesProvider>().updateExpense(
            id: widget.expense.id,
            title: _titleController.text.trim(),
            amount: double.parse(_amountController.text),
            category: _selectedCategory,
            expenseDate: _selectedDate,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Expense updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final bool isTablet = sw > 600;
    final dateFormat = DateFormat('EEE, dd MMM yyyy');

    return Scaffold(
      backgroundColor: const Color(0xFF4A9B8E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Edit Expense',
          style: TextStyle(
            color: Colors.white,
            fontSize: isTablet ? sw * 0.04 : sw * 0.05,
            fontFamily: 'Poppins-Medium',
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Show options menu
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: sh * 0.02),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(sw * 0.06),
                  children: [
                    // Name field
                    Text(
                      'NAME',
                      style: TextStyle(
                        fontSize: isTablet ? sw * 0.025 : sw * 0.03,
                        fontFamily: 'Poppins-Medium',
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: sh * 0.01),
                    TextFormField(
                      controller: _titleController,
                      style: TextStyle(
                        fontSize: isTablet ? sw * 0.035 : sw * 0.04,
                        fontFamily: 'Poppins-Regular',
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter expense name',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontFamily: 'Poppins-Regular',
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF4A9B8E),
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: sw * 0.04,
                          vertical: sw * 0.04,
                        ),
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: sh * 0.025),

                    // Amount field
                    Text(
                      'AMOUNT',
                      style: TextStyle(
                        fontSize: isTablet ? sw * 0.025 : sw * 0.03,
                        fontFamily: 'Poppins-Medium',
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: sh * 0.01),
                    TextFormField(
                      controller: _amountController,
                      style: TextStyle(
                        fontSize: isTablet ? sw * 0.035 : sw * 0.04,
                        fontFamily: 'Poppins-Regular',
                      ),
                      decoration: InputDecoration(
                        prefixText: '\$ ',
                        prefixStyle: TextStyle(
                          fontSize: isTablet ? sw * 0.035 : sw * 0.04,
                          fontFamily: 'Poppins-Regular',
                          color: const Color(0xFF4A9B8E),
                        ),
                        suffixIcon: _amountController.text.isNotEmpty
                            ? IconButton(
                                icon: Text(
                                  'Clear',
                                  style: TextStyle(
                                    fontSize:
                                        isTablet ? sw * 0.028 : sw * 0.032,
                                    fontFamily: 'Poppins-Regular',
                                    color: const Color(0xFF4A9B8E),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _amountController.clear();
                                  });
                                },
                              )
                            : null,
                        hintText: '0.00',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontFamily: 'Poppins-Regular',
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF4A9B8E),
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: sw * 0.04,
                          vertical: sw * 0.04,
                        ),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      onChanged: (value) {
                        setState(() {}); // Rebuild to show/hide clear button
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        final amount = double.tryParse(value);
                        if (amount == null || amount <= 0) {
                          return 'Please enter a valid amount';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: sh * 0.025),

                    //* Date field
                    Text(
                      'DATE',
                      style: TextStyle(
                        fontSize: isTablet ? sw * 0.025 : sw * 0.03,
                        fontFamily: 'Poppins-Medium',
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: sh * 0.01),
                    InkWell(
                      onTap: _selectDate,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: sw * 0.04,
                          vertical: sw * 0.04,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              dateFormat.format(_selectedDate),
                              style: TextStyle(
                                fontSize: isTablet ? sw * 0.035 : sw * 0.04,
                                fontFamily: 'Poppins-Regular',
                                color: Colors.black87,
                              ),
                            ),
                            Icon(
                              Icons.calendar_today,
                              size: isTablet ? sw * 0.04 : sw * 0.05,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: sh * 0.025),

                    //* Category field
                    Text(
                      'Category',
                      style: TextStyle(
                        fontSize: isTablet ? sw * 0.025 : sw * 0.03,
                        fontFamily: 'Poppins-Medium',
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: sh * 0.01),
                    InkWell(
                      onTap: _showCategoryPicker,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: sw * 0.04,
                          vertical: sw * 0.04,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getCategoryIcon(_selectedCategory),
                              size: isTablet ? sw * 0.045 : sw * 0.055,
                              color: const Color(0xFF4A9B8E),
                            ),
                            SizedBox(width: sw * 0.02),
                            Text(
                              _selectedCategory.displayName,
                              style: TextStyle(
                                fontSize: isTablet ? sw * 0.035 : sw * 0.04,
                                fontFamily: 'Poppins-Regular',
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: sh * 0.04),

                    //* Submit button
                    SizedBox(
                      width: double.infinity,
                      height: isTablet ? sw * 0.08 : sw * 0.13,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleUpdate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A9B8E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Update Expense',
                                style: TextStyle(
                                  fontSize: isTablet ? sw * 0.035 : sw * 0.042,
                                  fontFamily: 'Poppins-Medium',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
