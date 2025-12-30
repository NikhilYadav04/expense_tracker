import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_expense_tracker/features/auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final responseMessage = await authProvider.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Signup successful!'),
        backgroundColor: Colors.green,
      ),
    );

    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final bool isTablet = sw > 600;

    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(sw * 0.05),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: isTablet ? 500 : sw * 0.9,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(isTablet ? sw * 0.025 : sw * 0.04),
                border: Border.all(
                  color: const Color(0xFF00BCD4),
                  width: 3,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(sw * 0.08),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon
                      Container(
                        padding: EdgeInsets.all(sw * 0.04),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_outlined,
                          size: isTablet ? sw * 0.08 : sw * 0.12,
                          color: const Color(0xFF00BCD4),
                        ),
                      ),

                      SizedBox(height: sh * 0.025),

                      // Title
                      Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: isTablet ? sw * 0.045 : sw * 0.06,
                          fontFamily: 'Poppins-Bold',
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      SizedBox(height: sh * 0.008),

                      // Subtitle
                      Text(
                        'Sign up to get started with\nyour financial journey.',
                        style: TextStyle(
                          fontSize: isTablet ? sw * 0.028 : sw * 0.032,
                          fontFamily: 'Poppins-Regular',
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: sh * 0.04),

                      // Email field
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Email Address',
                          style: TextStyle(
                            fontSize: isTablet ? sw * 0.028 : sw * 0.032,
                            fontFamily: 'Poppins-Medium',
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(height: sh * 0.008),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          fontSize: isTablet ? sw * 0.03 : sw * 0.038,
                          fontFamily: 'Poppins-Regular',
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontFamily: 'Poppins-Regular',
                          ),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            size: isTablet ? sw * 0.045 : sw * 0.055,
                            color: Colors.grey[600],
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
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
                              color: Color(0xFF00BCD4),
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: sw * 0.04,
                            vertical: sw * 0.04,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: sh * 0.02),

                      // Password field
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Password',
                          style: TextStyle(
                            fontSize: isTablet ? sw * 0.028 : sw * 0.032,
                            fontFamily: 'Poppins-Medium',
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(height: sh * 0.008),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: TextStyle(
                          fontSize: isTablet ? sw * 0.03 : sw * 0.038,
                          fontFamily: 'Poppins-Regular',
                        ),
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontFamily: 'Poppins-Regular',
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outlined,
                            size: isTablet ? sw * 0.045 : sw * 0.055,
                            color: Colors.grey[600],
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: isTablet ? sw * 0.045 : sw * 0.055,
                              color: Colors.grey[600],
                            ),
                            onPressed: () {
                              setState(
                                  () => _obscurePassword = !_obscurePassword);
                            },
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
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
                              color: Color(0xFF00BCD4),
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: sw * 0.04,
                            vertical: sw * 0.04,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: sh * 0.02),

                      // Confirm Password field
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Confirm Password',
                          style: TextStyle(
                            fontSize: isTablet ? sw * 0.028 : sw * 0.032,
                            fontFamily: 'Poppins-Medium',
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(height: sh * 0.008),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        style: TextStyle(
                          fontSize: isTablet ? sw * 0.03 : sw * 0.038,
                          fontFamily: 'Poppins-Regular',
                        ),
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontFamily: 'Poppins-Regular',
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outlined,
                            size: isTablet ? sw * 0.045 : sw * 0.055,
                            color: Colors.grey[600],
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: isTablet ? sw * 0.045 : sw * 0.055,
                              color: Colors.grey[600],
                            ),
                            onPressed: () {
                              setState(() => _obscureConfirmPassword =
                                  !_obscureConfirmPassword);
                            },
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
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
                              color: Color(0xFF00BCD4),
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: sw * 0.04,
                            vertical: sw * 0.04,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: sh * 0.035),

                      // Signup button
                      SizedBox(
                        width: double.infinity,
                        height: isTablet ? sw * 0.08 : sw * 0.13,
                        child: ElevatedButton(
                          onPressed: _handleSignup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6B7280),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: isTablet ? sw * 0.035 : sw * 0.042,
                              fontFamily: 'Poppins-Medium',
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: sh * 0.025),

                      // Login link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              fontSize: isTablet ? sw * 0.028 : sw * 0.032,
                              fontFamily: 'Poppins-Regular',
                              color: Colors.grey[700],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.go('/login'),
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: isTablet ? sw * 0.028 : sw * 0.032,
                                fontFamily: 'Poppins-Medium',
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF00BCD4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
