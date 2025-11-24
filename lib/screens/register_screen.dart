import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/subscription.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import 'article_editor_screen.dart';
import 'splash_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  String? selectedMethod;

  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final AuthService _authService = AuthService();

  bool isLoading = false;

  @override
  void dispose() {
    phone.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> register() async {
    final emailValue = email.text.trim();
    final passwordValue = password.text.trim();

    if (emailValue.isEmpty || passwordValue.isEmpty) {
      _showMessage('\u0412\u0432\u0435\u0434\u0456\u0442\u044c email \u0442\u0430 \u043f\u0430\u0440\u043e\u043b\u044c');
      return;
    }

    setState(() => isLoading = true);

    try {
      final credential =
          await _authService.registerWithEmail(emailValue, passwordValue);
      await _navigateByRole(credential.user);
    } catch (e) {
      _showMessage(e.toString());
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _navigateByRole(User? user) async {
    if (user == null) return;

    final role = await _authService.getUserRole(user.uid);
    final subscription = SubscriptionModel();

    final Widget target =
        role == 'admin' ? const ArticleEditorScreen() : SplashScreen(subscription: subscription);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => target),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = buildAppTheme();
    final bg = theme.colorScheme.background;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Stack(
          children: [
            _buildContent(),
            if (selectedMethod != null)
              Positioned(
                top: 12,
                left: 6,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  onPressed: () {
                    setState(() => selectedMethod = null);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Center(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "\u0420\u0435\u0454\u0441\u0442\u0440\u0430\u0446\u0456\u044f",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 50),
              if (selectedMethod == null) ...[
                _btn("\u0417\u0430\u0440\u0435\u0454\u0441\u0442\u0440\u0443\u0432\u0430\u0442\u0438\u0441\u044f \u0437\u0430 \u0442\u0435\u043b\u0435\u0444\u043e\u043d\u043e\u043c",
                    () => setState(() => selectedMethod = 'phone')),
                const SizedBox(height: 20),
                _btn("\u0417\u0430\u0440\u0435\u0454\u0441\u0442\u0440\u0443\u0432\u0430\u0442\u0438\u0441\u044f \u0437\u0430 email",
                    () => setState(() => selectedMethod = 'email')),
              ],
              if (selectedMethod == 'phone')
                _fade(
                  Column(
                    children: [
                      TextField(
                        controller: phone,
                        decoration: _input("\u041d\u043e\u043c\u0435\u0440 \u0442\u0435\u043b\u0435\u0444\u043e\u043d\u0443"),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      _submit("\u0417\u0430\u0440\u0435\u0454\u0441\u0442\u0440\u0443\u0432\u0430\u0442\u0438\u0441\u044f", () {
                        _showMessage(
                            '\u0420\u0435\u0454\u0441\u0442\u0440\u0430\u0446\u0456\u044f \u0437\u0430 \u0442\u0435\u043b\u0435\u0444\u043e\u043d\u043e\u043c \u043f\u043e\u043a\u0438 \u043d\u0435 \u043d\u0430\u043b\u0430\u0448\u0442\u043e\u0432\u0430\u043d\u0430');
                      })
                    ],
                  ),
                ),
              if (selectedMethod == 'email')
                _fade(
                  Column(
                    children: [
                      TextField(
                        controller: email,
                        decoration: _input("Email"),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: password,
                        decoration: _input("\u041f\u0430\u0440\u043e\u043b\u044c"),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      _submit(
                          "\u0417\u0430\u0440\u0435\u0454\u0441\u0442\u0440\u0443\u0432\u0430\u0442\u0438\u0441\u044f", isLoading ? null : register)
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _btn(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(child: Text(text, style: const TextStyle(fontSize: 18))),
      ),
    );
  }

  Widget _submit(String text, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(text,
              style: const TextStyle(color: Colors.white, fontSize: 17)),
        ),
      ),
    );
  }

  InputDecoration _input(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _fade(Widget child) {
    return AnimatedOpacity(
      opacity: 1,
      duration: const Duration(milliseconds: 300),
      child: child,
    );
  }
}
