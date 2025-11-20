import 'package:flutter/material.dart';
import '../models/subscription.dart';
import 'budget_screen.dart';

class ChangeSubscriptionScreen extends StatelessWidget {
  final SubscriptionModel subscription;

  const ChangeSubscriptionScreen({super.key, required this.subscription});

  void _changeEffect(BuildContext context, String effect) {
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
    final currentBudget = subscription.budget.toInt();

    final effects = [
      'Енергія',
      'Релакс',
      'Концентрація',
      'Баланс',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Змінити підписку')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Поточний бюджет: $currentBudget ₴ / міс.',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Оберіть інший тип підписки з тим самим бюджетом:',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: effects.map((e) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      title: Text(e),
                      subtitle: const Text(
                        'Залишити поточний бюджет, змінити підбір чаїв.',
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _changeEffect(context, e),
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
