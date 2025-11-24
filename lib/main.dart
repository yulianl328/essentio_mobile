import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'models/subscription.dart';
import 'screens/article_editor_screen.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';
import 'services/auth_service.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: тимчасово без Firebase
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
      home: const _AuthRouter(),
    );
  }
}

class _AuthRouter extends StatelessWidget {
  const _AuthRouter();

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _LoadingScreen();
        }

        final user = snapshot.data;

        if (user == null) {
          return const LoginScreen();
        }

        return FutureBuilder<String>(
          future: authService.getUserRole(user.uid),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const _LoadingScreen();
            }

            final role = roleSnapshot.data ?? 'user';
            final subscription = SubscriptionModel();

            if (role == 'admin') {
              return const ArticleEditorScreen();
            }

            return SplashScreen(subscription: subscription);
          },
        );
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
