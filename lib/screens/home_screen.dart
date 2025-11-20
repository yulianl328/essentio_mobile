import 'package:flutter/material.dart';
import '../models/subscription.dart';
import 'tea_selection_screen.dart';
import 'effect_selection_screen.dart';
import 'my_subscription_screen.dart';
import 'effect_sets_screen.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  final SubscriptionModel subscription;

  const HomeScreen({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Essentio')),
      drawer: AppDrawer(subscription: subscription),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              '\u0412\u0430\u0448 \u0441\u0442\u0430\u043d \u0432\u0430\u0436\u043b\u0438\u0432\u0438\u0439',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            _Option(
              icon: Icons.favorite_outline,
              title: '\u0427\u0430\u0439 \u0437\u0430 \u0441\u043c\u0430\u043a\u043e\u043c',
              subtitle: '\u041e\u0431\u0438\u0440\u0430\u0439 \u0434\u043e 3 \u0443\u043b\u044e\u0431\u043b\u0435\u043d\u0438\u0445 \u0447\u0430\u0457\u0432',
              onTap: () {
                subscription.type = SubscriptionType.byTea;
                subscription.selectedTeas.clear();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TeaSelectionScreen(subscription: subscription),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            _Option(
              icon: Icons.self_improvement,
              title: '\u0427\u0430\u0439 \u0437\u0430 \u0435\u0444\u0435\u043a\u0442\u043e\u043c',
              subtitle:
                  '\u0411\u0430\u0434\u044c\u043e\u0440\u0456\u0441\u0442\u044c, \u043a\u043e\u043d\u0446\u0435\u043d\u0442\u0440\u0430\u0446\u0456\u044f, \u0441\u043e\u043d, \u0434\u0435\u0442\u043e\u043a\u0441',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EffectSelectionScreen(subscription: subscription),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            _Option(
              icon: Icons.subscriptions,
              title: '\u041c\u043e\u044f \u043f\u0456\u0434\u043f\u0438\u0441\u043a\u0430',
              subtitle: '\u041f\u0435\u0440\u0435\u0433\u043b\u044f\u043d\u0443\u0442\u0438 \u0441\u0432\u043e\u044e \u0430\u043a\u0442\u0438\u0432\u043d\u0443 \u043f\u0456\u0434\u043f\u0438\u0441\u043a\u0443',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        MySubscriptionScreen(subscription: subscription),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            _Option(
              icon: Icons.auto_awesome,
              title: '\u041d\u0430\u0431\u043e\u0440\u0438 \u043f\u043e \u0435\u0444\u0435\u043a\u0442\u0443',
              subtitle:
                  '\u0413\u043e\u0442\u043e\u0432\u0456 \u043d\u0430\u0431\u043e\u0440\u0438 \u043f\u043e 9 \u0447\u0430\u0457\u0432 \u0434\u043b\u044f: \u0415\u043d\u0435\u0440\u0433\u0456\u0457, \u041a\u043e\u043d\u0446\u0435\u043d\u0442\u0440\u0430\u0446\u0456\u0457, \u0420\u0435\u043b\u0430\u043a\u0441\u0443',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        EffectSetsScreen(subscription: subscription),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _Option({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Icon(icon, size: 36, color: Theme.of(context).colorScheme.secondary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
