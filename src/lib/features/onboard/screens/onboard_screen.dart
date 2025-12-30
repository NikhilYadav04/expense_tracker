import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final bool isTablet = sw > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: sw * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              //* Image container with responsive dimensions
              Container(
                width: isTablet ? sw * 0.7 : sw * 0.88,
                height: isTablet ? sh * 0.5 : sh * 0.45,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius:
                      BorderRadius.circular(isTablet ? sw * 0.04 : sw * 0.05),
                  border: Border.all(
                    color: Colors.grey[200]!,
                    width: isTablet ? 3 : 2,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    //* Main illustration image
                    Image.asset(
                      'assets/onboard1.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.account_balance_wallet_outlined,
                          size: sw * 0.3,
                          color: const Color(0xFF4A9B8E),
                        );
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: sh * 0.04),

              //* Title text
              Text(
                'Spend Smarter',
                style: TextStyle(
                  fontSize: isTablet ? sw * 0.05 : sw * 0.08,
                  fontFamily: 'Poppins-Bold',
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4A9B8E),
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),

              Text(
                'Save More',
                style: TextStyle(
                  fontSize: isTablet ? sw * 0.05 : sw * 0.08,
                  fontFamily: 'Poppins-Bold',
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4A9B8E),
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: sh * 0.04),

              //* Get Started button
              SizedBox(
                width: double.infinity,
                height: isTablet ? sw * 0.08 : sw * 0.14,
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/signup');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A9B8E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          isTablet ? sw * 0.025 : sw * 0.04),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: isTablet ? sw * 0.032 : sw * 0.045,
                      fontFamily: 'Poppins-Medium',
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: sh * 0.025),

              //* Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already Have Account? ',
                    style: TextStyle(
                      fontSize: isTablet ? sw * 0.028 : sw * 0.035,
                      fontFamily: 'Poppins-Regular',
                      color: Colors.grey,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push('/login');
                    },
                    child: Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: isTablet ? sw * 0.028 : sw * 0.035,
                        fontFamily: 'Poppins-Medium',
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF4A9B8E),
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
