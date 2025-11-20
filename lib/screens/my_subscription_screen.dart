import 'package:flutter/material.dart';
import '../models/subscription.dart';
import '../models/tea.dart';
import 'change_subscription_screen.dart';
import 'home_screen.dart';

class MySubscriptionScreen extends StatefulWidget {
  final SubscriptionModel subscription;

  const MySubscriptionScreen({super.key, required this.subscription});

  @override
  State<MySubscriptionScreen> createState() => _MySubscriptionScreenState();
}

class _MySubscriptionScreenState extends State<MySubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    final subscription = widget.subscription;
    final accent = Theme.of(context).colorScheme.secondary;
    final gramsMap = subscription.calculateGramsMap();
    final totalGrams = subscription.totalGrams(map: gramsMap);
    final bonusTeas = subscription.bonusSamples();

    return Scaffold(
      appBar: AppBar(
        title: const Text('\u041c\u043e\u044f \u043f\u0456\u0434\u043f\u0438\u0441\u043a\u0430'),
      ),
      body: subscription.selectedTeas.isEmpty
          ? const Center(
              child: Text(
                '\u041f\u0456\u0434\u043f\u0438\u0441\u043a\u0430 \u0449\u0435 \u043d\u0435 \u043d\u0430\u043b\u0430\u0448\u0442\u043e\u0432\u0430\u043d\u0430',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _RoundedCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '\u0415\u0444\u0435\u043a\u0442 \u043f\u0456\u0434\u043f\u0438\u0441\u043a\u0438',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              subscription.selectedEffect ??
                                  '\u041a\u043e\u0440\u0438\u0441\u0442\u0443\u0432\u0430\u0446\u044c\u043a\u0438\u0439 \u0432\u0438\u0431\u0456\u0440',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _RoundedCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '\u041e\u0431\u0440\u0430\u043d\u0456 \u0447\u0430\u0457',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...subscription.selectedTeas.map((Tea tea) {
                              final grams = gramsMap[tea] ?? 0;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.local_cafe, size: 22),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tea.name,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            '${tea.effect} - ${tea.taste}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '$grams \u0433',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            const SizedBox(height: 4),
                            Text(
                              '\u0420\u0430\u0437\u043e\u043c: ~$totalGrams \u0433',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _RoundedCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '\u0411\u044e\u0434\u0436\u0435\u0442',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${subscription.budget.toInt()} \u0433\u0440\u043d / \u043c\u0456\u0441.',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (subscription.hasFreeShipping)
                        _BonusRow(
                          icon: Icons.local_shipping_outlined,
                          color: Colors.green,
                          label:
                              '\u0411\u0435\u0437\u043a\u043e\u0448\u0442\u043e\u0432\u043d\u0430 \u0434\u043e\u0441\u0442\u0430\u0432\u043a\u0430 \u0430\u043a\u0442\u0438\u0432\u043e\u0432\u0430\u043d\u0430.',
                        ),
                      if (subscription.hasSampleBonus) ...[
                        const SizedBox(height: 8),
                        _BonusRow(
                          icon: Icons.star_border,
                          color: Colors.orange,
                          label: bonusTeas.isEmpty
                              ? '\u0411\u043e\u043d\u0443\u0441\u043d\u0456 \u043f\u0440\u043e\u0431\u043d\u0438\u043a\u0438 \u0431\u0443\u0434\u0443\u0442\u044c \u043f\u0456\u0434\u0456\u0431\u0440\u0430\u043d\u0456 \u0430\u0432\u0442\u043e\u043c\u0430\u0442\u0438\u0447\u043d\u043e.'
                              : '\u041f\u0440\u043e\u0431\u043d\u0438\u043a\u0438: ${bonusTeas.map((t) => t.name).join(', ')}.',
                        ),
                      ],
                    ],
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ChangeSubscriptionScreen(subscription: subscription),
                                ),
                              );
                            },
                            child: const Text(
                                '\u0417\u043c\u0456\u043d\u0438\u0442\u0438 \u043f\u0456\u0434\u043f\u0438\u0441\u043a\u0443'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      HomeScreen(subscription: subscription),
                                ),
                              );
                            },
                            child: const Text(
                                '\u0421\u0442\u0432\u043e\u0440\u0438\u0442\u0438 \u043d\u043e\u0432\u0443 \u043f\u0456\u0434\u043f\u0438\u0441\u043a\u0443'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _RoundedCard extends StatelessWidget {
  final Widget child;

  const _RoundedCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: child,
      ),
    );
  }
}

class _BonusRow extends StatelessWidget {
  final IconData icon;
  final MaterialColor color;
  final String label;

  const _BonusRow({
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
