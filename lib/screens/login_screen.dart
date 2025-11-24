import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/subscription.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import 'article_editor_screen.dart';
import 'register_screen.dart';
import 'splash_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  String? selectedMethod; // 'phone' or 'email'

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool isLoading = false;

  @override
  void dispose() {
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginWithEmail() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage('\u0412\u0432\u0435\u0434\u0456\u0442\u044c email \u0442\u0430 \u043f\u0430\u0440\u043e\u043b\u044c');
      return;
    }

    setState(() => isLoading = true);

    try {
      final credential = await _authService.loginWithEmail(email, password);
      await _navigateByRole(credential.user);
    } catch (e) {
      _showMessage(e.toString());
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> loginWithGoogle() async {
    setState(() => isLoading = true);

    try {
      final credential = await _authService.loginWithGoogle();
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
            _buildContent(context),
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

  Widget _buildContent(BuildContext context) {
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
                "Essentio",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 50),
              if (selectedMethod == null) ...[
                _animatedButton(
                  text: "\u0423\u0432\u0456\u0439\u0442\u0438 \u0437\u0430 \u0442\u0435\u043b\u0435\u0444\u043e\u043d\u043e\u043c",
                  onTap: () => setState(() => selectedMethod = 'phone'),
                ),
                const SizedBox(height: 20),
                _animatedButton(
                  text: "\u0423\u0432\u0456\u0439\u0442\u0438 \u0437\u0430 email",
                  onTap: () => setState(() => selectedMethod = 'email'),
                ),
                const SizedBox(height: 20),
                _animatedButton(
                  text: "\u0423\u0432\u0456\u0439\u0442\u0438 \u0447\u0435\u0440\u0435\u0437 Google",
                  onTap: isLoading ? null : loginWithGoogle,
                ),
              ],
              if (selectedMethod == 'phone')
                _fade(
                  Column(
                    children: [
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: _inputDecoration("\u041d\u043e\u043c\u0435\u0440 \u0442\u0435\u043b\u0435\u0444\u043e\u043d\u0443"),
                      ),
                      const SizedBox(height: 16),
                      _submitButton(
                        text: "\u0423\u0432\u0456\u0439\u0442\u0438",
                        onTap: isLoading
                            ? null
                            : () => _showMessage(
                                '\u041b\u043e\u0433\u0456\u043d \u0437\u0430 \u0442\u0435\u043b\u0435\u0444\u043e\u043d\u043e\u043c \u043f\u043e\u043a\u0438 \u043d\u0435 \u043d\u0430\u043b\u0430\u0448\u0442\u043e\u0432\u0430\u043d\u0438\u0439'),
                      ),
                    ],
                  ),
                ),
              if (selectedMethod == 'email')
                _fade(
                  Column(
                    children: [
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration("Email"),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: _inputDecoration("\u041f\u0430\u0440\u043e\u043b\u044c"),
                      ),
                      const SizedBox(height: 16),
                      _submitButton(
                        text: "\u0423\u0432\u0456\u0439\u0442\u0438",
                        onTap: isLoading ? null : loginWithEmail,
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 40),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 300),
                      pageBuilder: (_, __, ___) => const RegisterScreen(),
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                child: const Text(
                  "\u0417\u0430\u0440\u0435\u0454\u0441\u0442\u0440\u0443\u0432\u0430\u0442\u0438\u0441\u044f",
                  style: TextStyle(
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _animatedButton({
    required String text,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _submitButton({
    required String text,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
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
