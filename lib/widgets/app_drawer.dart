import 'package:flutter/material.dart';
import '../models/subscription.dart';
import '../screens/change_subscription_screen.dart';
import '../screens/my_subscription_screen.dart';
import '../screens/about_essentio_screen.dart';
import '../screens/contact_us_screen.dart';
import '../screens/useful_materials_screen.dart';
import '../screens/profile_screen.dart';

class AppDrawer extends StatelessWidget {
  final SubscriptionModel subscription;

  const AppDrawer({super.key, required this.subscription});

  String get subscriptionLabel {
    if (subscription.selectedTeas.isEmpty) {
      return 'Ще немає обраних чаїв';
    }

    final effect = subscription.selectedEffect ??
        subscription.selectedTeas.first.effect;

    return '$effect • ${subscription.budget.toInt()} грн / міс.';
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.secondary;

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: accent.withOpacity(0.08),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    color: accent.withOpacity(0.12),
                  ),
                  child: const Icon(Icons.emoji_nature, size: 30),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Essentio Tea',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'user@example.com', // тимчасовий e-mail
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subscriptionLabel,
                        style: TextStyle(
                          fontSize: 12,
                          color: accent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Головна'),
            onTap: () => Navigator.popUntil(context, (r) => r.isFirst),
          ),
          ListTile(
            leading: const Icon(Icons.subscriptions_outlined),
            title: const Text('Моя підписка'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      MySubscriptionScreen(subscription: subscription),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text('Змінити підписку'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ChangeSubscriptionScreen(subscription: subscription),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Про Essentio'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AboutEssentioScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Профіль'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.support_agent),
            title: const Text('З\'язатися з нами'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ContactUsScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book_outlined),
            title: const Text('Корисні матеріали'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const UsefulMaterialsScreen(),
                ),
              );
            },
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Ми не надсилаємо спам. Обіцяємо.',
              style: TextStyle(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
