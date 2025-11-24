import 'dart:async';
import 'package:flutter/material.dart';
import '../models/subscription.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  final SubscriptionModel subscription;

  const SplashScreen({super.key, required this.subscription});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // FIX: навігація після рендера
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(seconds: 2), () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(subscription: widget.subscription),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/splash.png',
              width: 180,
              height: 180,
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(strokeWidth: 2),
          ],
        ),
      ),
    );
  }
}
