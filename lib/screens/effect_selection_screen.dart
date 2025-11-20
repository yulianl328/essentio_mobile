import 'package:flutter/material.dart';
import '../models/subscription.dart';
import 'budget_screen.dart';

class EffectSelectionScreen extends StatelessWidget {
  final SubscriptionModel subscription;

  const EffectSelectionScreen({super.key, required this.subscription});

  void _select(BuildContext context, String effect) {
    subscription.selectEffect(effect);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BudgetScreen(subscription: subscription),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.secondary;

    final effects = [
      ('Енергія', Icons.flash_on, 'Бадьорість, м\'яка стимуляція.'),
      ('Релакс', Icons.bedtime, 'Заспокоєння та вечірні ритуали.'),
      ('Концентрація', Icons.center_focus_strong, 'Фокус та ясність думок.'),
      ('Баланс', Icons.self_improvement, 'Спокійна бадьорість на день.')
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Оберіть ефект')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Оберіть один ефект — ми автоматично підберемо найкращий набір із 2–3 чаїв.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: effects.map((e) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () => _select(context, e.$1),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          children: [
                            Icon(e.$2, color: accent, size: 28),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.$1,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    e.$3,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right)
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
