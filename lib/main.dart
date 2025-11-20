import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'theme.dart';
import 'models/subscription.dart';

void main() {
  runApp(const TeaApp());
}

class TeaApp extends StatelessWidget {
  const TeaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tea Subscription',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: SplashScreen(subscription: SubscriptionModel()),
    
    );
  }
}
