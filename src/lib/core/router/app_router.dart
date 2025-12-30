import 'package:go_router/go_router.dart';
import 'package:personal_expense_tracker/core/utils/snackbar.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/expenses/screens/home_screen.dart';
import '../../features/expenses/screens/add_expense_screen.dart';
import '../../features/expenses/screens/edit_expense_screen.dart';
import '../../features/expenses/models/expense_model.dart';

GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: authProvider,
    redirect: (context, state) {
      final loggedIn = authProvider.isAuthenticated;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';

      //* listen for auth message
      final message = authProvider.authMessage;

      if (message != null) {
        showSnackBar(
          message,
          isError: !loggedIn,
        );
        authProvider.clearMessage();
      }

      //* Not logged in → force login
      if (!loggedIn && !isAuthRoute) {
        return '/login';
      }

      //* Logged in → block login/signup
      if (loggedIn && isAuthRoute) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/add-expense',
        name: 'add-expense',
        builder: (context, state) => const AddExpenseScreen(),
      ),
      GoRoute(
        path: '/edit-expense',
        name: 'edit-expense',
        builder: (context, state) {
          final expense = state.extra as ExpenseModel;
          return EditExpenseScreen(expense: expense);
        },
      ),
    ],
  );
}
