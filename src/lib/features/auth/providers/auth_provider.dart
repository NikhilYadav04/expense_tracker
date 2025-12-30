import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _authMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get authMessage => _authMessage;

  AuthProvider() {
    _user = Supabase.instance.client.auth.currentUser;

    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      _user = data.session?.user;
      notifyListeners();
    });
  }

  void clearMessage() {
    _authMessage = null;
  }

  Future<String> signUp({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      _user = response.user;
      _authMessage = 'Signup successful. Please verify your email.';

      return _authMessage!;
    } on AuthException catch (e) {
      _authMessage = e.message;
      return _authMessage!;
    } catch (e) {
      _authMessage = 'Something went wrong. Please try again.';
      return _authMessage!;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      _user = response.user;
      _authMessage = 'Login successful';

      return _authMessage!;
    } on AuthException catch (e) {
      _authMessage = e.message;
      return _authMessage!;
    } catch (e) {
      _authMessage = 'Something went wrong. Please try again.';
      return _authMessage!;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    _user = null;
    _authMessage = 'Logged out successfully';
    notifyListeners();
  }
}
